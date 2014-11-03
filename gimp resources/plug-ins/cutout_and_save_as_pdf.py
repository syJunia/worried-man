#!/usr/bin/env python
# Will rotate, cutout and save images in dir

import os, re, glob
from gimpfu import *

def cutout_and_save_as_pdf(cropsizeX, cropsizeY, offsetX, offsetY, rotate, sourcedir, globpattern, autolevel, sharpen, sharpwithmask) :
    #pdb.gimp_message(sourcedir)
    gimp.progress_init("Rotating and cropping in: " + sourcedir + "/" + globpattern)
    glob_result = pdb.file_glob(sourcedir + "/" + globpattern, 1)
    globpattern = globpattern.lstrip('*')
    filecount = glob_result[0]
    for f in glob_result[1]:
        imagefile = f
        newfile = imagefile.replace(globpattern, ".pdf")
        # pdb.gimp_message("Opening: " + imagefile + " saving to:" + newfile)
        try:
            image = pdb.gimp_file_load(imagefile, imagefile)
            maxsize = max (pdb.gimp_image_width(image), pdb.gimp_image_height(image))
            pdb.gimp_image_resize(image, maxsize, maxsize, 0, 0)

            # Check a number of user preferences here
            if rotate :
                pdb.gimp_image_rotate(image, ROTATE_90)

            if  autolevel :
                pdb.gimp_levels_stretch(image.layers[0])

            if sharpen :
                pdb.plug_in_sharpen(image, image.layers[0], 40)

            if sharpwithmask :
                pdb.plug_in_unsharp_mask(image, image.layers[0], 5, 0.6, 3)
            # Crop
            pdb.gimp_image_crop(image, cropsizeX, cropsizeY, offsetX, offsetY)
            pdb.gimp_file_save(image, image.layers[0], newfile, newfile)
        except:
            pdb.gimp_message("Opening Error: " + imagefile)

register(
    "python_fu_Rotate_crop_and_store_as_pdf",
    "Will rotate and cut out and then save the image as pdf",
    "Will rotate, cutout and save the scanned bookpage",
    "Sven Tryding",
    "Sven Tryding",
    "2013",
    "Cutout and save as pdf...",
    "",      # Alternately use RGB, RGB*, GRAY*, INDEXED etc.
    [
        (PF_INT, "cropsizeX", "Crop Width (0 for no crop)", 880),
        (PF_INT, "cropsizeY", "Crop Height (0 for no crop)", 730),
        (PF_INT, "cropoffsetX", "Crop Offset X", 286),
        (PF_INT, "cropoffsetY", "Crop Offset Y", 0),
        (PF_BOOL, "rotate", "Rotate 90", TRUE),
        (PF_DIRNAME, "sourcedir", "Directory", "/home/sven/Bilder/scan/"),
        (PF_STRING, "globpattern", "files", "*.jpg"),
        (PF_BOOL, "autolevel", "Autolevel", TRUE),
        (PF_BOOL, "sharpen", "Sharpen", TRUE),
        (PF_BOOL, "sharpwithmask", "Sharp with lightmask", TRUE),
    ],
    [],
    cutout_and_save_as_pdf, menu="<Image>/Filters/Languages/Python-Fu")

main()
