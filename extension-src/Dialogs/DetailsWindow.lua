return {
    ShowDetails = function(name, width, height, file, pluginData)
        validate = function(dlg, pluginData)
            if dlg.data.templateName == nil or dlg.data.templateName == "" then
                pluginData.utils.create_error("Template name cannot be blank.", dlg, 0);
                return false
            end
            if dlg.data.templateWidth <= 0 or dlg.data.templateHeight <= 0 then
                pluginData.utils.create_error("Both template dimensions must be positive integers.", dlg, 0);
                return false
            end
            return true
        end
        ----------------------------------------------------------------------------------------
        -- Setup the dialog, and prepare a result object for the return.
        ----------------------------------------------------------------------------------------
        local initName = name;
        local data = { template = { name=name, width=width, height=height, file=file } };
        local dlg = Dialog("Details");

        ----------------------------------------------------------------------------------------
        -- Setup the widgets for the templates data, updating the result on changes.
        ----------------------------------------------------------------------------------------
        dlg:entry{
            id="templateName",
            label="Name",
            text=(data.template.name or "New Template"),
            onchange=function() data.template.name = dlg.data.templateName; end
        }:newrow();

        dlg:number{
            id="templateWidth",
            label="Width",
            decimals=0,
            text=tostring(data.template.width or 128),
            onchange=function() data.template.width = dlg.data.templateWidth; end
        }:newrow();

        dlg:number{
            id="templateHeight",
            label="Height",
            decimals=0,
            text=tostring(data.template.height or 128),
            onchange=function() data.template.height = dlg.data.templateHeight; end
        }:newrow();

        dlg:file{
            id="templateFile",
            open = true,
            load = true,
            entry = false,
            filename = data.template.file,
            filetypes={"ase", "aseprite", "png"},
            onchange=function()
                data.template.file = dlg.data.templateFile;
                local fileSprite = Sprite{fromFile=dlg.data.templateFile};
                local w = fileSprite.width;
                local h = fileSprite.height;
                fileSprite:close();
                data.template.width = w;
                data.template.height = h;
                dlg:modify{id="templateWidth", text=w}
                dlg:modify{id="templateHeight", text=h}
            end
        }:newrow();


        ----------------------------------------------------------------------------------------
        -- Setup the buttons which will set the result action and close the dialog.
        ----------------------------------------------------------------------------------------
        dlg:button{
            id="saveChangesButton",
            text="Save Changes",
            onclick=function()
                if validate(dlg, pluginData) then
                    data.action = "update";
                    dlg:close();
                end
            end
        }

        dlg:button{
            id="addNewButton",
            text="Add As New",
            onclick=function()
                if validate(dlg, pluginData) then
                    if (initName == dlg.data.templateName) then
                        refresh = pluginData.utils.create_confirm("Warning: this will overwrite an existing template! Do you want to continue?");
                        if refresh then
                            data.action = "update";
                            dlg:close();
                        end
                    else 
                        data.action = "add";
                        dlg:close();
                    end
                end
            end
        }

        dlg:button{
            id="deleteButton",
            text="Delete",
            onclick=function()
                refresh = pluginData.utils.create_confirm("Delete template '"..dlg.data.templateName.."'?");
                if refresh then
                    data.action = "delete";
                    dlg:close();
                end
            end
        }

        dlg:button{
            id="cancelButton",
            text="Cancel",
            onclick=function()
                data.action = nil;
                dlg:close();
            end
        }

        dlg:show{wait = true};

        return data;
    end
};