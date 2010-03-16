(in-package agar)

(define-foreign-class (object ag-cffi::object) ())

(define-slot-accessors object
  (ag-cffi::timeouts object-timeouts)
  (ag-cffi::tobjs object-tobjs))

(defcfun ("AG_ObjectAttach" attach-object) :void
  (parentp :pointer) (pchild :pointer))

(defcfun ("AG_ObjectDetach" detach-object) :void
  (child-ptr :pointer))

(defcfun "Parent_Object" :pointer
  (object :pointer))

(defcfun ("AG_ObjectDestroy" destroy-object) :void
  (object object))

(defcfun "Unlock_Object" :void (obj :pointer))
(defcfun "Lock_Object" :void (obj :pointer))
