(define (batch-scale-plus-unsharp-mask pattern radius amount threshold)
  (let* ((filelist (cadr (file-glob pattern 1))))
    (while (not (null? filelist))
           (let* ((filename (car filelist))
                  (image (car (gimp-file-load RUN-NONINTERACTIVE
                                              filename filename)))
			   (drawable (car (gimp-image-get-active-layer image)))
			   (cur-width  (car (gimp-image-width image)))
                  (cur-height (car (gimp-image-height image)))
                       (new-width  (* 0.3 cur-width))
                       (new-height (* 0.3 cur-height))
             (new_ratio      (min (/ new-width cur-width) (/ new-height cur-height)))
             (width      (* new_ratio cur-width))
             (height     (* new_ratio cur-height)))

             (plug-in-unsharp-mask RUN-NONINTERACTIVE
                                   image drawable radius amount threshold)

             

             (gimp-image-undo-disable image)
             (gimp-image-scale-full image width height INTERPOLATION-LANCZOS)

             (gimp-file-save RUN-NONINTERACTIVE
                             image drawable filename filename)
             (gimp-image-delete image))
           (set! filelist (cdr filelist)))))

; Register in Gimp Menu
(script-fu-register "batch-scale-unsharp-mask"
		    _"_Batch scale + unsharp mask..."
		    "Batch Scale + unsharp Mask"
		    "Sven Tryding"
		    "2011, Sven Tryding"
		    "Jun 3, 2011"
		    ""
		    SF-STRING "Path" "C:\\Users\\Public\\Pictures\\2011 Våren\\Golf Niklas\\*.jpg"
               SF-VALUE "Radius" "30"
               SF-VALUE "Amount (min 0, max 4)" "0.5"
               SF-VALUE "Threshold (min 0, max 10)" "4"
)

(script-fu-menu-register "batch-scale-unsharp-mask"
			 "<Toolbox>/_Filters/_Script-Fu")