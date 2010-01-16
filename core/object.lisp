(in-package agar)

;; Agar depends on SDL anyway
(defclass object (foreign-object)
  ()
  (:documentation "Wrapper for AG_Object"))

(define-foreign-type object-type ()
  ()
  (:actual-type :pointer)
  (:simple-parser object))

(defmethod translate-to-foreign (object (type object-type))
  "Extract foreign-pointer from agar object"
  (fp object))

(defmethod translate-from-foreign (value (type object-type))
  (make-instance 'object :fp value :free #'(lambda (fp) fp)))
