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

;; (defctype window :pointer "AG_Window Pointer")
(defctype window-pointer (:pointer window) "AG_Window*")

(defun window-new (&rest flags)
  (foreign-funcall "AG_WindowNew" window-flags flags window))

(defun window-set-caption (window format-control-str &rest format-args)
  (foreign-funcall "AG_WindowSetCaption"
		   window window
		   :string (apply #'format nil format-control-str format-args)
		   :void))

(defcfun ("AG_WindowShow" window-show) :void
  (window window))
