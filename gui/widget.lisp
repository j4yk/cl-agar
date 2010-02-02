(in-package agar)

(define-foreign-class (widget ag-cffi::widget) (object))

(define-slot-accessors widget
  (ag-cffi::rview view-rectangle rview))

(defcfun ("AG_WidgetDraw" widget-draw) :void (widget widget))

(defmacro set-flag-function (foreign-name lisp-name widget)
  "Defines a foreign function that enables or disables a flag
  according to a :boolean parameter"
  `(defcfun (,foreign-name ,lisp-name) :void (,widget ,widget) (enable :boolean)))
