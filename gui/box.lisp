(in-package agar)

(define-foreign-class (box ag-cffi::box) (widget))

(defbitfield box-flags
  :homogenous
  :frame
  :hfill
  :vfill
  :expand)

(define-foreign-class (vbox ag-cffi::vbox) (box))

(defbitfield vbox-flags
  :hfill
  :vfill
  :expand)

(set-flag-function "AG_VBoxSetHomogenous" vbox-set-homogenous vbox)

(defcfun ("AG_VboxSetPadding" vbox-set-padding) :void
  (vbox vbox) (padding :int))

(defcfun ("AG_VBoxSetSpacing" vbox-set-spacing) :void
  (vbox vbox) (spacing :int))

(defun vbox-new (parent &rest flags)
  (foreign-funcall "AG_VBoxNew"
		   widget parent
		   vbox-flags flags
		   vbox))
