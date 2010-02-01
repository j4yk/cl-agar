(in-package agar)

(defbitfield window-flags
  :modal :maximized :minimized :keepabove :keepbelow
  :denyfocus :notitle :noborders :nohresize :novresize
  :noclose :nominimize :nomaximize
  :cascade :minsizepct
  :nobackground :noupdaterect
  :focusonattach :hmaximize :vmazimize
  :nomove :noclipping
  :modkeyevents)

(define-wrapper-class window (widget)
  ((visible :accessor visible :documentation "Whether the window is visible or not" :initarg :visible
	    :foreign-slot-name ag-cffi::visible)
   (windows :accessor windows :documentation "TAILQ_ENTRY for AG_Windows" :initarg :windows
	    :foreign-slot-name ag-cffi::windows :foreign-type (tailqueue-entry :type window)))
  (:documentation "Wrapper class for AG_Window")
  (:foreign-type ag-cffi::window))

(defun window-new (&rest flags)
  (foreign-funcall "AG_WindowNew" window-flags flags window))

(defun window-set-caption (window format-control-str &rest format-args)
  (foreign-funcall "AG_WindowSetCaption"
		   window window
		   :string (apply #'format nil format-control-str format-args)
		   :void))

(defcfun ("AG_WindowShow" window-show) :void
  (window window))

(defun window-draw (window)
  "static __inline__ void AG_WindowDraw(AG_Window *win)
Render a window to the display (must be enclosed between calls to
  (begin-rendering) and (end-rendering) or in a (render ...) form.
The View VFS and Window object must be locked."
  (when (visible window)
    (widget-draw window)
    (unless (opengl-p *view*)
      (view-update-fb (rview window)))))
