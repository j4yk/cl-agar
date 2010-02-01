(in-package agar)

(define-wrapper-class widget (object)
  ()
  (:documentation "Wrapper class for AG_Widget")
  (:foreign-type ag-cffi::widget))