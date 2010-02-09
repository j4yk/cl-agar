(in-package agar)

(defmacro with-parent-widget ((parent-widget) &body body)
  "Rebinds *parent* in the context for body"
  `(let ((*parent* ,parent-widget))
     ,@body))

(defun layout-expand-vbox (flags children)
  (let ((boxvar (gensym "VBOX")))
    `(let ((,boxvar (vbox-new *parent* ,@flags)))
       (with-parent-widget (,boxvar)
	 ,@(layout-expand-children children nil)))))

(defun layout-expand-label (text flags)
  `(label-new-string *parent* ,text ,@flags))

(defun expand-child (children)
  "Returns a form to create the widget and the number of read elements from the children-list"
  (etypecase (first children)
    (list				; compound widget
     (let* ((child (first children))
	    (widget-type (first child)))
       (ecase widget-type
	 (vbox (values (layout-expand-vbox (second child) (cddr child)) 1))
	 (label (values (layout-expand-label (second child) (cddr child)) 1)))))
    (keyword 				; special instruction
     (ecase (first children)
       (:list			; a list of widget defs follows
	(warn ":list not implemented")
	(values nil 1)
	)
       (:eval 			; the following expression is to be evaluated
	(warn ":list not implemented")
	(values nil 1))))))

(defun layout-expand-children (children result-forms)
  "Expands forms to create a tree of widgets and returns forms that actually build such a tree"
  (check-type children list)
  (if (null children)
      result-forms		
      (multiple-value-bind (next-child n-read-forms) (expand-child children)
	(layout-expand-children (nthcdr n-read-forms children) (nconc result-forms (list next-child))))))
    

(defmacro create-window-layout (window-var (&key name caption flags) &body children)
  `(let ((,window-var (window-new-named ,name ,@flags)))
     (window-set-caption win ,caption)
     (with-parent-widget (,window-var)
       ,@(layout-expand-children children nil))))
