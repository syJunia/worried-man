;; Basic script-fu template.
;; 
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License.

(define (script-fu-RENAME-ME img drawable)
    (gimp-image-undo-group-start img)
    (gimp-context-push)

    ;; Do stuff here

    (gimp-context-pop)
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
)

(script-fu-register "script-fu-RENAME-ME"
                    _"<Image>/Filters/Generic/Do Stuff..."
                    _"Description of plugin"
                    "Author Name"
                    "Copyright Owner"
                    "January 2008"
                    "*"    ; type of image, e.g. "RGB*", or "" for Xtns
                    ; List all parameters here, starting with
                    ; image and drawable if this script takes them:
                    SF-IMAGE       "Image"              0
                    SF-DRAWABLE    "Drawable"           0
)

