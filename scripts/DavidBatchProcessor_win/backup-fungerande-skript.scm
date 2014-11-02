; A Script-Fu script that loops through all files in a directory ; and creates a copy of the files that is altered
; "Shrinked", "Leveled " , "Sharpened"
; Backup ! This one Works

(define (script-fu-batch-resize globexp suffix ratio bsharpen bautolevel bsharpum1 bsharpum2 bsharpum3)

(let* ((filelist (cadr (file-glob globexp 1))))

(while (not (null? filelist))
     (let* ((fname (car filelist))
        
     (img (car (gimp-file-load RUN-NONINTERACTIVE fname fname))))
     (let* (
           (xdrawable   (car (gimp-image-active-drawable img)))
           (cur-width  (car (gimp-image-width img)))
           (cur-height (car (gimp-image-height img)))
                       (new-width  (* ratio cur-width))
                       (new-height (* ratio cur-height))
           (new_ratio      (min (/ new-width cur-width) (/ new-height cur-height)))
           (width      (* new_ratio cur-width))
           (height     (* new_ratio cur-height))
       )                  
     (gimp-image-undo-disable img)
     (gimp-image-scale-full img width height INTERPOLATION-LANCZOS)
; Sharpen if the user wants so
     (if (= bsharpen TRUE) (plug-in-sharpen RUN-NONINTERACTIVE img xdrawable 40))
; Level if the user wants so
     (if (= bautolevel TRUE) (gimp-levels-stretch xdrawable))
; Sharp with Mask if the user wants so
     (if (= bsharpum1 TRUE) (plug-in-unsharp-mask RUN-NONINTERACTIVE img xdrawable 30.0 0.7 4))
     (if (= bsharpum2 TRUE) (plug-in-unsharp-mask RUN-NONINTERACTIVE img xdrawable 60.0 1.0 6))
     (if (= bsharpum3 TRUE) (plug-in-unsharp-mask RUN-NONINTERACTIVE img xdrawable 10.0 0.5 3))

     (gimp-file-save RUN-NONINTERACTIVE img xdrawable fname fname)
     (gimp-image-delete img)
    )
    (set! filelist (cdr filelist)))))
)

; Register in Gimp Menu
(script-fu-register "script-fu-batch-resize"
		    _"_Many Pictures Resize..."
		    "Resize Many Pictures"
		    "Sven Tryding"
		    "2011, Sven Tryding"
		    "Jun 2, 2011"
		    ""
		    SF-STRING "Path" "C:\\Users\\Public\\Pictures\\2011 V�ren\\Golf Niklas\\*.jpg"
              SF-STRING "Suffix" "_small.jpg"

              SF-VALUE "Scaling ratio (min 0.01, max 1)" "0.30"
              SF-TOGGLE "Sharpen" TRUE
		    SF-TOGGLE "AutoLevel" TRUE
              SF-TOGGLE "Sharp UnsharpMask 30 (Medium)" TRUE
              SF-TOGGLE "Sharp UnsharpMask 60 (Strong)" FALSE
              SF-TOGGLE "Sharp UnsharpMask (Light)" FALSE)

(script-fu-menu-register "script-fu-batch-resize"
			 "<Toolbox>/_Filters/_Script-Fu")

