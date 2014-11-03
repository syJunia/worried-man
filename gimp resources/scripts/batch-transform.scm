; A Script-Fu Script that Opens all files in a directory ; Creates and store away a copy of the files , the filename of the copy
; has a users defined suffix
; "Transform"
; Written in July 2011

(define (script-fu-batch-transform globexp suffix ratio)

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
		 (xdrawable (car (gimp-drawable-transform-flip-simple xdrawable ORIENTATION-HORIZONTAL TRUE cur-width FALSE)))
       )                
  
       (gimp-image-undo-disable img)
	  
       (gimp-image-scale-full img width height INTERPOLATION-LANCZOS)
	        
       (gimp-file-save RUN-NONINTERACTIVE img xdrawable (string-append (car (strbreakup fname ".")) suffix) (string-append (car (strbreakup fname ".")) suffix))
		
       ;(gimp-message "Nu har vi sparat!")
	   
       ;(gimp-display-delete img) Lite synd att vi inte kan köra denna ... Måste testa på bibliotek med mycket filer så det inte blir overflow
     )
    (set! filelist (cdr filelist)))))
)


; Register in Gimp Menu
(script-fu-register "script-fu-batch-transform"
		    _"_Batch Transform ..."
		    "Transform (spegling) many Pictures, Save them in new files"
		    "Sven Tryding"
		    "2011, Sven Tryding"
		    "July, 2011"
		    ""
		    SF-STRING "Path" "/home/sven/Bilder/*.jpg"
              SF-STRING "Suffix (use .jpg if \"replace\" is desired)" "_t.jpg"

              SF-VALUE "Scaling ratio (min 0.01, max 5)" "0.30" 
)            

(script-fu-menu-register "script-fu-batch-transform"
			 "<Toolbox>/_Filters/_Script-Fu")

