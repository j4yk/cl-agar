(in-package agar)

(defctype tailqueue-head ag-cffi::tailqueue-head)

(defun tailqueue-first (tailqueue-head)
  (foreign-slot-value tailqueue-head 'tailqueue-head 'ag-cffi::tqh-first))

(defctype tailqueue-entry ag-cffi::tailqueue-entry)

(defun tailqueue-entry-next (tailqueue-entry)
  (foreign-slot-value tailqueue-entry 'tailqueue-entry 'ag-cffi::tqe-next))

;; TODO: dig into this warning here:
;; conflicts with asserted type: SAP <> TAILQUEUE-ENTRY

;; user functions from here

(defun tailqueue-end (tailqueue-head)
  (declare (ignore tailqueue-head))
  (null-pointer)) ; there is a foreign macro with an equal lambda list...

;; according to the macro
(defun tailqueue-empty-p (tailqueue-head)
  (pointer-eq (tailqueue-first tailqueue-head) (tailqueue-end tailqueue-head)))

(defun tailqueue-next (element accessor)
  "Returns the next element of the queue.
Accessor is either a function or a symbol.
If it is a function, its return value when called with element as the
  only argument is assumed to be the tailqueue-entry of that element.
If it is a symbol, the slot of element with that name is assumed to
  contain the tailqueue-entry."
  (tailqueue-entry-next (funcall accessor element)))

(defun tailqueue-to-list (tailqueue-head accessor)
  (do* ((element (tailqueue-first tailqueue-head)
		 (tailqueue-next element accessor))
	(list (unless (null-pointer-p element) (list element))
	      (if (null-pointer-p element) list (push element list))))
       ((null-pointer-p element) list)))
