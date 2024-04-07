local pluginData = ...;

local detailsPopup = dofile(app.fs.joinPath(app.fs.userConfigPath, "extensions", "Balamod_Extension_Tools", "Dialogs", "DetailsWindow.lua"));

local function Show()

    ----------------------------------------------------------------------------------------
    -- Initial setup of the dialog and Reset method.
    ----------------------------------------------------------------------------------------
    local dlg = Dialog("Templates");
    local templates = {};
    local templateNames = {};
    local templateCount = 0;

    local function Reset()
        pluginData.prefs.lastBounds = dlg.bounds;
        pluginData.prefs.lastSelection = dlg.data.templateDropdown;
        dlg:close();
        Show();
    end


    ----------------------------------------------------------------------------------------
    -- Helper method to get a template by its name.
    ----------------------------------------------------------------------------------------
    local function TryGetTemplate(templateName)
        for i, template in ipairs(templates) do
            if (template.name == templateName) then
                return template;
            end
        end
        if(templateName == nil) then return end
        pluginData.logger.Log("failed to locate template '"..templateName.."'");
    end

    ----------------------------------------------------------------------------------------
    -- Saves templates to the configuration file.
    ----------------------------------------------------------------------------------------
    local function SaveTemplates()
        pluginData.prefs.templatesJson = pluginData.json.encode({data=templates});
        pluginData.logger.Log("Save Complete.");
    end

    ----------------------------------------------------------------------------------------
    -- Sets template data for some initial 'default' templates.
    ----------------------------------------------------------------------------------------
    local path = "./extensions/Balamod_Extension_Tools/Images/"
    local function SetDefaultTemplates()
        templates = {
            { width = 71, height=95, name="Joker w/ letter borders", file="DefaultJoker+LetterBordering.png"},
            { width = 71, height=95, name="Plain Joker", file="DefaultJoker.png"},
            { width = 71, height=95, name="Joker Stamp (Color)", file="JokerStamp_color.png"},
            { width = 71, height=95, name="Joker Stamp (Silhouette)", file="JokerStamp_shape.png"},
            { width = 355, height=95, name="Basic Planet Cards", file="Planet-Range.png"},
            { width = 71, height=95, name="Planet-1Card", file="Planet-Base1.png"},
            { width = 71, height=95, name="Planet-2Card", file="Planet-Base2.png"},
            { width = 71, height=95, name="Planet-3Card", file="Planet-Base3.png"},
            { width = 71, height=95, name="Planet-4Card", file="Planet-Base4.png"},
            { width = 71, height=95, name="Planet-5Card", file="Planet-Base5.png"},
            { width = 71, height=95, name="Warped Planet Card", file="Planet-Warped.png"},
            { width = 71, height=95, name="Basic Spectral Card", file="Spectral-Base.png"},
            { width = 71, height=95, name="Special Spectral Card (Soul)", file="Spectral-Special.png"},
            { width = 71, height=95, name="Tarot", file="Tarot-Base.png"},
            { width = 71, height=95, name="Seal", file="Seal-Base.png"},
            { width = 284, height=474, name="Booster Packs", file="booster_assets.png"},
            { width = 71, height=95, name="Voucher (Dark)", file="Voucher_Dark.png"},
            { width = 71, height=95, name="Voucher (Light)", file="Voucher_Light.png"},
            { width = 34, height=34, name="Tag", file="Tag-Base.png"},
            { width = 71, height=95, name="Blank Card", file="BlankCard-Base.png"},
            { width = 34, height=34, name="Blind", file="Blind-Base.png"},
            { width = 29, height=29, name="Chips", file="Chip-Base.png"},
            { width = 71, height=95, name="Blank Card Back", file="BlankCard-Back.png"},
        }
        for i, v in ipairs(templates) do
            templates[i].file = app.fs.joinPath(app.fs.userConfigPath, "extensions", "Balamod_Extension_Tools", "Images", v.file)
        end
    end

    ----------------------------------------------------------------------------------------
    -- Loads templates from the configuration file if present, sets defaults if not.
    ----------------------------------------------------------------------------------------
    local function LoadTemplates()
        loadedTemplates = false;
        pluginData.logger.Log("Attempting to load template data from prefs..");
        if(pluginData.prefs.templatesJson ~= nil) then
            local loaded = pluginData.json.decode(pluginData.prefs.templatesJson);
            if(loaded ~= nil) then
                templates = loaded.data;
                loadedTemplates = true;
                pluginData.logger.Log("Successfully parsed from json.");
            end
        end

        if loadedTemplates == false then
            SetDefaultTemplates();
        end

        templateCount = 0;
        for i, template in ipairs(templates) do
            templateCount = templateCount + 1;
            templateNames[templateCount] = template.name;
        end

        pluginData.logger.Log("Successfully loaded "..templateCount.." templates");
    end

    ----------------------------------------------------------------------------------------
    -- Returns an array containing all of the template names in order.
    ----------------------------------------------------------------------------------------
    local function GetTemplateNames()
        names = {};
        for i, template in ipairs(templates) do
            names[i] = template.name;
        end
        return names;
    end

    ----------------------------------------------------------------------------------------
    -- Updates the data for a given template.
    ----------------------------------------------------------------------------------------
    local function UpdateTemplate(name, newData)
        local template = TryGetTemplate(name);
        if(template == nil) then
            app.alert("Failed to update template: "..name);
        else
            template.width = newData.width;
            template.height = newData.height;
            template.name = newData.name;
            template.file = newData.file;
        end
    end

    ----------------------------------------------------------------------------------------
    -- Removes a template by name from the collection.
    ----------------------------------------------------------------------------------------
    local function RemoveTemplate(name)
        pluginData.logger.Log("Removing template: "..name);
        newTemplates = {};
        j = 1;
        for i, template in ipairs(templates) do
            if template.name ~= name then
                newTemplates[j] = template;
                j = j+1;
            end
        end
        templates = newTemplates;
        pluginData.logger.Log("template removal complete.");
    end

    ----------------------------------------------------------------------------------------
    -- Returns the last selected template name if able, else the first templates name
    ----------------------------------------------------------------------------------------
    local function GetInitialSelection()
        local selection = templateNames[1];
        if(pluginData.prefs.lastSelection ~= nil) then
            local temp = TryGetTemplate(pluginData.prefs.lastSelection);
            if(temp ~= nil) then
                selection = pluginData.prefs.lastSelection;
            end
        end
    end

    ----------------------------------------------------------------------------------------
    -- Setup the controls for swapping between file and preset modes.
    ----------------------------------------------------------------------------------------
    local function SetFileDisplayMode(fileMode)
        pluginData.utils.set_visible(dlg, fileMode == false, {"templateDropdown","resetButton","detailsButton","createFromPresetButton"});
        pluginData.utils.set_visible(dlg, fileMode == true, {"createFromFileButton","file"});
    end

    dlg:radio{
        id="radioPreset",
        text="From Preset",
        selected=true,
        onclick=function()
            SetFileDisplayMode(false);
        end
    };

    dlg:radio{
        id="radioFile",
        text="From File",
        selected=false,
        onclick=function()
            SetFileDisplayMode(true);
        end
    };

    dlg:separator{id="tabSeparator"};

    ----------------------------------------------------------------------------------------
    -- UI for opening from a preset template (simple canvas size data).
    ----------------------------------------------------------------------------------------
    LoadTemplates(); -- Make sure templates loaded before we try and setup the combo box.
    dlg:combobox {
        id = "templateDropdown",
        option = GetInitialSelection(),
        options = GetTemplateNames()
    };

    dlg:button{
        id="resetButton",
        text="Reset To Defaults",
        onclick=function()
            if (pluginData.utils.create_confirm("Reset to default templates?")) == true then
                SetDefaultTemplates();
                SaveTemplates();
                Reset();
            end
        end
    };

    dlg:button{
        id="detailsButton",
        text="Edit",
        onclick=function()
            -- Hand of the current template data to a details popup for editing.
            local selected = TryGetTemplate(dlg.data.templateDropdown);
            local result = detailsPopup.ShowDetails(selected.name, selected.width, selected.height, selected.file);

            -- Act on the resulting action from the popup response.
            local refresh = (result.action ~= nil);
            if (result.action == "add") then
                templates[templateCount+1] = result.template;
            elseif (result.action == "delete") then
                refresh = pluginData.utils.create_confirm("Delete template '"..selected.name.."'?");
                if (refresh == true) then
                    RemoveTemplate(result.template.name);
                end
            elseif (result.action == "update") then
                UpdateTemplate(selected.name, result.template);
            end

            -- If we changed anything, refresh the dialog to update displays.
            if(refresh == true) then
                SaveTemplates();
                Reset();
            end
        end
    };

    dlg:button{
        id="createFromPresetButton",
        text="Create",
        onclick=function()
            selected = TryGetTemplate(dlg.data.templateDropdown);
            if selected == nil then
                app.alert("Failed to create template.");
            else
                local original = Sprite{fromFile=selected.file};
                local newSprite = Sprite(original);
                newSprite.filename = pluginData.utils.get_indexed_filename("NewSprite");
                app.activeSprite = newSprite;
                original:close();
                app.refresh();
                dlg:close();
            end
        end
    }:newrow();


    ----------------------------------------------------------------------------------------
    -- UI for opening from a template file (full file copy for detailed templates).
    ----------------------------------------------------------------------------------------
    dlg:file{
        id="file",
        open = true,
        filetypes={"ase", "aseprite", "png"}
    };
    dlg:button{
        id="createFromFileButton",
        text="Create",
        onclick=function()
            local original = Sprite{fromFile=dlg.data.file};
            local newSprite = Sprite(original);
            newSprite.filename = pluginData.utils.get_indexed_filename("NewSprite");
            app.activeSprite = newSprite;
            original:close();
            app.refresh();
            dlg:close();
        end
    }:newrow();

    -- Set the initial display mode to ensure we're only showing one set of UI controls.
    SetFileDisplayMode(false);

    -- Display the dialog, using the last known bounds if possible (minimizes visual impact when 'refreshing').
    if (pluginData.prefs.lastBounds == nil) then
        dlg:show{wait=false};
    else
        dlg:show{
        wait=false,
            bounds=pluginData.prefs.lastBounds
        };
    end
end

Show();

