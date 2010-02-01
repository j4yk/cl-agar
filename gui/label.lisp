(in-package agar)

(define-wrapper-class label (widget)
  ()
  (:documentation "Wrapper class for AG_Label")
  (:foreign-type ag-cffi::label))

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
