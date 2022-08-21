using System.Diagnostics;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;
using Barotrauma;
using Barotrauma.Networking;

string NormalizeGenericTypeName(string s) {
  var idx = s.LastIndexOf('`');

  if (idx != -1) {
    return s[..idx];
  }

  return s;
}

string TypeToString(Type type, bool useLuaTypes = true) {
  // Return "T" for unresolved type params
  if (type.IsGenericParameter) {
    return type.Name;
  }

  var genericType = type.IsGenericType
    ? type.GetGenericTypeDefinition()
    : null;

  if (type == typeof(bool)) {
    return "bool";
  }

  if (type == typeof(string)) {
    return "string";
  }

  if (useLuaTypes) {
    if (type == typeof(sbyte)
      || type == typeof(byte)
      || type == typeof(short)
      || type == typeof(ushort)
      || type == typeof(int)
      || type == typeof(uint)
      || type == typeof(long)
      || type == typeof(ulong)
      || type == typeof(float)
      || type == typeof(double)) {
      return "number";
    }

    if (genericType == typeof(List<>)
      || genericType == typeof(Dictionary<,>)) {
      return "table";
    }

    if (genericType == typeof(Action<,>)
      || genericType == typeof(Func<,>)) {
      return "function";
    }
  }

  var nsToRemove = new[] {
    "Barotrauma",
    "System",
    "System.Collections",
    "System.Collections.Generic",
  };

  string Namespaced(string typeName) {
    if (type.Namespace == null) {
      return typeName;
    }

    // Full namespace match
    if (nsToRemove.Contains(type.Namespace)) {
      return typeName;
    }

    // Partial namespace match
    foreach (var ns in nsToRemove) {
      if (ns == type.Namespace) {
        return typeName;
      }

      if (type.Namespace.StartsWith(ns + ".")) {
        var shortNs = type.Namespace.Remove(0, ns.Length + 1);
        return $"{shortNs}.{typeName}";
      }
    }

    return $"{type.Namespace}.{typeName}";
  }

  string Impl(string? ns) {
    if (type.IsGenericType) {
      var genericTypeDef = type.GetGenericTypeDefinition();
      var genericTypeName = NormalizeGenericTypeName(genericTypeDef.Name);

      var genericArgs = type.GetGenericArguments();

      // Use the `T?` notation instead of Nullable<T>
      if (genericTypeDef == typeof(Nullable<>)) {
        // ldoc supports the "?string" notation, which expands to "?|nil|string"
        if (useLuaTypes) {
          return Namespaced("?" + TypeToString(genericArgs[0], useLuaTypes: false));
        } else {
          return Namespaced(TypeToString(genericArgs[0], useLuaTypes: false) + "?");
        }
      }

      var sb = new StringBuilder();
      sb.Append(genericTypeName);
      sb.Append("<");
      foreach (var genericArgType in genericArgs) {
        sb.Append(TypeToString(genericArgType, useLuaTypes: false));
        sb.Append(",");
      }
      // Remove the last separator
      sb.Length--;
      sb.Append(">");

      return Namespaced(sb.ToString());
    }

    return Namespaced(type.Name);
  }

  return Impl(type.Namespace);
}

void GenerateDocsImpl(Type type, string baseFile, string outFile, string? categoryName = null) {
  categoryName ??= type.Name;
  var sb = new StringBuilder();

  Console.WriteLine($"Generating docs for {type}");

  string baseLuaText;
  try {
    baseLuaText = File.ReadAllText(baseFile);
  } catch (FileNotFoundException) {
    baseLuaText = @$"-- luacheck: ignore 111

--[[--
{type.FullName}
]]
-- @code {categoryName}
-- @pragma nostrip
local {type.Name} = {{}}".ReplaceLineEndings("\n");

    File.WriteAllText(baseFile, baseLuaText);
  }

  var removeTagPattern = new Regex("^-- @remove (.*)$", RegexOptions.Multiline);
  var removed = new HashSet<string>();
  var matches = removeTagPattern.Matches(baseLuaText);

  foreach (var match in matches.Cast<Match>()) {
    removed.Add(match.Value);
  }

  sb.Append(baseLuaText);
  sb.AppendLine();
  sb.AppendLine();

  var members = type.GetMembers(BindingFlags.Public | BindingFlags.Static | BindingFlags.Instance);
  foreach (var member in members) {
    static string EscapeName(string n) {
      return n switch {
        "end" => "endparam",
        _ => n
      };
    }

    switch (member.MemberType) {
      case MemberTypes.Method: {
        var method = (MethodInfo)member;

        // Exclude property getters/setters
        if (method.IsSpecialName) {
          continue;
        }

        var paramNames = new StringBuilder();
        foreach (var parameter in method.GetParameters()) {
          paramNames.Append(EscapeName(parameter.Name!));
          paramNames.Append(", ");
        }
        if (paramNames.Length > 0) {
          // Remove the last separator
          paramNames.Length -= 2;
        }

        string functionDecoration;
        if (method.IsStatic) {
          functionDecoration = $"function {type.Name}.{method.Name}({paramNames}) end";
        } else {
          functionDecoration = $"function {method.Name}({paramNames}) end";
        }

        if (removed.Contains(functionDecoration)) {
          continue;
        }

        Console.WriteLine($"  - METHOD: {method}");

        sb.AppendLine($"--- {method.Name}");
        sb.AppendLine("-- @realm shared");

        foreach (var parameter in method.GetParameters()) {
          sb.AppendLine($"-- @tparam {TypeToString(parameter.ParameterType)} {EscapeName(parameter.Name!)}");
        }

        if (method.ReturnType != typeof(void)) {
          sb.AppendLine($"-- @treturn {TypeToString(method.ReturnType)}");
        }

        sb.AppendLine(functionDecoration);
        sb.AppendLine();
        break;
      }

      case MemberTypes.Field: {
        var field = (FieldInfo)member;

        var name = EscapeName(field.Name);
        var returnName = TypeToString(field.FieldType);

        if (field.IsStatic) {
          name = type.Name + "." + field.Name;
        }

        if (removed.Contains(name)) {
          continue;
        }

        Console.WriteLine($"  - FIELD: {name}");

        sb.AppendLine("---");
        sb.Append("-- ");
        sb.Append(name);
        sb.AppendLine($", field of type {returnName}");
        sb.AppendLine("-- @realm shared");
        sb.AppendLine($"-- @field {name}");

        sb.AppendLine();
        break;
      }

      case MemberTypes.Property: {
        var property = (PropertyInfo)member;

        var name = EscapeName(property.Name);
        var returnName = TypeToString(property.PropertyType);

        if (property.GetGetMethod()?.IsStatic == true || property.GetSetMethod()?.IsStatic == true) {
          name = type.Name + "." + property.Name;
        }

        if (removed.Contains(name)) {
          continue;
        }

        Console.WriteLine($"  - PROPERTY: {name}");

        sb.AppendLine("---");
        sb.Append("-- ");
        sb.Append(name);
        sb.AppendLine($", field of type {returnName}");
        sb.AppendLine("-- @realm shared");
        sb.AppendLine($"-- @field {name}");

        sb.AppendLine();
        break;
      }
    }
  }

  new FileInfo(outFile).Directory.Create();
  File.WriteAllText(outFile, sb.ToString());
}

var generatedDir = "lua/generated";
var baseLuaDir = "baseluadocs";
void GenerateDocs(Type type, string file, string? categoryName = null) {
  GenerateDocsImpl(type, $"{baseLuaDir}/{file}", $"{generatedDir}/{file}", categoryName);
}

try {
  Directory.Delete(generatedDir, true);
} catch (DirectoryNotFoundException) { }

Directory.CreateDirectory(generatedDir);
Directory.CreateDirectory(baseLuaDir);

GenerateDocs(typeof(Character), "Character.lua");
GenerateDocs(typeof(CharacterInfo), "CharacterInfo.lua");
GenerateDocs(typeof(CharacterHealth), "CharacterHealth.lua");
GenerateDocs(typeof(AnimController), "AnimController.lua");
GenerateDocs(typeof(Client), "Client.lua");
GenerateDocs(typeof(Entity), "Entity.lua");
GenerateDocs(typeof(EntitySpawner), "Entity.Spawner.lua", "Entity.Spawner");
GenerateDocs(typeof(Item), "Item.lua");
GenerateDocs(typeof(ItemPrefab), "ItemPrefab.lua");
GenerateDocs(typeof(Submarine), "Submarine.lua");
GenerateDocs(typeof(SubmarineInfo), "SubmarineInfo.lua");
GenerateDocs(typeof(Job), "Job.lua");
GenerateDocs(typeof(JobPrefab), "JobPrefab.lua");
GenerateDocs(typeof(GameSession), "GameSession.lua", "Game.GameSession");
GenerateDocs(typeof(NetLobbyScreen), "NetLobbyScreen.lua", "Game.NetLobbyScreen");
GenerateDocs(typeof(GameScreen), "GameScreen.lua", "Game.GameScreen");
GenerateDocs(typeof(FarseerPhysics.Dynamics.World), "World.lua", "Game.World");
GenerateDocs(typeof(Inventory), "Inventory.lua", "Inventory");
GenerateDocs(typeof(ItemInventory), "ItemInventory.lua", "ItemInventory");
GenerateDocs(typeof(CharacterInventory), "CharacterInventory.lua", "CharacterInventory");
GenerateDocs(typeof(Hull), "Hull.lua", "Hull");
GenerateDocs(typeof(Level), "Level.lua", "Level");
GenerateDocs(typeof(Affliction), "Affliction.lua", "Affliction");
GenerateDocs(typeof(AfflictionPrefab), "AfflictionPrefab.lua", "AfflictionPrefab");
GenerateDocs(typeof(WayPoint), "WayPoint.lua", "WayPoint");
GenerateDocs(typeof(ServerSettings), "ServerSettings.lua", "Game.ServerSettings");
GenerateDocs(typeof(GameSettings), "GameSettings.lua", "Game.Settings");
