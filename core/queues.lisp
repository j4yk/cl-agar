(in-package agar)

(defstruct tailqueue-head fp first last)

(defstruct tailqueue-entry fp next prev)

(define-symbol-macro +tailqueue-end+ nil)

(define-foreign-type tailqueue-head-type ()
  ((element-type :accessor element-type :initarg :type))
  (:actual-type :pointer))

(define-parse-method tailqueue-head (&key (type 'object))
  (make-instance 'tailqueue-head-type :type type))

(defmethod translate-from-foreign (tqh-pointer (type tailqueue-head-type))
  (if (null-pointer-p tqh-pointer)
      nil
      (let ((element-ptr (foreign-slot-value tqh-pointer 'ag-cffi::tailq-head 'ag-cffi::tqh-first)))
	(make-tailqueue-head
	 :fp tqh-pointer
	 :first (if (null-pointer-p element-ptr)
		    nil
		    (convert-from-foreign element-ptr (element-type type)))))))

(defmethod translate-to-foreign (tailq-head-struct (type tailqueue-head-type))
  (tailqueue-head-fp tailq-head-struct))				 

(define-foreign-type tailqueue-entry-type ()
  ((element-type :accessor element-type :initarg :type))
  (:actual-type :pointer))

(define-parse-method tailqueue-entry (&key (type 'object))
  (make-instance 'tailqueue-entry-type :type type))

(defmethod translate-from-foreign (tqe-pointer (type tailqueue-entry-type))
  (if (null-pointer-p tqe-pointer)
      nil
      (let ((element-ptr (foreign-slot-value tqe-pointer 'ag-cffi::tailq-entry 'ag-cffi::tqe-next)))
	(make-tailqueue-entry :fp tqe-pointer
			      :next (if (null-pointer-p element-ptr)
					nil
					(convert-from-foreign element-ptr (element-type type)))))))

(defmethod translate-to-foreign (tailq-entry-struct (type tailqueue-entry-type))
  (tailqueue-entry-fp tailq-entry-struct))

;; user functions from here

(defun tailqueue-entry-from-slot (ptr type entry-slot-name)
  "Returns the tailqueue-entry struct that is yield by the conversion
of the specified foreign slot's value"
  (convert-from-foreign (foreign-slot-value ptr type entry-slot-name) `(tailqueue-entry :type ,type)))

(defun tailqueue-entry-accessor-fn (type entry-slot-name)
  "Returns a function object that when called returns the tailqueue-entry struct of
the element (pointer) that was passed to that function."
  #'(lambda (element-ptr) (tailqueue-entry-from-slot element-ptr type entry-slot-name)))

(defun tailqueue-head-from-slot (ptr type element-type head-slot-name)
  (convert-from-foreign (foreign-slot-value ptr type head-slot-name)
			`(tailqueue-head :type ,element-type)))

(defun tailqueue-first (tailqueue-head)
  (tailqueue-head-first tailqueue-head))

(defun tailqueue-end (tailqueue-head)
  (declare (ignore tailqueue-head))
  nil)					; there is a foreign macro with an equal lambda list...

(defun tailqueue-empty-p (tailqueue-head) 
  (eq (tailqueue-first tailqueue-head) (tailqueue-end tailqueue-head)))

(defun tailqueue-next (element accessor)
  "Returns the next element of the queue.
Accessor is either a function or a symbol.
If it is a function, its return value when called with element as the
  only argument is assumed to be the tailqueue-entry of that element.
If it is a symbol, the slot of element with that name is assumed to
  contain the tailqueue-entry."
  (tailqueue-entry-next (cond ((functionp accessor) (funcall accessor element))
			      ((symbolp accessor) (slot-value element accessor))
			      (t (error "tailqueue-next cannot handle accessors of type ~s"
					(type-of accessor))))))

(defun tailqueue-to-list (tailqueue-head entry-accessor-function)
  (do* ((element (tailqueue-head-first tailqueue-head)
		 (tailqueue-next element entry-accessor-function))
	(list (when element (list element))
	      (if element (push element list) list)))
       ((null element) list)))
