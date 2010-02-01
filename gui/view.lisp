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

(let ((fp (null-pointer))
      (value nil))
  (defcvar ("agView" %*view*) display "Agar Device Context")
  (defun get-*view* () (if (sb-sys:sap= (get-var-pointer '%*view*) fp)
			   value
			   (setf fp (get-var-pointer '%*view*)
				 value %*view*)))
  (define-symbol-macro *view* (get-*view*)))
