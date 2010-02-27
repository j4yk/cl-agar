(in-package agar)

(define-foreign-class (object ag-cffi::object) ())

(define-slot-accessors object nil)

(defcfun ("AG_ObjectDetach" detach-object) :void
  (child-ptr :pointer))

(defcfun ("AG_ObjectDestroy" destroy-object) :void
  (object object))
