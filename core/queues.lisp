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

(defstruct tailqueue-head fp first)

(defstruct tailqueue-entry fp next)

(define-foreign-type tailq-head-type ()
  ((element-type :accessor element-type :initarg :type))
  (:actual-type :pointer))

(define-parse-method tq-head (&key (type 'object))
  (make-instance 'tailq-head-type :type type))

(defmethod translate-from-foreign (tqh-pointer (type tailq-head-type))
  (make-tailqueue-head
   :fp tqh-pointer
   :first (convert-from-foreign (foreign-slot-value tqh-pointer 'tailq-head 'tqh-first) (element-type type))))

(defmethod translate-to-foreign (tailq-head-struct (type tailq-head-type))
  (tailqueue-head-fp tailq-head-struct))				 

(define-foreign-type tailq-entry-type ()
  ((element-type :accessor element-type :initarg :type))
  (:actual-type :pointer))

(define-parse-method tq-entry (&key (type 'object))
  (make-instance 'tailq-entry-type :type type))

(defmethod translate-from-foreign (tqe-pointer (type tailq-entry-type))
  (make-tailqueue-entry :fp tqe-pointer
			:next (convert-from-foreign
			       (foreign-slot-value tqe-pointer 'tailq-entry 'tqe-next)
			       (element-type type))))

(defmethod translate-to-foreign (tailq-entry-struct (type tailq-entry-type))
  (tailqueue-entry-fp tailq-entry-struct))



(defun tailq-first (tailq-head)
  "AG_TAILQ_FIRST(head)"
  (foreign-slot-value tailq-head 'tailq-head 'tqh-first))

(defun tailq-next-e (tailq-entry)
  (foreign-slot-value tailq-entry 'tailq-entry 'tqe-next))

(defun tailq-next (element element-type tailq-slot-name)
  "AG_TAILQ_NEXT(elm, field)"
  (foreign-slot-value (foreign-slot-value element element-type tailq-slot-name) 'tailq-entry 'tqe-next))

(defun tailq-to-list (tailq-head element-type tailq-entry-slot-name)
  "Traversiert die tailqueue und sammelt die Elemente in einer Liste ein"
  ;; var is an AG_Object which is part of a tail queue
  ;; var is of type element-type
  ;; this object has got a slot tailq-entry-slot-name to which a tailqueue entry is bound
  (do* ((var (tailq-first tailq-head)	; Anfang
	     (tailq-next var element-type tailq-entry-slot-name)) ; nächstes
	(list (if (null-pointer-p var) nil (list var)) ; Listenanfang
	      (if (null-pointer-p var) list (push var list)))) ; Elemente hinzufügen
       ((null-pointer-p var) (nreverse list)))) ; Liste invertieren
