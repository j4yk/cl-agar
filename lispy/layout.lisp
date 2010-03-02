(in-package agar)

;; This file contains the implementation of a layout building
;; language.

(defvar *layout-widget-dispatch-table* nil "An assoc list for layout macro dispatching instructions

items: (widget-type expand-function)
widget-type: symbol that names a widget type
expand-function: function that expands the specification of such widget in the macros")

(defmacro define-widget-expansion (name lambda-list &body expansion-forms)
  "(Re-)Defines a new expansion function for this widget type"
  (let ((table '*layout-widget-dispatch-table*)
	(expansion-fn `#'(lambda ,(append '(name parent-widget) lambda-list) ,@expansion-forms)))
    `(if (assoc ',name ,table)
	 (rplacd (assoc ',name ,table) (list ,expansion-fn))
	 (push (list ',name ,expansion-fn)
	       *layout-widget-dispatch-table*))))

(defun expansion-function (widget-type)
  (second (assoc widget-type *layout-widget-dispatch-table*)))

(define-widget-expansion hbox (flags &rest children)
  `((,name (hbox-new ,parent-widget ,@flags))
    ,@(recursive-expand-widgets children name)))

(define-widget-expansion vbox (flags &rest children)
  `((,name (vbox-new ,parent-widget ,@flags))
    ,@(recursive-expand-widgets children name)))

(define-widget-expansion label (text &rest flags)
  `((,name (label-new-string ,parent-widget ,text ,@flags))))

(define-widget-expansion textbox (&key label-text (buffer-size 100) (size-hint "XXXXXXXXXXXXXXX") init-text flags)
  `((,name (textbox-new ,parent-widget :label-text ,label-text :buffer-size ,buffer-size
			:size-hint ,size-hint :init-text ,init-text :flags ,flags))))

(define-widget-expansion button (label &key flags callback-spec)
  `((,name (let ((btn (button-new ,parent-widget ,flags ,label)))
	     ,(when callback-spec
		    `(set-event btn "button-pushed" ,@(eval callback-spec))) ; eval, damit event-callback erweitert wird
	     btn))))

(defmacro event-callback (callback fmt &rest event-args)
  "Stellt Daten für callback-Spezifizierungen in der Layoutsprache bereit"
  `(list '(cffi:callback ,callback) ,fmt ,@event-args))

(defun expand-widget (parent-widget widget)
  "Expands a single widget specification, including its children widgets,
into a list of let*-binding-forms that can be used to create these widgets."
  (destructuring-bind (type name &rest arguments) widget
    (let ((item (assoc type *layout-widget-dispatch-table*)))
      (assert item nil "No expansion for widget ~s defined!" type)
      (apply (expansion-function type) name parent-widget arguments))))

(defun recursive-expand-widgets (widgets parent-widget &optional acc)
  "Expands the widgets into a list of let*-bindings"
  (if (null widgets)
      acc
      (let ((expansion (expand-widget parent-widget (first widgets))))
	(recursive-expand-widgets (cdr widgets) parent-widget
				  (nconc acc expansion)))))

(defun expand-widgets (widgets parent-widget body-forms)
  "Expands the widgets into a let* form with body-forms as its body

parent-widget is used as the parent widget of the toplevel widgets"
  (declare (ftype (function (list t list) list) expand-widgets))
  (let ((widget-bindings (recursive-expand-widgets widgets parent-widget)))
    `(let* ,widget-bindings
       ,@body-forms)))

(defmacro with-widgets ((parent-widget &body widgets) &body body)
  "Expands and creates the widgets with correct nesting.
In the context of body the variable names of the widgets are bound."
  (expand-widgets widgets parent-widget body))
