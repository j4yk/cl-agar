(in-package agar)

(defctype variable-data ag-cffi::variable-data)
(defctype variable-type ag-cffi::variable-type)

(define-foreign-class (var ag-cffi::variable) ())

(define-slot-accessors var
  (ag-cffi::type variable-type)
  (ag-cffi::data variable-data))
