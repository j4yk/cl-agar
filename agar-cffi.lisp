(defpackage :agar
  (:use :cl :cffi))

(in-package agar)

(define-foreign-library agar-core
  (:unix "libag_core.so")
  (:windows "ag_core.dll"))

(define-foreign-library agar-gui
  (:unix "libag_gui.so")
  (:windows "ag_gui.dll"))

(define-foreign-library freetype
  (:unix "libfreetype.so")
  (:windows "freetype.dll"))

(define-foreign-library jpeg
  (:unix "libjpeg.so"))

(use-foreign-library jpeg)
(use-foreign-library freetype)
(use-foreign-library agar-core)
(use-foreign-library agar-gui)

(defctype charpointer :pointer "char*")
(defctype agar-code :int)		; Fehlerstatus

(defun get-error ()
  "const char* AG_GetError()"
  (let ((pmsg (foreign-funcall "AG_GetError" charpointer)))
    (when pmsg (foreign-string-to-lisp pmsg))))

(define-condition agar-error (error)
  ((error-message :initarg :message :initform (get-error)))
  (:report (lambda (condition stream)
	     (format stream "Error in agar: ~a" (slot-value condition 'error-message))))
  (:documentation "Ein bei Benutzung von Agar aufgetretener Fehler"))

(defmacro agar-funcall (name-and-options &rest args)
  "Ruft eine Agar-Funktion, die einen Fehlerstatus zurückgibt, auf und
  singalisiert einen Fehler vom Typ agar-error, wenn die Funktion
  nicht 0 zurückgibt."
  `(unless (= 0 (foreign-funcall ,name-and-options ,@args agar-code))
     (error 'agar-error)))

(defvar *initialized* nil "Gibt an, ob init-core schon aufgerufen wurde")

(defbitfield init-flags
  (:verbose #x1)
  :create-datadir
  :no-cfg-autoload)

;; HACK: callback schreiben, damit *initialized* ggf. auch wieder nil wird
(defun init-core (progname flags)
  "int AG_InitCore(const char* progname, uint flags)
Initislisiert Agar, wenn dies nicht schon vorher getan wurde"
  (unless *initialized* 
    ;; progname wird von AG_InitCore kopiert, daher muss der nicht aufbewahrt werden
    (agar-funcall "AG_InitCore" :string progname init-flags flags))
    (setq *initialized* t))

(defbitfield video-flags
  (:hwsurface #x1)
  :asyncblit
  :anyformat
  :hwpalette
  :doublebuf
  :fullscreen
  :resizable
  :noframe
  :bgpopupmenu
  :opengl
  :opengl-or-sdl
  :overlay)

(defvar *video-initialized* nil "Gibt an, ob init-video schon aufgerufen wurde")

(defun init-video (w h depth &rest flags)
  (unless *video-initialized* 
    (agar-funcall "AG_InitVideo" :int w :int h :int depth video-flags flags)
    (setq *video-initialized* t)))

(defmacro defagarfun (foreign-name function-name &body args)
  `(defun ,function-name ,(mapcar #'car args)
     (agar-funcall ,foreign-name ,@(loop for (arg type) in args
				      append (list type arg)))))

(defun init-video-sdl (display &rest flags)
  "int AG_InitVideoSDL(SDL_Surface *display, Uint flags)"
  (check-type display sdl:surface)
  (agar-funcall "AG_InitVideoSDL" :pointer (sdl:fp display) video-flags flags))

(defcenum text-msg-title
  (:error)
  (:warning)
  (:info))

(defun text-msg (title format-string &rest format-args)
  "void AG_TextMsg(enum ag_text_msg_title title, const char *format, ...)"
  (let ((message (apply #'format nil format-string format-args)))
    (foreign-funcall "AG_TextMsg"
		     text-msg-title title
		     :string message :void)))

(defcfun ("AG_EventLoop_FixedFPS" event-loop) :void)

(defun process-event (sdl-event)
  "int AG_ProcessEvent(SDL_Event *ev)
Gibt 1 zurück, wenn das Ereignis irgendwie verarbeitet wurde,
-1, wenn die Anwendung beendet wird."
  (foreign-funcall "AG_ProcessEvent" :pointer sdl-event :int))

(defcfun ("AG_BeginRendering" begin-rendering) :void)
(defcfun ("AG_EndRendering" end-rendering) :void)

(defcfun ("AG_Destroy" destroy) :void)

(defun tailq-to-list (tailq-head field)
  (do* ((var (foreign-slot-value tailq-head 'tailq-head 'tqh-first)
	     (foreign-slot-value (foreign-slot-value var 'tailq-entry field) 'tailq-entry 'tqe-next))
	(list (list var) (push var list)))
       ((not (null-pointer-p var)) (nreverse list))))

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

(defun init-display-test ()
  (with-agar ("init-display-test")
    (with-video (320 240 32 :resizable)
      (text-msg :info "Hello, world!")
      (event-loop))))

(defcvar ("agView" *view*) agar-cffi::display)

(defun custom-event-loop ()
  (with-foreign-objects ((ev 'agar-cffi::sdl-event ))
    (loop
       (begin-rendering)
       (dolist (win (tailq-to-list (foreign-slot-pointer *view* 'agar-cffi::display 'agar-cffi::windows) 'agar-cffi::windows))
	 (window-draw win))
       (end-rendering)
       (when (not (= 0 (foreign-funcall "SDL_PollEvent" agar-cffi::sdl-event (get-var-pointer 'ev) :int)))
	 (process-event ev)))))

(defun custom-event-loop-test ()
  (with-foreign-objects ((win :pointer))
    (with-agar ("custom-event-loop-test")
      (with-video (320 240 32 :resizable)
	(setf win (foreign-funcall "AG_WindowNew" :int 0 :pointer))
	(foreign-funcall "AG_LabelNewStatic" :pointer win :int 0 :string "Hello world!")
	(foreign-funcall "AG_WindowShow" :pointer win)
	(custom-event-loop)))))