(in-package agar)

(define-foreign-class (widget ag-cffi::widget) (object))

(define-slot-accessors widget
  (ag-cffi::flags widget-flags :writable)
  (ag-cffi::rview view-rectangle rview))

(defbitfield widget-flags
  :focusable
  :focused
  :unfocused-motion
  :unfocused-buttonup
  :unfocused-buttondown
  (:hfill #x40)
  :vfill
  (:hide #x200)
  :disabled)

(defcfun ("AG_WidgetDraw" widget-draw) :void (widget widget))

(defmacro set-flag-function (foreign-name lisp-name widget)
  "Defines a foreign function that enables or disables a flag
  according to a :boolean parameter"
  `(defcfun (,foreign-name ,lisp-name) :void (,widget ,widget) (enable :boolean)))

(defun disable-widget (widget)
  (lock-object widget)
  (unwind-protect
       (let ((flags (foreign-bitfield-symbols 'widget-flags (widget-flags widget))))
	 (unless (member :disabled flags)
	   (setf (widget-flags widget)
		 (foreign-bitfield-value 'widget-flags (cons :disabled flags)))
	   (post-event (null-pointer) widget "widget-disabled" (null-pointer))))
    (unlock-object widget)))

(defun enable-widget (widget)
  (lock-object widget)
  (unwind-protect
       (let ((flags (foreign-bitfield-symbols 'widget-flags (widget-flags widget))))
	 (when (member :disabled flags)
	   (setf (widget-flags widget)
		 (foreign-bitfield-value 'widget-flags (delete :disabled flags)))
	   (post-event (null-pointer) widget "widget-enabled" (null-pointer))))
    (unlock-object widget)))

(defcfun "Update_Widget" :void (object :pointer))

(defcfun "Hide_Widget" :void (widget :pointer))
(defcfun "Show_Widget" :void (widget :pointer))
(defcfun "Expand_Horiz" :void (widget :pointer))
(defcfun "Expand_Vert" :void (widget :pointer))
(defcfun "Expand" :void (widget :pointer))