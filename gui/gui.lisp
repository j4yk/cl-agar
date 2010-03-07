(in-package agar)

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

(defvar *video-initialized* nil "Set to t when init-video is called")

(defun init-video (w h depth &rest flags)
  (unless *video-initialized* 
    (foreign-funcall "AG_InitVideo" :int w :int h :int depth video-flags flags
		     agar-code)
    (setq *video-initialized* t)))

(defun init-video-sdl (display &rest flags)
  "int AG_InitVideoSDL(SDL_Surface *display, Uint flags)"
  (restart-case (if *initialized*
		    (progn
		      (foreign-funcall "AG_InitVideoSDL" :pointer display video-flags flags
				       agar-code)
		      (setq *video-initialized* t))
		    (error "Agar has not yet been initialized!"))
    (init-agar (&optional (progname "prog") init-flags)
      :report "Initialize Agar with default settings and try again"
      (init-core progname init-flags)
      (apply #'init-video-sdl display flags))
    (init-agar (progname init-flags)
      :interactive (lambda () (list (progn (princ "Program name: ") (read-line))
				    (progn (princ "Flags: ") (eval (read)))))
      :report "Initialize Agar and try again"
      (init-core progname init-flags)
      (apply #'init-video-sdl display flags))))

(defun destroy ()
  (foreign-funcall "AG_Destroy" :void)
  (setq *video-initialized* nil
	*initialized* nil))

(defun destroy-video ()
  (foreign-funcall "AG_DestroyVideo" :void)
  (setq *video-initialized* nil))

(defcfun ("AG_EventLoop_FixedFPS" event-loop) :void)

(defcfun ("AG_BeginRendering" begin-rendering) :void)
(defcfun ("AG_EndRendering" end-rendering) :void)
(defcfun ("AG_ViewUpdateFB" view-update-fb) :void (rect :pointer))
