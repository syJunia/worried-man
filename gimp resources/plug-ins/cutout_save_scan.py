#!/usr/bin/env python
# Will rotate, cutout and save images in dir

import os, re, glob
from gimpfu import *

def cutout_and_save_scan(sourcedir, globpattern, autolevel, sharpen, sharpwithmask, option) :

    gimp.progress_init("Working in: " + sourcedir + "/" + globpattern)
    glob_result = pdb.file_glob(sourcedir + "/" + globpattern, 1)
    globpattern = globpattern.lstrip('*')
    filecount = glob_result[0]
    #pdb.gimp_message("Filecount is " + str(filecount))
    #pdb.gimp_message("Filecount")
    for f in glob_result[1]:
        imagefile = f
        #pdb.gimp_message("Opening: " + imagefile +f)
        try:
            image = pdb.gimp_file_load(imagefile, imagefile)
            #pdb.gimp_message("File opened")
            maxsize = max (pdb.gimp_image_width(image), pdb.gimp_image_height(image))
            pdb.gimp_image_resize(image, maxsize, maxsize, 0, 0)

            # For scans except 3 pic, 2 sm str , 2 sm big gap rotate !
            if ((option != 1) & (option !=5) & (option !=7)):
                pdb.gimp_image_rotate(image, ROTATE_90)

            # Check a number of user enhancement preferences here
            if  autolevel :
                pdb.gimp_levels_stretch(image.layers[0])

            if sharpen :
                pdb.plug_in_sharpen(image, image.layers[0], 40)

            if sharpwithmask :
                pdb.plug_in_unsharp_mask(image, image.layers[0], 5, 0.6, 3)

            # Cutout pictures
            # 4 pictures scanned
            if option == 0 :

                newfile1 = imagefile.replace(globpattern, "_1.jpg")
                pdb.gimp_rect_select(image, 0, 0, 1738, 1182, 2, 0, 0)
                drawable = pdb.gimp_image_get_active_layer(image)
                pdb.gimp_edit_copy(drawable)
		# create a new image from the copied area:
                new_img = pdb.gimp_edit_paste_as_new()
                new_drawable = pdb.gimp_image_get_active_layer(new_img)
                pdb.gimp_file_save(new_img, new_drawable, newfile1, newfile1)
                pdb.gimp_image_delete(new_img)

                newfile2 = imagefile.replace(globpattern, "_2.jpg")
                pdb.gimp_rect_select(image, 1744, 0, 1738, 1182, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
		# create a new image from the copied area:
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile2, newfile2)
                pdb.gimp_image_delete(new_img)

                newfile3 = imagefile.replace(globpattern, "_3.jpg")
                pdb.gimp_rect_select(image, 0, 1182, 1738, 1182, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile3, newfile3)
                pdb.gimp_image_delete(new_img)

                newfile4 = imagefile.replace(globpattern, "_4.jpg")
                pdb.gimp_rect_select(image, 1744, 1182, 1738, 1182, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
  		# create a new image from the copied area:
		new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile4, newfile4)
                pdb.gimp_image_delete(new_img)

            #  3 Pictures scanned
            if option == 1:
                newfile1 = imagefile.replace(globpattern, "_1.jpg")
                newfile2 = imagefile.replace(globpattern, "_2.jpg")
                newfile3 = imagefile.replace(globpattern, "_3.jpg")
                pdb.gimp_rect_select(image, 308, 0, 2101, 1200, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile1, newfile1)
                pdb.gimp_image_delete(new_img)
                pdb.gimp_rect_select(image, 308, 1243, 2101, 1200, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile2, newfile2)
                pdb.gimp_image_delete(new_img)
                pdb.gimp_rect_select(image, 308, 2546, 2101, 1200, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile3, newfile3)
                pdb.gimp_image_delete(new_img)

            # 2 Medium pictures scanned
            if option == 2:
                newfile1 = imagefile.replace(globpattern, "_1.jpg")
                newfile2 = imagefile.replace(globpattern, "_2.jpg")
                pdb.gimp_rect_select(image, 1424, 0, 2100, 1200, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile1, newfile1)
                pdb.gimp_image_delete(new_img)
                pdb.gimp_rect_select(image, 1424, 1199, 2100, 1200, 2, 0, 0)
                #pdb.gimp_message("Lennart")
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile2, newfile2)
                pdb.gimp_image_delete(new_img)

            # 2 Big pictures scanned
            if option == 3:
                newfile1 = imagefile.replace(globpattern, "_1.jpg")
                newfile2 = imagefile.replace(globpattern, "_2.jpg")
                pdb.gimp_rect_select(image, 852, 0, 2673, 1185, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile1, newfile1)
                pdb.gimp_image_delete(new_img)
                pdb.gimp_rect_select(image, 852, 1189, 2673, 1185, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile2, newfile2)
                pdb.gimp_image_delete(new_img)

            # 2 Panorama pictures scanned
            if option == 4:
                newfile1 = imagefile.replace(globpattern, "_1.jpg")
                newfile2 = imagefile.replace(globpattern, "_2.jpg")
                pdb.gimp_rect_select(image, 770, 0, 2720, 1185, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile1, newfile1)
                pdb.gimp_image_delete(new_img)
                pdb.gimp_rect_select(image, 770, 1189, 2720, 1185, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile2, newfile2)
                pdb.gimp_image_delete(new_img)

            # 2 small pictures scanned, small gap
            if option == 5:
                newfile1 = imagefile.replace(globpattern, "_1.jpg")
                newfile2 = imagefile.replace(globpattern, "_2.jpg")
                pdb.gimp_rect_select(image, 0, 0, 1800, 1200, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile1, newfile1)
                pdb.gimp_image_delete(new_img)
                pdb.gimp_rect_select(image, 0, 1424, 1800, 1200, 2, 0, 0)
                #pdb.gimp_message("Lennart")
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile2, newfile2)
                pdb.gimp_image_delete(new_img)


            # 2 small pictures scanned, rotated
            if option == 6:
                newfile1 = imagefile.replace(globpattern, "_1.jpg")
                newfile2 = imagefile.replace(globpattern, "_2.jpg")
                pdb.gimp_rect_select(image, 1220, 0, 1800, 1200, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile1, newfile1)
                pdb.gimp_image_delete(new_img)
                pdb.gimp_rect_select(image, 1243, 1414, 1800, 1200, 2, 0, 0)
                #pdb.gimp_message("Lennart")
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile2, newfile2)
                pdb.gimp_image_delete(new_img)

            # 2 small pictures scanned, bigger gap
            if option == 7:
                newfile1 = imagefile.replace(globpattern, "_1.jpg")
                newfile2 = imagefile.replace(globpattern, "_2.jpg")
                pdb.gimp_rect_select(image, 410, 320, 1800, 1200, 2, 0, 0)
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile1, newfile1)
                pdb.gimp_image_delete(new_img)
                pdb.gimp_rect_select(image, 410, 2002, 1800, 1200, 2, 0, 0)
                #pdb.gimp_message("Lennart")
                pdb.gimp_edit_copy(image.layers[0])
                new_img = pdb.gimp_edit_paste_as_new()
                pdb.gimp_file_save(new_img, new_img.layers[0], newfile2, newfile2)
                pdb.gimp_image_delete(new_img)



        except:
            pdb.gimp_message("Opening Error: " + imagefile)

register(
    "python_fu_cutout_and_save_scan",
    "Will use user selection of scanned pictures split them and save them as jpg",
    "Will use user selection of scanned pictures save them as jpg files",
    "Sven Tryding",
    "Sven Tryding",
    "2014",
    "Cutout and save scanned pictures...",
    "",      # Alternately use RGB, RGB*, GRAY*, INDEXED etc.
    [
        (PF_DIRNAME, "sourcedir", "Directory", "/home/sven/Bilder/scan/"),
        (PF_STRING, "globpattern", "files", "*.jpeg"),
        (PF_BOOL, "autolevel", "Autolevel", TRUE),
        (PF_BOOL, "sharpen", "Sharpen", TRUE),
        (PF_BOOL, "sharpwithmask", "Sharp with lightmask", TRUE),
        (PF_OPTION, "option", "Scantype", 0, ("4_pic", "3_pic", "2_pic_med",
        "2_pic_big", "2_pic_panorama", "2_pic_small_straight_1",
        "2_small_flipped", "2_small_bigger_gap" )),
    ],
    [],
    cutout_and_save_scan, menu="<Image>/Filters/Languages/Python-Fu")

main()
