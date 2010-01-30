(in-package agar)

(defmacro with-agar-core ((progname &rest core-flags) &body body)
  "Initialisiert Agar gegebenenfalls, sodass body Agar-Funktionen verwenden kann.
Am Ende wird AG_Destroy aufgerufen"
;  `(unwind-protect
	`(progn
	  (init-core ,progname ,core-flags)
	  ,@body))
;     (destroy)))

(defmacro destroy-gui-at-end (&body body)
  `(unwind-protect
	(progn
	  ,@body)
     (destroy-gui)))

(defmacro with-video ((w h depth &rest flags) &body body)
  "Initialisiert gegebenenfalls eine Videoschnittstelle für Agar."
  `(destroy-gui-at-end
     (init-video ,w ,h ,depth ,@flags)
     ,@body))

(defmacro with-sdl-video ((display &rest video-flags) &body body)
  "Initialisiert Agar mit AG_InitVideoSDL und führt body aus."
  `(destroy-gui-at-end
     (init-video-sdl ,display ,@video-flags)
     ,@body))

(defmacro render (&body body)
  "Schließt body in begin-rendering und end-rendering ein."
  `(unwind-protect
	(progn
	  (begin-rendering)
	  ,@body)
     (end-rendering)))