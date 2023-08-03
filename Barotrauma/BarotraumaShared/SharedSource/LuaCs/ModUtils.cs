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

    }

    #endregion
}
