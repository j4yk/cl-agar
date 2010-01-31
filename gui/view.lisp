(in-package agar)

(define-wrapper-class display ()
  ((nominal-refresh-rate :accessor nominal-refresh-rate :accessor rnom :initarg :rnom
			 :foreign-slot-name 'ag-cffi::rnom)
   (windows :accessor windows :initarg :windows
	    :foreign-slot-name 'ag-cffi::windows
	    :foreign-type '(tailqueue-head :type window)))
  (:documentation "Wrapper class for AG_Display struct")
  (:foreign-type ag-cffi::display))
