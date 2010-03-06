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

(defmacro new-polled-label (parent-widget flags format &rest bindings)
  `(foreign-funcall "AG_LabelNewPolled"
		    widget ,parent-widget
		    label-flags ,flags
		    :string ,format
		    ,@(mapcan #'(lambda (b) `(:pointer ,b))
			      bindings)
		    label))

(defcfun ("AG_LabelSizeHint" size-hint-label) :void
  (label label) (n-lines :uint) (text :string))
