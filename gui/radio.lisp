(in-package agar)

(define-foreign-class (radio ag-cffi::radio) (widget))

(define-slot-accessors radio
  (ag-cffi::oversel radio-oversel))

(defbitfield radio-flags)

(define-foreign-type radio-items-type ()
  ()
  (:simple-parser radio-items)
  (:actual-type :pointer)
  (:documentation "Designates a null-terminated array of strings"))

(defmethod translate-to-foreign (strings (type radio-items-type))
  "Allocates a null terminated string array for the items"
  (check-type strings list)
  (let ((ptr (foreign-alloc :pointer :count (length strings) :null-terminated-p t)))
    (prog1 ptr
      (do ((n 0 (1+ n))
	   (strings strings (cdr strings)))
	  ((null strings))
	(setf (mem-aref ptr :pointer n) (foreign-string-alloc (car strings)))))))

(defmethod free-translated-object (ptr (eql radio-items-type) param)
  "Frees the foreign strings and the array"
  (declare (ignore param))
  (do ((ptr ptr (incf-pointer ptr (foreign-type-size :pointer))))
      ((null-pointer-p (mem-aref ptr :pointer))) ; null terminated
    (foreign-free (mem-aref ptr :pointer))) ; free the strings
  (foreign-free ptr))

(defcfun ("AG_RadioNew" new-radio) radio
  (parent widget) (flags radio-flags) (items radio-items))

(defcfun ("AG_RadioNewFn" new-radio-fn) radio
  (parent widget) (flags radio-flags) (items radio-items)
  (fn :pointer) (fmt :string) &rest)

(defcfun ("AG_RadioNewInt" new-radio-int) radio
  (parent widget) (flags radio-flags) (items radio-items)
  (variable :pointer))

(defcfun ("AG_RadioNewUint" new-radio-uint) radio
  (parent widget) (flags radio-flags) (items radio-items)
  (variable :pointer))

(define-set-event-macros radio-changed)
