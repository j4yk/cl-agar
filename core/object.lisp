(in-package agar)

(define-foreign-class (object ag-cffi::object) ())

(define-slot-accessors object nil)

(defcfun ("AG_ObjectDetach" detach-object) :void
  (child-ptr :pointer))

(defcfun ("AG_ObjectDestroy" destroy-object) :void
  (object object))

(defun lock-object (object)
  (foreign-funcall "pthread_mutex_lock"
		   :pointer (foreign-slot-pointer object 'object 'ag-cffi::lock)
		   :int))

(defun unlock-object (object)
  (foreign-funcall "pthread_mutex_unlock"
		   :pointer (foreign-slot-pointer object 'object 'ag-cffi::lock)
		   :int))
