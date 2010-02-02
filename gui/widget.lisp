(in-package agar)

(define-foreign-class (widget ag-cffi::widget) (object))

(define-slot-accessors widget
  (ag-cffi::rview view-rectangle rview))

(defcfun ("AG_WidgetDraw" widget-draw) :void (widget widget))
