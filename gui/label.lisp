(in-package agar)

(define-foreign-class (label ag-cffi::label) (widget))

(define-slot-accessors label)

(defbitfield label-flags
  :frame
  :nominsize
  :partial
  :regen)

(defun label-new-string (parent-widget text &rest flags)
  (foreign-funcall "AG_LabelNewStaticString"
		   widget parent-widget
		   label-flags flags
		   :string text
		   label))
