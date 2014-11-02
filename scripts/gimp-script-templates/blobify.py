#!/usr/bin/env python

# Python blobify: make 3-d looking text, similar to Drop Shadow and Bevel,
# but more rounded.
#
# Copyright 2088, Akkana Peck <akkana@shallowsky.com>
# Please share and enjoy under the terms of the GPL v2 or later.

from gimpfu import *
def python_blobify(img, layer, blur) :
    pdb.gimp_undo_push_group_start(img)

    # Select everything non-transparent in the layer
    pdb.gimp_selection_layer_alpha(layer)
    # invert the selection
    pdb.gimp_selection_invert(img)
    # drop shadow on the inverted selection, with no image resizing
    pdb.script_fu_drop_shadow(img, layer, -3, -3, blur,
                              (0, 0, 0), 80.0, False)
    pdb.gimp_selection_none(img)

    pdb.gimp_undo_push_group_end(img)

register(
       	"python_fu_blobify",
	"Create a 3-D effect",
	"Create a blobby 3-D effect using inverse drop-shadow",
	"Akkana Peck",
	"Akkana Peck",
	"2009",
	"BlobiPy...",
	"*",
	[
          (PF_IMAGE, "image", "Input image", None),
          (PF_DRAWABLE, "drawable", "Input layer", None),
          (PF_SPINNER, "blur", "Blur amount",
           7, (0, 50, 1))
	],
	[],
	python_blobify,
        menu="<Image>/Filters/Light and Shadow")

main()
