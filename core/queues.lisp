(in-package agar)

(defctype tailqueue-head ag-cffi::tailqueue-head)

(define-slot-accessors tailqueue-head
  (ag-cffi::tqh-first tailqueue-first)
  (ag-cffi::tqh-first tqh-first :writable)
  (ag-cffi::tqh-last tqh-last :writable))
;; don't define tailqueue-last here, because this is sementically incorrect
;; see Agar's AG_TAILQ_LAST in queue.h

(defctype tailqueue-entry ag-cffi::tailqueue-entry)

(define-slot-accessors tailqueue-entry
  (ag-cffi::tqe-next tailqueue-entry-next)
  (ag-cffi::tqe-next tqe-next :writable)
  (ag-cffi::tqe-prev tqe-prev :writable))

(defun tailqueue-end (tailqueue-head)
  (declare (ignore tailqueue-head))
  (null-pointer)) ; there is a foreign macro with an equal lambda list...

;; according to the macro
(defun tailqueue-empty-p (tailqueue-head)
  (pointer-eq (tailqueue-first tailqueue-head) (tailqueue-end tailqueue-head)))

(defmacro tqe-of (element)
  `(funcall accessor ,element))

(defun tailqueue-next (element accessor)
  "Returns the next element of the queue.
  Accessor must be a form that can be supplied to funcall as the first argument.
  (funcall accessor element) must return the foreign tailqueue-entry struct."
  (tqe-next (tqe-of element)))

(defun tailqueue-last (head element-type)
  (mem-ref (tqh-last (tqh-last head)) element-type))

(defun tailqueue-prev (element element-type accessor)
  (mem-ref (tqh-last (tqe-prev (tqe-of element))) element-type))    

(defun tailqueue-to-list (tailqueue-head accessor)
  (do* ((element (tailqueue-first tailqueue-head)
		 (tailqueue-next element accessor))
	(list (unless (null-pointer-p element) (list element))
	      (if (null-pointer-p element) list (push element list))))
       ((null-pointer-p element) (nreverse list)))) ; reverse the list because push adds at the beginning

(defun tqh-first-ptr (head)
  (foreign-slot-pointer head 'tailqueue-head 'ag-cffi::tqh-first))

(defun tqe-next-ptr (entry)
  (foreign-slot-pointer entry 'tailqueue-entry 'ag-cffi::tqe-next))

(defun tailqueue-init (head)
  (setf (tqh-first head) (null-pointer))
  (setf (tqh-last head) (tqh-first-ptr head)))

(defun tailqueue-insert-head (head element accessor)
  (if (not (null-pointer-p (setf (tqe-next (tqe-of element))
				 (tqh-first head))))
      (setf (tqe-prev (tqe-of (tqh-first head))) (tqe-next-ptr (tqe-of element)))
      (setf (tqh-last head) (tqe-next-ptr (tqe-of element))))
  (setf (tqh-first head) element)
  (setf (tqe-prev (tqe-of element)) (tqh-first head)))

(defun tailqueue-insert-tail (head element type-of-element accessor)
  (setf (tqe-next (tqe-of element)) (null-pointer))
  (setf (tqe-prev (tqe-of element)) (tqh-last head))
  (setf (mem-ref (tqh-last head) type-of-element) element)
  (setf (tqh-last head) (tqe-next-ptr (tqe-of element))))

(defun tailqueue-insert-after (head list-element element accessor)
  (if (not (null-pointer-p (setf (tqe-next (tqe-of element))
				 (tqe-next (tqe-of list-element)))))
      (setf (tqe-prev (tqe-of (tqe-next (tqe-of element)))) (tqe-next-ptr (tqe-of element)))
      (setf (tqh-last head) (tqe-next-ptr (tqe-of element))))
  (setf (tqe-next (tqe-of list-element)) element)
  (setf (tqe-prev (tqe-of element)) (tqe-next-ptr (tqe-of list-element))))

(defun tailqueue-insert-before (list-element element element-type accessor)
  (setf (tqe-prev (tqe-of element)) (tqe-prev (tqe-of list-element)))
  (setf (tqe-next (tqe-of element)) list-element)
  (setf (mem-ref (tqe-prev (tqe-of list-element)) element-type) element)
  (setf (tqe-prev (tqe-of list-element)) (tqe-next-ptr (tqe-of element))))

(defun tailqueue-remove (head element element-type accessor)
  (if (not (null-pointer-p (tqe-next (tqe-of element))))
      (setf (tqe-prev (tqe-of (tqe-next (tqe-of element))))
	    (tqe-prev (tqe-of element)))
      (setf (tqh-last head) (tqe-prev (tqe-of element))))
  (setf (mem-ref (tqe-prev (tqe-of element)) element-type)
	(tqe-next (tqe-of element))))

(defun tailqueue-replace (head element element2 element-type accessor)
  (if (not (null-pointer-p (setf (tqe-next (tqe-of element2))
				 (tqe-next (tqe-of element)))))
      (setf (tqe-prev (tqe-of (tqe-next (tqe-of element2))))
	    (tqe-next-ptr (tqe-of element2)))
      (setf (tqh-last head) (tqe-next-ptr (tqe-of element2))))
  (setf (tqe-prev (tqe-of element2)) (tqe-prev (tqe-of element)))
  (setf (mem-ref (tqe-prev (tqe-of element2)) element-type)
	element2))
