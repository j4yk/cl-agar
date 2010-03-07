(in-package agar)

(define-foreign-class (event ag-cffi::event) ())

(defmacro define-event-accessor (fn-name type variable-data-slot-name &body pre-body)
  `(defun ,fn-name (event ntharg)
     ,@pre-body
     (let ((var (mem-aref (foreign-slot-pointer event 'event 'ag-cffi::argv) 'var ntharg))) ; AG_Variable
       (if (eq (variable-type var) ,type)
	   (foreign-slot-value (variable-data var) 'variable-data ',variable-data-slot-name)
	   (error "Wrong Agar variable type! Wanted ~s but is ~s" ,type (foreign-enum-keyword 'variable-type (variable-type var)))))))

(define-event-accessor event-ptr :pointer ag-cffi::p
  "AG_PTR(v)")

(define-event-accessor event-string :string ag-cffi::s
  "AG_STRING(v)")

(define-event-accessor event-int :int ag-cffi::i
  "AG_INT(v)")

(defun event-self (event)
  "AG_SELF(), returns a pointer to the AG_Object receiveing the event"
  (event-ptr event 0))

(defcfun ("AG_SetEvent" set-event) event
  "Registers a new event handler to service events of type event-name."
  (object object) (event-name :string) (handler :pointer) (fmt :string) &rest)

(defmacro define-set-event-macro (event-name)
  (let* ((symbol (if (stringp event-name)
		     (intern (string-upcase event-name))
		     event-name))
	 (string (if (stringp event-name)
		     event-name
		     (string-downcase (symbol-name event-name))))
	 (fn-name (conc-symbols 'set- symbol '-event)))
    `(defmacro ,fn-name (object callback &optional (fmt "") &rest varargs)
       `(set-event ,object ,',string ,callback ,fmt ,@varargs))))

(defmacro define-set-event-macros (&rest event-names)
  (labels ((def (event-names acc)
	     (if (null event-names)
		 acc
		 (def (cdr event-names)
		     (cons `(define-set-event-macro ,(car event-names)) acc)))))
    `(progn
       ,@(def event-names nil))))	       

(defcfun ("AG_PostEvent" post-event) :void
  (sender :pointer) (receiver :pointer) (event-name :string) (fmt :string) &rest)
