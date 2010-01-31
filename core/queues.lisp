(in-package agar)

(defstruct tailqueue-head fp first)

(defstruct tailqueue-entry fp next)

(define-foreign-type tailq-head-type ()
  ((element-type :accessor element-type :initarg :type))
  (:actual-type :pointer))

(define-parse-method tq-head (&key (type 'object))
  (make-instance 'tailq-head-type :type type))

(defmethod translate-from-foreign (tqh-pointer (type tailq-head-type))
  (let ((element-ptr (foreign-slot-value tqh-pointer 'ag-cffi::tailq-head 'ag-cffi::tqh-first)))
    (make-tailqueue-head
     :fp tqh-pointer
     :first (if (null-pointer-p element-ptr)
		nil
		(convert-from-foreign element-ptr (element-type type))))))

(defmethod translate-to-foreign (tailq-head-struct (type tailq-head-type))
  (tailqueue-head-fp tailq-head-struct))				 

(define-foreign-type tailq-entry-type ()
  ((element-type :accessor element-type :initarg :type))
  (:actual-type :pointer))

(define-parse-method tq-entry (&key (type 'object))
  (make-instance 'tailq-entry-type :type type))

(defmethod translate-from-foreign (tqe-pointer (type tailq-entry-type))
  (let ((element-ptr (foreign-slot-value tqe-pointer 'ag-cffi::tailq-entry 'ag-cffi::tqe-next)))
    (make-tailqueue-entry :fp tqe-pointer
			  :next (if (null-pointer-p element-ptr)
				    nil
				    (convert-from-foreign element-ptr (element-type type))))))

(defmethod translate-to-foreign (tailq-entry-struct (type tailq-entry-type))
  (tailqueue-entry-fp tailq-entry-struct))


(defun tailqueue-entry-from-slot (ptr type entry-slot-name)
  "Returns the tailqueue-entry struct that is yield by the conversion
of the specified foreign slot's value"
  (convert-from-foreign (foreign-slot-value ptr type entry-slot-name) `(tq-entry :type ,type)))

(defun tailqueue-entry-accessor-fn (type entry-slot-name)
  "Returns a function object that when called returns the tailqueue-entry struct of
the element (pointer) that was passed to that function."
  #'(lambda (element-ptr) (tailqueue-entry-from-slot element-ptr type entry-slot-name)))

(defun tailqueue-head-from-slot (ptr type element-type head-slot-name)
  (convert-from-foreign (foreign-slot-value ptr type head-slot-name)
			`(tq-head :type ,element-type)))

(defun tailqueue-to-list (tailqueue-head entry-accessor-function)
  (do* ((element (tailqueue-head-first tailqueue-head)
		 (tailqueue-entry-next (funcall entry-accessor-function element)))
	(list (when element (list element))
	      (push element list)))
       ((null element) list)))
