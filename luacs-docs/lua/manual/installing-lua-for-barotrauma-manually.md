# Installing Lua For Barotrauma Manually

## Notice: Using the LuaForBarotrauma package is not required if it's installed manually, but you may use it anyway if you wish to support the mod, since players automatically download packages when joining the server.

## If you are getting TextManager errors, open config_player.xml in your server and change the language from None to English

## Adding Lua For Barotrauma to an existing server
1 - Download [latest version of LuaForBarotrauma](https://github.com/evilfactory/Barotrauma-lua-attempt/releases/tag/latest), choose the correct platform in the assets drop down.<br>
2 - Extract the zip file<br>
3 - Copy the following files inside the extracted zip:<br>

- **DedicatedServer.deps.json**
- **DedicatedServer.dll**
- **DedicatedServer.pdb**
- **0Harmony.dll**
- **Sigil.dll**
- **MoonSharp.Interpreter.dll**
- **MonoMod.Common.dll**
- **Mono.Cecil.dll**
- **Mono.Cecil.Mdb.dll**
- **Mono.Cecil.Pdb.dll**
- **Mono.Cecil.Rocks.dll**
- **Microsoft.CodeAnalysis.CSharp.Scripting.dll**
- **Microsoft.CodeAnalysis.CSharp.dll**
- **Microsoft.CodeAnalysis.dll**
- **Microsoft.CodeAnalysis.Scripting.dll**
- **System.Collections.Immutable.dll**
- **System.Reflection.Metadata.dll**
- **System.Runtime.CompilerServices.Unsafe.dll**
- file that starts with **mscordaccore\_amd64\_amd64\_**
- and the **Lua/** folder

4 - Paste them to your existing server, and let it replace the files<br>

## Adding Lua For Barotrauma to an existing client

Same as above, but instead you need to copy/replace the following files:

- **Barotrauma.deps.json**
- **Barotrauma.dll**
- **Barotrauma.pdb**
- **0Harmony.dll**
- **MoonSharp.Interpreter.dll**
- **MonoMod.Common.dll**
- **Mono.Cecil.dll**
- **Mono.Cecil.Mdb.dll**
- **Mono.Cecil.Pdb.dll**
- **Mono.Cecil.Rocks.dll**
- **Microsoft.CodeAnalysis.CSharp.Scripting.dll**
- **Microsoft.CodeAnalysis.CSharp.dll**
- **Microsoft.CodeAnalysis.dll**
- **Microsoft.CodeAnalysis.Scripting.dll**
- **System.Collections.Immutable.dll**
- **System.Reflection.Metadata.dll**
- **System.Runtime.CompilerServices.Unsafe.dll**
- file that starts with **mscordaccore\_amd64\_amd64\_**
- and the **Lua/** folder


## Using Lua For Barotrauma from scratch

<iframe width="560" height="315" src="https://www.youtube.com/embed/ov0MUOUVB7A" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

1 - Download [latest version of LuaForBarotrauma](https://github.com/evilfactory/Barotrauma-lua-attempt/releases/tag/latest), choose the correct platform in the assets drop down.<br>

2 - Extract the zip file<br>

3 - Find the Content folder in your original Barotrauma game: <br>

 ![](https://cdn.discordapp.com/attachments/799752463619325968/833120013149929492/unknown.png)
 ![](https://cdn.discordapp.com/attachments/799752463619325968/833120379378991104/unknown.png)
 ![](https://cdn.discordapp.com/attachments/799752463619325968/833120841277374464/unknown.png)

4 - Copy the Content folder to the extracted folder <br>

![](https://cdn.discordapp.com/attachments/799752463619325968/833133217300742154/unknown.png)

6 - Optional: Copy config_player.xml from your original game so it retains your configurations.

7 - Done! Now run DedicatedServer.exe to run the modded server or run Barotrauma.exe to run the modded client.<br>

### Linux notice
Sometimes you will get steam initialization errors, most of the time it's because it's missing the linux64/steamclient.so binary, so you can just copy the binary from your steam instalation over to the folder and it should work.



## Checking if everything is working

If the commands `reloadlua` or `cl_reloadlua` work without errors, it means you successfully installed the mod.