;; createSmallCopyBatch.scm: 
;; Copyright (C) 2011 by sven tryding, sven@tryding.se.
;; 
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License.

;; createSmallCopyBatch.scm:
;; Loop through all the images in the directory and do the 
;; following
;; 1 ) Open image
;; 2 ) AutoLevel Light
;; 3 ) Auto improve Colors
;; 4 ) Scale to 30 % 
;; Save with filename "original" name + "_smallerCopy"

(define (script-fu-create-small-copy img drawable
                                   overlap top-on-right use-mask)


	(gimp-image-undo-group-end img)

  ;; Calculate the size for the new image
  (let* ((layers (gimp-image-get-layers img))
         (num-layers (car layers))
         (layer-array (cadr layers))
         (bottomlayer (aref layer-array (- num-layers 1)))

         ; Pandora assumes that all layers are the same size as the first:
         ; XXX change this eventually.

         (layer-w (car (gimp-drawable-width bottomlayer)))
         (layer-h (car (gimp-drawable-height bottomlayer)))
         (overlap-frac (/ overlap 100))
         (extra-frac (- 1.0 overlap-frac))
         (hslop (/ layer-w 4))
         (vslop (/ (* hslop 3) 2))
         (pan-img-w (* layer-w (+ 1 (* (- num-layers 0.3) (- 1 overlap-frac)))))
         (pan-img-h (+ layer-h vslop))
         (newy (/ vslop 2))
         (i (- num-layers 1) 1)    ; start from the bottom layer
         )
    ;(gimp-message (number->string pan-img-w))
    (gimp-image-undo-group-start img)
    (gimp-image-resize img pan-img-w pan-img-h 0 0)

    ;; Loop over the layers starting with the second, moving each one.
    ;; Layers are numbered starting with 0 as the top layer in the stack.
    ;(gimp-layer-translate bottomlayer 0 newy)
    (gimp-context-push)
    (while (>= i 0)
           ;(gimp-message (number->string i))
           (let* ((thislayer (aref layer-array i))
                  (thislayer-w (car (gimp-drawable-width thislayer)))
                  (newx (if (= top-on-right TRUE)
                            (* (- (- num-layers i) 1)
                               (* thislayer-w extra-frac))
                            (* i (* thislayer-w extra-frac))
                            ))
                  )
             (if (= (car (gimp-layer-is-floating-sel thislayer)) FALSE)
                 (begin
                  (gimp-layer-translate thislayer newx newy)
                  (if (and (= use-mask TRUE)
                           (= (car (gimp-layer-get-mask thislayer)) -1)
                           (not (= i (- num-layers 1))))
                      (let* ((masklayer (car (gimp-layer-create-mask
                                              thislayer ADD-BLACK-MASK)))
                             (grad-w (* (* layer-w overlap-frac) 0.5))
                             (grad-start (if (= top-on-right TRUE)
                                             grad-w
                                             (- thislayer-w grad-w)))
                             (grad-end (if (= top-on-right TRUE)
                                           0 thislayer-w))
                             )
                        (gimp-layer-add-alpha thislayer)
                        (gimp-layer-add-mask thislayer masklayer)
                        (gimp-context-set-foreground '(255 255 255))
                        (gimp-context-set-background '(0 0 0))
                        (gimp-edit-blend masklayer FG-BG-RGB-MODE NORMAL-MODE
                                         GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE
                                         FALSE 0 0 TRUE
                                         grad-start 0 grad-end 0)
                        (gimp-layer-set-edit-mask thislayer FALSE)
                        ))))
             )
           (set! i (- i 1))
           )

    (gimp-context-pop)
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
    )
)

(if (symbol-bound? 'script-fu-menu-register (the-environment))
    (begin 
     (script-fu-register "script-fu-create-small-copies"
                         _"Create small copies"
                         _"Create small copies of images in the current directory"
                         "Sven Tryding"
                         "Sven Tryding"
                         "June 2011"
                         "*"
                         SF-IMAGE       "Image"              0
                         SF-DRAWABLE    "Drawable"           0
                         SF-ADJUSTMENT _"Decrease amount (percent)"  '(30 0 100 1 10 0 1))

     (script-fu-menu-register "script-fu-create-small-copies"
                              _"<Image>/_Filters/_Script-Fu/_Test/")
     ) ; end begin

     (script-fu-register "script-fu-create-small-copy "
                         _"<Image>/_Filters/_Script-Fu/_Test/_Create smaller copies"
                         _"Create Smaller Copies of images in the directory"
                         "Sven Tryding"
                         "Sven Tryding"
                         "June 2011"
                         "*"
                         SF-IMAGE       "Image"              0
                         SF-DRAWABLE    "Drawable"           0
                         SF-ADJUSTMENT _"Decrease amount (percent)"  '(30 0 100 1 10 0 1))
    
)

