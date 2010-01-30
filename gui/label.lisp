(in-package agar)

(defctype label :pointer "AG_Label")

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
