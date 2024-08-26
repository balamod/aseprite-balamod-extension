-- MIT License

-- Copyright (c) 2024 Balamod

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

function loadFile(data, ...)
    local path = app.fs.joinPath(app.fs.userConfigPath, "extensions", "Balamod_Extension_Tools", ...)
    return loadfile(path)(data)
end

function init(plugin)
    print("Aseprite is initializing Balamod Extension Tools")

    if(plugin.preferences == nil) then
        plugin.preferences = {};
    end

    local debug = false;

    local data = {
        prefs = plugin.preferences,
        json = dofile(app.fs.joinPath(app.fs.userConfigPath, "extensions", "Balamod_Extension_Tools", "json.lua")),
        logger = {
            Log = function(msg) if(debug == true) then print("LOG: " .. msg) end end;
            Error = function(msg)  if(debug == true) then print("ERROR: " .. msg) end end;
            LineBreak = function() if(debug == true) then print("--------------------------------------------------------------------------------------") end end;
        },
        utils = dofile(app.fs.joinPath(app.fs.userConfigPath, "extensions", "Balamod_Extension_Tools", "helpers.lua")),
    };
    print("Registering Balamod Extension Tools menu group")
    plugin:newMenuGroup{
        id="balamod_extension_tools",
        title="Balamod",
        group="main_menu"
    }
    print("Registering Balamod Extension Tools commands")
    print("Registering Balamod Extension Tools Templates command")
    plugin:newCommand {
        id="balamod_extension_tools_templates",
        title="Templates",
        group="balamod_extension_tools",
        onclick=function()
            loadFile(data, "Dialogs", "Templates.lua")
        end
    }
    print("Registering Balamod Extension Tools Blindify command")
    plugin:newCommand {
        id="balamod_extension_tools_blindify",
        title="Blindify",
        group="balamod_extension_tools",
        onclick=function()
            loadFile(data, "Blindify.lua")
        end
    }
    print("Registering Balamod Extension Tools 1X to 2X scaler command")
    plugin:newCommand {
        id="balamod_extension_tools_scaler",
        title="1X to 2X scaler",
        group="balamod_extension_tools",
        onclick=function()
            loadFile(data, "1Xto2X.lua")
        end
    }
    print("Balamod extension tools installed.")
end

function exit(plugin)
    print("Aseprite is closing Balamod Extension Tools")
end