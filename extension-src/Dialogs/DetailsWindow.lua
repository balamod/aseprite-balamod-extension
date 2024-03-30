return {
    ShowDetails = function(name, width, height, file)
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

        dlg:entry{
            id="templateWidth",
            label="Width",
            decimals=integer,
            text=tostring(data.template.width or 128),
            onchange=function() data.template.width = dlg.data.templateWidth; end
        }:newrow();

        dlg:number{
            id="templateHeight",
            label="Height",
            decimals=integer,
            text=tostring(data.template.height or 128),
            onchange=function() data.template.height = dlg.data.templateHeight; end
        }:newrow();

        dlg:file{
            id="templateFile",
            open = true,
            entry = true,
            filename = file,
            filetypes={"ase", "aseprite", "png"}
        }:newrow();


        ----------------------------------------------------------------------------------------
        -- Setup the buttons which will set the result action and close the dialog.
        ----------------------------------------------------------------------------------------
        dlg:button{
            id="saveChangesButton",
            text="Save Changes",
            onclick=function()
                data.action = "update";
                dlg:close();
            end
        }

        dlg:button{
            id="addNewButton",
            text="Add As New",
            onclick=function()
                -- If the name is the same as the initial, swap the action to an update.
                if (initName == dlg.data.templateName) then
                    data.action = "update";
                else
                    data.action = "add";
                end
                dlg:close();
            end
        }

        dlg:button{
            id="deleteButton",
            text="Delete",
            onclick=function()
                data.action = "delete";
                dlg:close();
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