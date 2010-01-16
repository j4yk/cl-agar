(in-package agar)

(defmacro with-agar ((progname &rest core-flags) &body body)
  "Initialisiert Agar gegebenenfalls, sodass body Agar-Funktionen verwenden kann."
  `(progn
     (init-core ,progname ,core-flags)
     ,@body))

(defmacro with-video ((w h depth &rest flags) &body body)
  "Initialisiert gegebenenfalls eine Videoschnittstelle für Agar."
  `(progn
     (init-video ,w ,h, depth ,@flags)
     ,@body))
