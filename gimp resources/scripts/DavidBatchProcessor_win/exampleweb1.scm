(define (file-basename filename)
  (let*
    (
      (broken-up (strbreakup filename "."))
      (wo-last-r (cdr (reverse broken-up)))
      (wo-last   (reverse wo-last-r))
      (result "")
    )
    (while wo-last
      (set! result (string-append result (car wo-last) ))
      (set! wo-last (cdr wo-last))
      (if (> (length wo-last) 0) (set! result (string-append result ".")))
    )
    result
  )
)

(define (batch-unsharp-mask pattern
                            radius
                            amount
                            threshold)

  (let* ((filelist (cadr (file-glob pattern 1))))
    (while (not (null? filelist))
           (let* ((filename (car filelist))
                  (image (car (gimp-file-load RUN-NONINTERACTIVE
                                              filename filename)))
                  (drawable (car (gimp-image-get-active-layer image))))

             (plug-in-unsharp-mask RUN-NONINTERACTIVE
                                   image drawable radius amount threshold)

             (gimp-file-save RUN-NONINTERACTIVE
                             image drawable filename filename))

             (gimp-image-delete image))
             (set! filelist (cdr filelist))))

; Register in Gimp Menu
(script-fu-register "batch-unsharp-mask"
		    _"_Batch unsharp mask..."
		    "Batch unsharp Mask"
		    "Sven Tryding"
		    "2011, Sven Tryding"
		    "Jun 2, 2011"
		    ""
		    SF-STRING "Path" "C:\\Users\\Public\\Pictures\\2011 Våren\\Golf Niklas\\*.jpg"
               SF-VALUE "Radius" "30"
               SF-VALUE "Amount (min 0, max 4)" "0.5"
               SF-VALUE "Threshold (min 0, max 10)" "4"
)

(script-fu-menu-register "batch-unsharp-mask"
			 "<Toolbox>/_Filters/_Script-Fu")




