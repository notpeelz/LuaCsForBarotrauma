using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using Barotrauma;
using Barotrauma.Items.Components;
using Barotrauma.Networking;
using Microsoft.CodeAnalysis;

namespace Barotrauma;

public static class ModUtils
{
    #region LOGGING

    public static class Logging
    {
        public static void PrintMessage(string s)
        {
#if SERVER
            LuaCsLogger.LogMessage($"[Server] {s}");
#else
            LuaCsLogger.LogMessage($"[Client] {s}");
#endif
        }
        
        public static void PrintError(string s)
        {
#if SERVER
            LuaCsLogger.LogError($"[Server] {s}");
#else
            LuaCsLogger.LogError($"[Client] {s}");
#endif
        }
    }

    #endregion
    
    #region FILE_IO

    // ReSharper disable once InconsistentNaming
    public static class IO
    {
        public static IEnumerable<string> FindAllFilesInDirectory(string folder, string pattern,
            SearchOption option)
        {
            if (!Directory.Exists(folder))
                return new string[] { };
            return Directory.GetFiles(folder, pattern, option);
        }

        public static string PrepareFilePathString(string filePath) =>
            PrepareFilePathString(Path.GetDirectoryName(filePath)!, Path.GetFileName(filePath));

        public static string PrepareFilePathString(string path, string fileName) => 
            Path.Combine(SanitizePath(path), SanitizeFileName(fileName));

        public static string SanitizeFileName(string fileName)
        {
            foreach (char c in Barotrauma.IO.Path.GetInvalidFileNameCharsCrossPlatform())
                fileName = fileName.Replace(c, '_');
            return fileName;
        }

        public static string SanitizePath(string path)
        {
            foreach (char c in Path.GetInvalidPathChars())
                path = path.Replace(c.ToString(), "_");
            return path.CleanUpPath();
        }

        public static IOActionResultState GetOrCreateFileText(string filePath, out string fileText, Func<string> fileDataFactory = null)
        {
            fileText = null;
            IOActionResultState ioActionResultState = CreateFilePath(filePath, out var fp, fileDataFactory);
            if (ioActionResultState == IOActionResultState.Success)
            {
                try
                {
                    fileText = File.ReadAllText(fp!);
                    return IOActionResultState.Success;
                }
                catch (ArgumentNullException ane)
                {
                    ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: An argument is null. path: {fp ?? "null"} | Exception Details: {ane.Message}");
                    return IOActionResultState.FilePathNull;
                }
                catch (ArgumentException ae)
                {
                    ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: An argument is invalid. path: {fp ?? "null"} | Exception Details: {ae.Message}");
                    return IOActionResultState.FilePathInvalid;
                }
                catch (DirectoryNotFoundException dnfe)
                {
                    ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: Cannot find directory. path: {fp ?? "null"} | Exception Details: {dnfe.Message}");
                    return IOActionResultState.DirectoryMissing;
                }
                catch (PathTooLongException ptle)
                {
                    ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: path length is over 200 characters. path: {fp ?? "null"} | Exception Details: {ptle.Message}");
                    return IOActionResultState.PathTooLong;
                }
                catch (NotSupportedException nse)
                {
                    ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: Operation not supported on your platform/environment (permissions?). path: {fp ?? "null"}  | Exception Details: {nse.Message}");
                    return IOActionResultState.InvalidOperation;
                }
                catch (IOException ioe)
                {
                    ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: IO tasks failed (Operation not supported). path: {fp ?? "null"}  | Exception Details: {ioe.Message}");
                    return IOActionResultState.IOFailure;
                }
                catch (Exception e)
                {
                    ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: Unknown/Other Exception. path: {fp ?? "null"} | ExceptionMessage: {e.Message}");
                    return IOActionResultState.UnknownError;
                }
            }

            return ioActionResultState;
        }

        public static IOActionResultState CreateFilePath(string filePath, out string formattedFilePath, Func<string> fileDataFactory = null)
        {
            string file = Path.GetFileName(filePath);
            string path = Path.GetDirectoryName(filePath)!;

            formattedFilePath = IO.PrepareFilePathString(path, file);
            try
            {
                if (!Directory.Exists(path))
                    Directory.CreateDirectory(path);
                if (!File.Exists(formattedFilePath))
                    File.WriteAllText(formattedFilePath, fileDataFactory is null ? "" : fileDataFactory.Invoke());
                return IOActionResultState.Success;
            }
            catch (ArgumentNullException ane)
            {
                ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: An argument is null. path: {formattedFilePath ?? "null"}  | Exception Details: {ane.Message}");
                return IOActionResultState.FilePathNull;
            }
            catch (ArgumentException ae)
            {
                ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: An argument is invalid. path: {formattedFilePath ?? "null"} | Exception Details: {ae.Message}");
                return IOActionResultState.FilePathInvalid;
            }
            catch (DirectoryNotFoundException dnfe)
            {
                ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: Cannot find directory. path: {path ?? "null"} | Exception Details: {dnfe.Message}");
                return IOActionResultState.DirectoryMissing;
            }
            catch (PathTooLongException ptle)
            {
                ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: path length is over 200 characters. path: {formattedFilePath ?? "null"} | Exception Details: {ptle.Message}");
                return IOActionResultState.PathTooLong;
            }
            catch (NotSupportedException nse)
            {
                ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: Operation not supported on your platform/environment (permissions?). path: {formattedFilePath ?? "null"} | Exception Details: {nse.Message}");
                return IOActionResultState.InvalidOperation;
            }
            catch (IOException ioe)
            {
                ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: IO tasks failed (Operation not supported). path: {formattedFilePath ?? "null"} | Exception Details: {ioe.Message}");
                return IOActionResultState.IOFailure;
            }
            catch (Exception e)
            {
                ModUtils.Logging.PrintError($"ModUtils::CreateFilePath() | Exception: Unknown/Other Exception. path: {path ?? "null"} | Exception Details: {e.Message}");
                return IOActionResultState.UnknownError;
            }
        }

        public static IOActionResultState WriteFileText(string filePath, string fileText)
        {
            IOActionResultState ioActionResultState = CreateFilePath(filePath, out var fp);
            if (ioActionResultState == IOActionResultState.Success)
            {
                try
                {
                    File.WriteAllText(fp!, fileText);
                    return IOActionResultState.Success;
                }
                catch (ArgumentNullException ane)
                {
                    ModUtils.Logging.PrintError($"ModUtils::WriteFileText() | Exception: An argument is null. path: {fp ?? "null"} | Exception Details: {ane.Message}");
                    return IOActionResultState.FilePathNull;
                }
                catch (ArgumentException ae)
                {
                    ModUtils.Logging.PrintError($"ModUtils::WriteFileText() | Exception: An argument is invalid. path: {fp ?? "null"} | Exception Details: {ae.Message}");
                    return IOActionResultState.FilePathInvalid;
                }
                catch (DirectoryNotFoundException dnfe)
                {
                    ModUtils.Logging.PrintError($"ModUtils::WriteFileText() | Exception: Cannot find directory. path: {fp ?? "null"} | Exception Details: {dnfe.Message}");
                    return IOActionResultState.DirectoryMissing;
                }
                catch (PathTooLongException ptle)
                {
                    ModUtils.Logging.PrintError($"ModUtils::WriteFileText() | Exception: path length is over 200 characters. path: {fp ?? "null"} | Exception Details: {ptle.Message}");
                    return IOActionResultState.PathTooLong;
                }
                catch (NotSupportedException nse)
                {
                    ModUtils.Logging.PrintError($"ModUtils::WriteFileText() | Exception: Operation not supported on your platform/environment (permissions?). path: {fp ?? "null"} | Exception Details: {nse.Message}");
                    return IOActionResultState.InvalidOperation;
                }
                catch (IOException ioe)
                {
                    ModUtils.Logging.PrintError($"ModUtils::WriteFileText() | Exception: IO tasks failed (Operation not supported). path: {fp ?? "null"} | Exception Details: {ioe.Message}");
                    return IOActionResultState.IOFailure;
                }
                catch (Exception e)
                {
                    ModUtils.Logging.PrintError($"ModUtils::WriteFileText() | Exception: Unknown/Other Exception. path: {fp ?? "null"} | ExceptionMessage: {e.Message}");
                    return IOActionResultState.UnknownError;
                }
            }

            return ioActionResultState;
        }

        public enum IOActionResultState
        {
            Success, FilePathNull, FilePathInvalid, EntryMissing, DirectoryMissing, PathTooLong, InvalidOperation, IOFailure, UnknownError
        }
    }
    
    #endregion

    #region GAME

    public static class Game
    {
        /// <summary>
        /// Returns whether or not there is a round running.
        /// </summary>
        /// <returns></returns>
        public static bool IsRoundInProgress()
        {
#if CLIENT
            if (Screen.Selected is not null
                && Screen.Selected.IsEditor)
                return false;
#endif
            return GameMain.GameSession is not null && Level.Loaded is not null;
        }
        
        /// <summary>
        /// Given a table of packages and dependent packages, will sort them by dependency loading order along with packages
        /// that cannot be loaded due to errors or failing the predicate checks.
        /// </summary>
        /// <param name="packages">A dictionary/map with key as the package and the elements as it's dependencies.</param>
        /// <param name="readyToLoad">List of packages that are ready to load and in the correct order.</param>
        /// <param name="cannotLoadPackages">Packages with errors or cyclic dependencies.</param>
        /// <param name="packageChecksPredicate">Optional: Allows for a custom checks to be performed on each package.
        /// Returns a bool indicating if the package is ready to load.</param>
        /// <returns>Whether or not the process produces a usable list.</returns>
        public static bool OrderAndFilterPackagesByDependencies(
            Dictionary<ContentPackage, IEnumerable<ContentPackage>> packages,
            out IEnumerable<ContentPackage> readyToLoad,
            out IEnumerable<KeyValuePair<ContentPackage, string>> cannotLoadPackages,
            Func<ContentPackage, bool> packageChecksPredicate = null)
        {
            HashSet<ContentPackage> completedPackages = new();
            List<ContentPackage> readyPackages = new();
            Dictionary<ContentPackage, string> unableToLoad = new();
            HashSet<ContentPackage> currentNodeChain = new();

            readyToLoad = readyPackages;
            cannotLoadPackages = unableToLoad;

            try
            {
                foreach (var toProcessPack in packages)
                {
                    ProcessPackage(toProcessPack.Key, toProcessPack.Value);
                }

                PackageProcRet ProcessPackage(ContentPackage packageToProcess, IEnumerable<ContentPackage> dependencies)
                {
                    //cyclic handling
                    if (unableToLoad.ContainsKey(packageToProcess))
                    {
                        return PackageProcRet.BadPackage;
                    }

                    // already processed
                    if (completedPackages.Contains(packageToProcess))
                    {
                        return PackageProcRet.AlreadyCompleted;
                    }

                    // cyclic check
                    if (currentNodeChain.Contains(packageToProcess))
                    {
                        StringBuilder sb = new();
                        sb.AppendLine("Error: Cyclic Dependency. ")
                            .Append(
                                "The following ContentPackages rely on eachother in a way that makes it impossible to know which to load first! ")
                            .Append(
                                "Note: the package listed twice shows where the cycle starts/ends and is not necessarily the problematic package.");
                        int i = 0;
                        foreach (var package in currentNodeChain)
                        {
                            i++;
                            sb.AppendLine($"{i}. {package.Name}");
                        }

                        sb.AppendLine($"{i}. {packageToProcess.Name}");
                        unableToLoad.Add(packageToProcess, sb.ToString());
                        completedPackages.Add(packageToProcess);
                        return PackageProcRet.BadPackage;
                    }

                    if (packageChecksPredicate is not null && !packageChecksPredicate.Invoke(packageToProcess))
                    {
                        unableToLoad.Add(packageToProcess, $"Unable to load package {packageToProcess.Name} due to failing checks.");
                        completedPackages.Add(packageToProcess);
                        return PackageProcRet.BadPackage;
                    }

                    currentNodeChain.Add(packageToProcess);

                    foreach (ContentPackage dependency in dependencies)
                    {
                        // The mod lists a dependent that was not found during the discovery phase.
                        if (!packages.ContainsKey(dependency))
                        {
                            // search to see if it's enabled
                            if (!ContentPackageManager.EnabledPackages.All.Contains(dependency))
                            {
                                // present warning but allow loading anyways, better to let the user just disable the package if it's really an issue.
                                ModUtils.Logging.PrintError(
                                    $"Warning: the ContentPackage of {packageToProcess.Name} requires the Dependency {dependency.Name} but this package wasn't found in the enabled mods list!");
                            }

                            continue;
                        }

                        var ret = ProcessPackage(dependency, packages[dependency]);

                        if (ret is PackageProcRet.BadPackage)
                        {
                            if (!unableToLoad.ContainsKey(packageToProcess))
                            {
                                unableToLoad.Add(packageToProcess, $"Error: Dependency failure. Failed to load {dependency.Name}");
                            }
                            currentNodeChain.Remove(packageToProcess);
                            if (!completedPackages.Contains(packageToProcess))
                            {
                                completedPackages.Add(packageToProcess);
                            }
                            return PackageProcRet.BadPackage;
                        }
                    }
                    
                    currentNodeChain.Remove(packageToProcess);
                    completedPackages.Add(packageToProcess);
                    readyPackages.Add(packageToProcess); 
                    return PackageProcRet.Completed;
                }
            }
            catch (Exception e)
            {
                ModUtils.Logging.PrintError($"Error while generating dependency loading order! Exception: {e.Message}");
    #if DEBUG
                ModUtils.Logging.PrintError($"Error while generating dependency loading order! Exception: {e.StackTrace}");
    #endif
                return false;
            }

            return true;
        }

        private enum PackageProcRet : byte
        {
            AlreadyCompleted,
            Completed,
            BadPackage
        }
    }

    #endregion
}
