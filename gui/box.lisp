(in-package agar)

(define-foreign-class (box ag-cffi::box) (widget))

(defbitfield box-flags
  :homogenous
  :frame
  :hfill
  :vfill
  :expand)

(set-flag-function "AG_BoxSetHomogenous" box-set-homogenous box)

(defcfun ("AG_BoxSetPadding" set-box-padding) :void
  (box box) (padding :int))

(defcfun ("AG_BoxSetSpacing" set-box-spacing) :void
  (box box) (spacing :int))

(defcfun ("AG_BoxSetLabel" set-box-label) :void
  (box box) (label :string))

(defcfun ("AG_BoxSetDepth" set-box-depth) :void
  (box box) (depth :int))

(defcenum box-type
  :horiz
  :vert)

(define-foreign-class (vbox ag-cffi::vbox) (box))

(defbitfield vbox-flags
  :hfill
  :vfill
  :expand)

(defun vbox-set-homogenous (vbox homogenous-p)
  (box-set-homogenous vbox homogenous-p))

(defun vbox-set-padding (vbox padding)
  (box-set-padding vbox padding))

(defun vbox-set-spacing (vbox spacing)
  (box-set-spacing vbox spacing))

(defun vbox-new (parent &rest flags)
  ;; according to the macro AG_VBoxNew
  (foreign-funcall "AG_BoxNew"
		   widget parent
		   box-type :vert
		   vbox-flags flags
		   vbox))

(define-foreign-class (hbox ag-cffi::hbox) (box))

(defbitfield hbox-flags
  :hfill
  :vfill
  :expand)

(defun hbox-set-homogenous (hbox homogenous-p)
  (box-set-homogenous hbox homogenous-p))

(defun hbox-set-padding (hbox padding)
  (box-set-padding hbox padding))

(defun hbox-set-spacing (hbox spacing)
  (box-set-spacing hbox spacing))

(defun hbox-new (parent &rest flags)
  ;; according to the macro AG_VBoxNew
  (foreign-funcall "AG_BoxNew"
		   widget parent
		   box-type :horiz
		   vbox-flags flags
		   vbox))
