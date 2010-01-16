(in-package agar)

;; (defclass tailqueue-head ()
;;   ((fp :accessor fp :documentation "Foreign pointer to the
;;   TAILQ_HEAD")
;;    (first :accessor tqh-first :initarg :first :documentation "TAILQ_FIRST")
;;    (last :accessor tqh-last :initarg :last :documentation "TAILQ_LAST")))

;; (define-foreign-type tailqueue-head-type ()
;;   ()
;;   (:actual-type agar-cffi:tailq-head)
;;   (:simple-parser tailqueue-head))

;; (defclass tailqueue-entry ()
;;   ((fp :accessor fp :documentation "Foreign pointer to the TAILQ_ENTRY")
;;    (next :accessor tailq-next :documentation "TAILQ_NEXT")
;;    (previous :accessor tailq-previous :documentation "TAILQ_PREV")))

(defun tailq-first (tailq-head)
  (foreign-slot-value tailq-head 'agar-cffi:tailq-head 'agar-cffi:tqh-first))

(defun tailq-next (tailq-entry)
  (foreign-slot-value tailq-entry 'agar-cffi:tailq-entry 'agar-cffi:tqe-next))

(defun tailq-to-list (tailq-head element-type tailq-entry-slot-name)
  (do* ((var (tailq-first tailq-head)
	     (tailq-next (foreign-slot-value var element-type tailq-entry-slot-name)))
	(list (list var)
	      (if (null-pointer-p var) list (push var list))))
       ((null-pointer-p var) (nreverse list))))
