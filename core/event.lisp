(in-package agar)

(define-foreign-class (event ag-cffi::event) ())

(defun event-ptr (event ntharg)
  "AG_PTR(v)"
  (let ((var (mem-aref (foreign-slot-pointer event 'event 'ag-cffi::argv) 'var ntharg))) ; AG_Variable
    (if (eq (variable-type var) :pointer)
	(foreign-slot-value (variable-data var) 'variable-data 'ag-cffi::p)
	(error "Wrong Agar variable type! Wanted ~s but is ~s" :pointer (foreign-enum-keyword 'variable-type (variable-type var))))))
	