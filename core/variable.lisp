(in-package agar)

(defctype variable-data ag-cffi::variable-data)
(defctype variable-type ag-cffi::variable-type)

(define-foreign-class (var ag-cffi::variable) ())

(define-slot-accessors var
  (ag-cffi::type variable-type)
  (ag-cffi::data variable-data))

(defmacro define-bind-function (agar-name lisp-name)
  `(defcfun (,agar-name ,lisp-name) var
     (obj :pointer) (name :string) (value :pointer)))

(define-bind-function "AG_BindPointer" bind-pointer)
(define-bind-function "AG_BindInt" bind-int)
(define-bind-function "AG_BindFloat" bind-float)
(define-bind-function "AG_BindDouble" bind-double)
