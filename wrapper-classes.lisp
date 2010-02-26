(in-package agar)

(defclass foreign-object ()
  ((fp :reader fp :initarg :fp :initform (error "Must specify foreign-pointer!"))))

(defmacro define-foreign-class ((typename base-type &optional extended-p)
				&optional supertypes slots &rest more-defclass-args)
  (let ((classname (conc-symbols typename '-class))
	(foreign-type-name (when extended-p (conc-symbols typename '-type))))
    `(progn
       ,(if extended-p
	    ;; extended means that an extended foreign type will be defined
	    ;; and a translate-to-foreign will be implemented that returns
	    ;; the fp slot of the passed object
       	    `(define-foreign-type ,foreign-type-name ()
	       ()
	       (:simple-parser ,typename)
	       (:actual-type ,base-type))
	    ;; for simple types a defctype suffices
	    `(defctype ,typename ,base-type))
       ,(when extended-p
	   `(defmethod translate-to-foreign (instance (type ,foreign-type-name))
	      "Returns the wrapper class instance's foreign pointer"
	      (fp instance)))
       (setf (get ',typename :wrapper-class) ',classname)
       (defclass ,classname ,(if supertypes
				 (mapcar #'(lambda (supertype)
					     (get supertype :wrapper-class))
					 supertypes)
				 '(foreign-object))
	 ,slots ,@more-defclass-args))))

(defmacro define-slot-accessors (type &body slots)
  "Define accessor functions and setf-functions for the foreign-type"
  `(progn
     ,@(loop for slot in slots
	  append (let ((slot-name (first slot))
		       (accessor-names (rest slot))
		       (writer-p (eq (car (last slot)) :writable)))
		   (let ((accessor-names (if writer-p
					     (cdr (nreverse accessor-names)) ; remove last element
					     accessor-names)))
		     (print accessor-names)
		     (loop for accessor-name in accessor-names
			collect `(defun ,accessor-name (,type)
				   (foreign-slot-value ,type ',type ',slot-name))
			when writer-p
			collect `(defun (setf ,accessor-name) (value ,type)
				   (setf (foreign-slot-value ,type ',type ',slot-name) value))))))))
