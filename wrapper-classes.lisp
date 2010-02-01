(in-package agar)

(define-symbol-macro +type-translation-value-arg+ pointer)

(defclass foreign-type-wrapper ()
  ((fp :reader fp :reader foreign-pointer :initarg :fp))
  (:default-initargs :fp (error "Must specify a foreign pointer!"))
  (:documentation "Base class for foreign wrapper classes"))

(define-foreign-type wrapped-type ()
  ()
  (:documentation "Base class for all foreign-types that are defined for a wrapper class"))

(defmethod translate-to-foreign (wrapper-object (type wrapped-type))
  "Returns the foreign pointer of the wrapper object"
  (fp wrapper-object))

(defun equal-foreign-object (obj1 type-of-obj1 obj2 type-of-obj2)
  (equal (convert-to-foreign obj1 type-of-obj1) (convert-to-foreign obj2 type-of-obj2)))

(defun getf-all (place indicator &optional default)
  "Returns all values of the property-list place that occur together
  with indicator" 
  (labels ((getf-all (place acc)
	     (let ((val (getf place indicator default)))
	       (if (null val)		
		   acc					     ; no more of these indicators
		   (let ((shortened-list (copy-list place))) ; not most efficient, but necessary
		     (remf shortened-list indicator)	     ; because this is destructive
		     (getf-all shortened-list (push val acc)))))))
    (getf-all place nil)))

(defun foreign-slot-setf-method-form (class-name writer-fn-name foreign-slot-name foreign-slot-type foreign-object-type)
  "Returns a defmethod :after form for a slot-value writer (setf) that
  sets the foreign slot value according to the new slot value."
  (let ((instance class-name))
    `(defmethod (setf ,writer-fn-name) :after (value (,instance ,class-name))
       ,(format nil "Sets the foreign slot ~s to the according new value"
		foreign-slot-name)
       (setf (foreign-slot-value (fp ,instance) ',foreign-object-type ',foreign-slot-name)
	     ,(if foreign-slot-type
		  `(convert-to-foreign value ',foreign-slot-type)
		  'value)))))

(defun parse-wrapper-slot (slot-definition class-name foreign-object-type)
  "Returns an initarg-form and writer :after methods for the slot and
  the rest of the slot-definition after :foreign-slot-name and
  :foreign-slot-type have been removed"
  (let ((foreign-slot-name (getf (cdr slot-definition) :foreign-slot-name))
	(foreign-slot-type (getf (cdr slot-definition) :foreign-type))
	(initarg (getf (cdr slot-definition) :initarg))
	(writer-names (union (getf-all (cdr slot-definition) :writer)
			     (getf-all (cdr slot-definition) :accessor))))
    (when (and (not initarg) (or foreign-slot-name foreign-slot-type))
      (error "You must specify an :initarg if you want to have the slot ~s wrapped."
	     (car slot-definition)))
    (when (and foreign-slot-type (not foreign-slot-name))
      (error ":foreign-slot-name must be specified to convert the slot ~s from~
 foreign type ~s" (car slot-definition) foreign-slot-type))
    (let ((foreign-slot-value-form     
	   (if foreign-slot-name
	       `(foreign-slot-value +type-translation-value-arg+
				    ',foreign-object-type
				    ',foreign-slot-name)))
	  (defmethod-forms
	   (when foreign-slot-name
	       (loop for writer-name in writer-names
		  collect (foreign-slot-setf-method-form class-name writer-name
							 foreign-slot-name
							 foreign-slot-type
							 foreign-object-type))))
	  (defclass-slot (copy-list slot-definition)))
      (remf (cdr defclass-slot) :foreign-slot-name) ; remove our own slot args
      (remf (cdr defclass-slot) :foreign-type)
      (values (if foreign-slot-type
	      	  `(,initarg (convert-from-foreign ,foreign-slot-value-form ',foreign-slot-type))
	      	  (if foreign-slot-name
	      	      `(,initarg ,foreign-slot-value-form) ; no conversion
	      	      nil)) ; no initialization on tranlate-from-foreign
	      defmethod-forms
	      defclass-slot))))

(defun parse-wrapper-slots (slots class-name foreign-type)
  "Returns a list of initargs for make-instance, writer functions and
  the slot-definitions that can be passed to defclass"
  (loop
     with initargs = ()
     with defclass-slots = ()
     with all-writer-methods = ()
     for slot in slots
     do (multiple-value-bind (initarg-form writer-methods defclass-slot)
	    (parse-wrapper-slot slot class-name foreign-type)
	  (setf initargs (nconc initargs initarg-form))
	  (when writer-methods (setf all-writer-methods (nconc all-writer-methods writer-methods)))
	  (push defclass-slot defclass-slots))
     finally (return (values initargs all-writer-methods defclass-slots))))

(defun parse-wrapper-class-options (options)
  "Returns the foreign-type that is wrapped by the class and
the defclass options"
  (let ((foreign-type-option (assoc :foreign-type options)))
    (if foreign-type-option
	(values (cadr foreign-type-option)
		(delete :foreign-type options :key #'car))
	(values nil options))))		; nothing special in there

(defun wrapped-slot-get-form (ptr &optional foreign-slot-name foreign-slot-type foreign-object-type)
  "Returns a form that can be evaluated to gather the translated foreign value"
  (when foreign-slot-name
    (let ((foreign-slot-value-form `(foreign-slot-value ,ptr ',foreign-object-type ',foreign-slot-name)))
      (if foreign-slot-type
	  `(convert-from-foreign ,foreign-slot-value-form ',foreign-slot-type)
	  (if foreign-slot-name
	      foreign-slot-value-form
	      nil)))))

(defun wrapper-initialize-instance-form (classname slots foreign-type)
  "Returns an initialize-instance :after method definition form for the class specifiers"
  (let* ((varname 'instance)
	 (setf-forms (loop for slot in slots
			for slotname = (first slot)
			and arglist = (rest slot)
			;; use append to avoid collecting nil
			append (let ((get-form (wrapped-slot-get-form
						`(fp ,varname)
						(getf arglist :foreign-slot-name nil)
						(getf arglist :foreign-type nil)
						foreign-type)))
				 (when get-form
				   ;; because of append encapsulate this in a list
				   (list `(setf (slot-value ,varname ',slotname)
						,get-form)))))))
    `(defmethod initialize-instance :after ((instance ,classname) &rest initargs)
       "Binds the wrapper object's slots to their translated foreign values."
       (declare (ignorable initargs))
       (format t "~%initializing ~a at ~a" ',classname (fp instance))
       ,@setf-forms)))
	     

(defmacro define-wrapper-class (classname superclasses slots &rest options)
  "Defines a wrapper class for a foreign struct.
Includes: foreign type definition, the wrapper class, a translate-from-foreign method

define-wrapper-class classname (superclass*) (slot-description*) [option*]

slot-description ::= (slot-name [:initarg initarg :foreign-slot-name foreign-slot-name
                                  [:foreign-type foreign-type]]
                                [standard-defclass-slot-option*])

Do not specify foreign-type if the grovelled slot type is already a
  converted one, for example :boolean."
  (let ((foreign-type-name (intern (concatenate 'string (symbol-name classname) "-TYPE"))))
    (multiple-value-bind (foreign-type defclass-options)
	(parse-wrapper-class-options options)
      (multiple-value-bind (translate-from-foreign-initargs writer-methods defclass-slots)
	  (parse-wrapper-slots slots classname foreign-type)
	(let ((initialize-instance-form (wrapper-initialize-instance-form classname slots foreign-type)))
	  `(progn
	     (define-foreign-type ,foreign-type-name
		 (wrapped-type) ; this enables use of #'fp in translate-to-foreign
	       ()
	       (:simple-parser ,classname)
	       (:actual-type :pointer))
	     (defclass ,classname ,(or superclasses '(foreign-type-wrapper))
	       ,defclass-slots
	       ,@defclass-options)
	     (defmethod translate-from-foreign (foreign-pointer (type ,foreign-type-name))
	       (if (null-pointer-p foreign-pointer)
		   nil
		   (make-instance ',classname :fp foreign-pointer)))
		   ;(make-instance ',classname :fp +type-translation-value-arg+ ,@translate-from-foreign-initargs)))
	     ,initialize-instance-form
	     ;; todo: auch vererbte slots initialisieren
	     ,@writer-methods))))))
