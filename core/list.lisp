(in-package agar)

(define-foreign-class (agar-list ag-cffi::agar-list))

(define-slot-accessors agar-list
  (ag-cffi::n agar-list-n agar-list-count)
  (ag-cffi::v agar-list-v agar-list-items))
