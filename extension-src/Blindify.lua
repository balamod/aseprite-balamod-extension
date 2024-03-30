local cel = app.site.cel
if not cel then
    return app.alert("There is no active image.")
end

local origImg = cel.image:clone()

local r = app.sprite.bounds
local file = "./extensions/Balamod_Extension_Tools/Images/BlindShineOverlay.aseprite"
if r.width == 34 and r.height == 34 then
    r.width = r.width*21
    app.command.CanvasSize{ui=false, bounds=r}
    local newImg = Image(r.width, r.height)
    local x = 0
    app.transaction(function ()
        while x<34*21 do
            newImg:drawImage(origImg, {x, 0})
            x = x+34
        end
        newImg:drawImage(Image{fromFile=file}, {0,0}, 124)
    end)
    cel.image = newImg
    app.refresh()
else
    return app.alert("This is not a proper 1x scale Balatro Blind image. Please use a 34x34 canvas.")
end
