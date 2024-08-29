# Balatro spriting tools for Aseprite
This extension package contains 3 tools, all listed in the File menu in Aseprite.

## Usage
`File > Templates` or `Ctrl+Alt+T` will open the Templates menu. From here you can choose from a number of preset/pre-packaged templates for Balatro art resources, or you can use your own `.aseprite` files. You can also modify the preset templates with your own files to save them for later reuse if you wish by pressing the `Edit` button. This will allow you to both change current presets and create new ones using the same button.

`File > Blindify` will, when used on an exactly 34x34 pixel image, copy that image to the right and add an overlay for creating Blind art assets for Balatro. These assets require a certain width with a particular number of copies of these images in order to animate properly. The blind overlay will handle the shading around the edges of the blind, as well as the animation filter itself.
**UPDATE 8/29/24:** The colors on this feature are now accurate as expected. This should look better overall compared to previous versions.

`File > 1X to 2X scaler` will return a new image tab with exactly double scale of the currently viewed image. Use this for quickly generating 2X resolution assets (which are required for proper image loading).

## Palettes
This package also includes some common palettes used for certain assets. To access them, if you are unfamiliar with Aseprite, press the middle button above the Palette window with the "Presets" tooltip, and search for "Balatro_" to find all of them. Select your preferred palette and press load to reset your base color palette to these presets. It should look like below, the black square with a missing corner.

![image](https://github.com/user-attachments/assets/6e5e74e8-4238-40ed-9cf4-418cdbcff804)

In some versions of Aseprite, it may also [look like this.](https://imgur.com/nlLvOHv)
## Installation
Download the fonts and the `aseprite-extension` file, and open `Edit > Preferences > Extension` in Aseprite, and install the package by clicking add extension and choosing the file.
The fonts can be installed onto your system using the OS-specified manner, which will allow you to select them from a list, or you can keep them somewhere accessible and open them manually from the text menu in Aseprite.

Check `fonts/fonts.txt` for more information on the particulars of each font file and their usage.
