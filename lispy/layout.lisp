(in-package agar)

(defmacro with-parent-widget ((parent-widget) &body body)
  "Rebinds *parent* in the context for body"
  `(let ((*parent* ,parent-widget))
     ,@body))

(defun have-new-parent-widget (create-function arguments children)
  (let ((varname (gensym "AGAR-PARENT-WIDGET")))
    `(let ((,varname (funcall ,create-function *parent* ,@arguments)))
       (with-parent-widget (,varname)
	 ,@(layout-expand-children children nil)))))

(defvar *layout-widget-dispatch-table* nil "An assoc list for layout macro dispatching instructions

items: (widget-type expand-function)
widget-type: symbol that names a widget type
expand-function: function that expands the specification of such widget in the macros")

(defmacro define-widget-expansion (name lambda-list &body expansion-forms)
  `(pushnew (list ',name #'(lambda ,lambda-list ,@expansion-forms))
	    *layout-widget-dispatch-table*
	    :key 'car))  

(define-widget-expansion hbox (flags &rest children)
  (have-new-parent-widget #'hbox-new flags children))

(define-widget-expansion vbox (flags &rest children)
  (have-new-parent-widget #'vbox-new flags children))

(define-widget-expansion label (text &rest flags)
  `(label-new-string *parent* ,text ,@flags))

(defun expand-compound-widget (widget-type arguments)
  (let ((item (assoc widget-type *layout-widget-dispatch-table*)))
    (assert item nil "No expansion for widget ~s defined!" widget-type)
    (values (apply (second item) arguments) (or (third item) 1))))  

(defun expand-child (children)
  "Returns a form to create the widget and the number of read elements from the children-list"
  (etypecase (first children)
    (list				; compound widget
     (let* ((child-form (first children)))
       (expand-compound-widget (car child-form) (cdr child-form))))
    (keyword 				; special instruction
     (ecase (first children)
       (:list			; a list of widget defs follows
	(warn ":list not implemented")
	(values nil 2)
	)
       (:eval 			; the following expression is to be evaluated
	(warn ":list not implemented")
	(values nil 2))))))

(defun layout-expand-children (children result-forms)
  "Expands forms to create a tree of widgets and returns forms that actually build such a tree"
  (check-type children list)
  ;; this function works recursive until there are no children left
  ;; the widget-creating forms are accumulated in result-forms
  (if (null children)
      result-forms
      (multiple-value-bind (next-child n-read-forms) (expand-child children)
	(layout-expand-children (nthcdr n-read-forms children) (nconc result-forms (list next-child))))))
    

(defmacro create-window-layout (window-var (&key name caption flags) &body children)
  `(let ((,window-var (window-new-named ,name ,@flags)))
     (window-set-caption win ,caption)
     (with-parent-widget (,window-var)
       ,@(layout-expand-children children nil))))
