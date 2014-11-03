; ISO brusreducering, V2.1
;
; Martin Egger (martin.egger@gmx.net)
; (C) 2005, Bern, Switzerland
;
;
; Definera funktion
;
(define (script-fu-ISONoiseReduction InImage InLayer InType InOpacity InRadius InFlatten)
;
; Spara historik                        
;
        (gimp-image-undo-group-start InImage)
;
        (let*   (
                (NoiseLayer (car (gimp-layer-copy InLayer TRUE)))
                (TempLayer (car (gimp-layer-copy InLayer TRUE)))
                (InDelta (* InRadius 7 ))
                (RadiusRB (* InRadius 1.5))
                (DeltaRB (* InDelta 2))
                )
;
                (gimp-image-add-layer InImage NoiseLayer -1)
                (gimp-image-add-layer InImage TempLayer -1)
;
; Leta kanter, Mängd = 10, Warpmode = Smeta ut (1), Algoritm = Laplace (5)
;
                (plug-in-edge TRUE InImage TempLayer 10 1 5)
                (gimp-desaturate TempLayer)
                (gimp-invert TempLayer)
                (plug-in-gauss TRUE InImage TempLayer 10.0 10.0 0)
                (gimp-selection-all InImage)
                (gimp-edit-copy TempLayer)
                (gimp-image-remove-layer InImage TempLayer)
;
                (let*   (
                        (NoiseLayerMask (car (gimp-layer-create-mask NoiseLayer ADD-SELECTION-MASK)))
                        )
                        (gimp-image-add-layer-mask InImage NoiseLayer NoiseLayerMask)
                        (gimp-floating-sel-anchor (car (gimp-edit-paste NoiseLayerMask FALSE)))
                        (gimp-selection-none InImage)
;
; Välj metod
;
                        (cond
;
; Brus Skingra RGB kanaler, använd olika radie/delta för Röd/Blå and Grön
;
                                ((= InType 0) 
                                        (begin
                                                (gimp-image-set-component-active InImage RED-CHANNEL TRUE)
                                                (gimp-image-set-component-active InImage GREEN-CHANNEL FALSE)
                                                (gimp-image-set-component-active InImage BLUE-CHANNEL FALSE)
                                                (plug-in-sel-gauss TRUE InImage NoiseLayer RadiusRB DeltaRB)
;
                                                (gimp-image-set-component-active InImage RED-CHANNEL FALSE)
                                                (gimp-image-set-component-active InImage GREEN-CHANNEL TRUE)
                                                (plug-in-sel-gauss TRUE InImage NoiseLayer InRadius InDelta)
;                       
                                                (gimp-image-set-component-active InImage GREEN-CHANNEL FALSE)
                                                (gimp-image-set-component-active InImage BLUE-CHANNEL TRUE)
                                                (plug-in-sel-gauss TRUE InImage NoiseLayer RadiusRB DeltaRB)
;       
                                                (gimp-image-set-component-active InImage RED-CHANNEL TRUE)
                                                (gimp-image-set-component-active InImage GREEN-CHANNEL TRUE)
                                        )
                                )
;
; Brus Sprid
;
                                ((= InType 1)
                                        (begin
                                                (let*   (
                                                        (OrigLayer (cadr (gimp-image-get-layers InImage)))
                                                        (LABImage (car (plug-in-decompose TRUE InImage InLayer "LAB" TRUE)))
                                                        (LABLayer (cadr (gimp-image-get-layers LABImage)))
                                                        (LLayer (car (gimp-layer-copy InLayer TRUE)))
                                                        )
;
                                                        (gimp-image-add-layer InImage LLayer -1)
                                                        (gimp-selection-all LABImage)
                                                        (gimp-edit-copy (aref LABLayer 2))
                                                        (gimp-floating-sel-anchor (car (gimp-edit-paste LLayer FALSE)))
                                                        (plug-in-sel-gauss TRUE InImage LLayer RadiusRB DeltaRB)
                                                        (gimp-selection-all InImage)
                                                        (gimp-edit-copy LLayer)
                                                        (gimp-image-remove-layer InImage LLayer)
                                                        (gimp-floating-sel-anchor (car (gimp-edit-paste (aref LABLayer 2) FALSE)))
                                                        (let*   (
                                                                (CompImage (car (plug-in-drawable-compose TRUE LABImage (aref LABLayer 2) (aref LABLayer 1) (aref LABLayer 0) 0 "LAB")))
                                                                (CompLayer (cadr (gimp-image-get-layers CompImage)))
                                                                )
                                                                (gimp-selection-all CompImage)
                                                                (gimp-edit-copy (aref CompLayer 0))
                                                                (gimp-floating-sel-anchor (car (gimp-edit-paste NoiseLayer FALSE)))
                                                                (gimp-image-delete CompImage)
                                                        )
                                                        (gimp-image-delete LABImage)
                                                )
                                        )
                                )
;
; GIMP damm och repor modul
;
                                ((= InType 2) (plug-in-despeckle TRUE InImage NoiseLayer InRadius 1 7 248))
                        )
                        (gimp-layer-set-opacity NoiseLayer InOpacity)
                )
;
; Platta till bild, om detta är valt
;
                (cond
                        ((= InFlatten TRUE) (gimp-image-merge-down InImage NoiseLayer CLIP-TO-IMAGE))
                        ((= InFlatten FALSE) (gimp-drawable-set-name NoiseLayer "Noisefree"))
                )
        )
;
; Avsluta arbetet
;
        (gimp-image-undo-group-end InImage)
        (gimp-displays-flush)
;
)
;
(script-fu-register 
        "script-fu-ISONoiseReduction"
	   "ISO Brus reducering"	
        "Reduce sensor noise at high ISO values"
        "Martin Egger (martin.egger@gmx.net)"
        "2005, Martin Egger, Bern, Switzerland"
        "1.06.2005"
        "RGB* GRAY*"
        SF-IMAGE        "The Image"           0
        SF-DRAWABLE     "The Layer"           0
        SF-OPTION       "Metod" 
                        '( 
                                                "RGB bruskanal (snabbare)"
                                                "Luminance bruskanal (inte snabb)"
                                                "GIMP damm och repor"
                        )
        SF-ADJUSTMENT   "Transparens" '(70.0 1.0 100.0 1.0 0 2 0)
        SF-ADJUSTMENT   "Brus"        '(5 1.0 10.0 0.5 0 2 0)
        SF-TOGGLE       "Sammanfoga lager"    FALSE
)

(script-fu-menu-register "script-fu-ISONoiseReduction"
				_"<Image>/_Filters/_Script-Fu/_Test")

(script-fu-menu-register "script-fu-ISONoiseReduction"
				_"<Image>/_Filters/_Enhance")