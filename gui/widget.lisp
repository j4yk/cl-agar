(in-package agar)

(define-wrapper-class widget (object)
  ((view-rectangle :reader view-rectangle :reader rview :initarg :rview
		   :foreign-slot-name ag-cffi::rview :foreign-type ag-cffi::rect2))
  (:documentation "Wrapper class for AG_Widget")
  (:foreign-type ag-cffi::widget))