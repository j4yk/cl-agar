(in-package agar)

(defmacro with-agar-core ((progname &rest core-flags) &body body)
  "Initialisiert Agar gegebenenfalls, sodass body Agar-Funktionen verwenden kann.
Am Ende wird AG_Destroy aufgerufen"
  `(progn
     (init-core ,progname ,core-flags)
     ,@body))

(defmacro destroy-gui-at-end (&body body)
  `(unwind-protect
	(progn
	  ,@body)
     (destroy-gui)))

(defmacro with-video ((w h depth &rest flags) &body body)
  "Initialisiert gegebenenfalls eine Videoschnittstelle für Agar."
  `(progn
     (init-video ,w ,h ,depth ,@flags)
     (destroy-gui-at-end
       ,@body)))

(defmacro with-sdl-video ((display &rest video-flags) &body body)
  "Initialisiert Agar mit AG_InitVideoSDL und führt body aus."
  `(progn
     (init-video-sdl ,display ,@video-flags)
     (destroy-gui-at-end
       ,@body)))

(defmacro render (&body body)
  "Schließt body in begin-rendering und end-rendering ein."
  `(progn
     (begin-rendering)
     (unwind-protect
	  (progn
	    ,@body)
       (end-rendering))))