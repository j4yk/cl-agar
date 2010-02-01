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
  (foreign-funcall "AG_InitVideoSDL" :pointer display video-flags flags
		   agar-code))

(defun destroy-gui ()
  "void AG_DestroyGUI();"
  (unwind-protect
       (foreign-funcall "AG_DestroyGUI" :void)
    (setq *video-initialized* nil)))

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

(defcfun ("AG_BeginRendering" begin-rendering) :void)
(defcfun ("AG_EndRendering" end-rendering) :void)
(defcfun ("AG_ViewUpdateFB" view-update-fb) :void (rect :pointer))
