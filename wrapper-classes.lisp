(in-package agar)

(defclass foreign-object ()
  ((fp :reader fp :initarg :fp :initform (error "Must specify foreign-pointer!"))))

(defmacro define-foreign-class ((typename base-type)
				&optional supertypes slots &rest more-defclass-args)
  (let ((classname (intern (concatenate 'string (symbol-name typename) "-CLASS"))))
    `(progn
       (defctype ,typename ,base-type)
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
		       (accessor-names (rest slot)))
		   (loop for accessor-name in accessor-names
		      collect `(defun ,accessor-name (,type)
				 (foreign-slot-value ,type ',type ',slot-name))
		      collect `(defun (setf ,accessor-name) (value ,type)
				 (setf (foreign-slot-value ,type ',type ',slot-name) value)))))))
