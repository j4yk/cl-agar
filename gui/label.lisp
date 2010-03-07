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

(defmacro new-label (parent flags format &rest bindings)
  (if (null bindings)
      `(label-new-string ,parent ,format ,@flags)
      `(new-polled-label ,parent ,flags ,format ,@bindings)))

(defcfun ("AG_LabelSizeHint" size-hint-label) :void
  (label label) (n-lines :uint) (text :string))
