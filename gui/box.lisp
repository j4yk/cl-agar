(in-package agar)

(define-foreign-class (box ag-cffi::box) (widget))

(defbitfield box-flags
  :homogenous
  :frame
  :hfill
  :vfill
  :expand)
