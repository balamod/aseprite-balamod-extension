-- MIT License

-- Copyright (c) 2021 David Fletcher

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

    local function AddCommand(id, title, group, file, loc)
        plugin:newCommand {
            id=id,
            title=title,
            group=group,
            onclick=function()
                loadfile(app.fs.joinPath(app.fs.userConfigPath, "extensions", "Balamod_Extension_Tools", loc, file))(data);
            end
        }
    end

    AddCommand("Balamod_Extension_Templates","Templates","file_new","TemplateWindow.lua", "Dialogs");
    AddCommand("Balamod_Extension_Tools_Blindify", "Blindify", "file_new", "Blindify.lua", "")
    AddCommand("Balamod_Extension_Tools_Scaler", "1X to 2X scaler", "file_new", "1Xto2X.lua", "")

end

function exit(plugin)
    print("Aseprite is closing Balamod Extension Tools")
end