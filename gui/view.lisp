(in-package agar)

(define-wrapper-class display ()
  ((nominal-refresh-rate :accessor nominal-refresh-rate :accessor rnom :initarg :rnom
			 :foreign-type :int
			 :foreign-slot-name ag-cffi::rnom)
   (current-refresh-rate :reader current-refresh-rate :reader rcur :initarg :rcur
			 :foreign-slot-name ag-cffi::rcur)
   (opengl :reader opengl-p :initarg :opengl
	   :foreign-slot-name ag-cffi::opengl)
   (windows :accessor windows :initarg :windows
	    :foreign-slot-name ag-cffi::windows
	    :foreign-type (tailqueue-head :type window)))
  (:documentation "Wrapper class for AG_Display struct")
  (:foreign-type ag-cffi::display))

(defagarvar ("agView" *view*) display "Agar Context")
