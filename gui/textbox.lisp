(in-package agar)

(define-foreign-class (textbox ag-cffi::textbox t) (widget)
  ((editable :accessor editable)
   (text-buffer-ptr :accessor text-buffer-ptr)
   (text-buffer-size :reader text-buffer-size :initarg :buffer-size :initform 100))
  (:documentation "A wrapper for a textbox widget that holds the text buffer"))

(defclass textbox (textbox-class) ())

(defbitfield textbox-flags
  :multiline
  (:password #x4)
  :abandon-focus
  (:hfill #x20)
  :vfill
  (:int-only #x200)
  :flt-only
  :catch-tab
  (:static #x4000)
  :noemacs
  :nowordseek
  :nolatin1
  (:expand #x60))

;; actually the definition is void AG_TextboxPrintf(AG_Textbox *tb, const char *fmt, ...)
;; but formatting is better done with #'format
(defcfun ("AG_TextboxPrintf" textbox-set-string) :void
    (textbox textbox) (string :string))

(defun textbox-size-hint (textbox hint-str)
  (editable-size-hint (editable textbox) hint-str))

(defmethod initialize-instance :after ((textbox textbox) &key)
  "Allocates the foreign text buffer and defines a garbage collecting procedure"
  (setf (editable textbox) (foreign-slot-value (fp textbox) 'ag-cffi::textbox 'ag-cffi::ed)))

(defun foreign-textbox-new (parent flags &optional label-text)
  (if label-text
      (foreign-funcall "AG_TextboxNew"
		       widget parent
		       textbox-flags flags
		       :string label-text
		       textbox)
      (foreign-funcall "AG_TextboxNew"
		       widget parent
		       textbox-flags flags
		       :pointer (null-pointer)
		       textbox)))

(defun textbox-new (parent-widget &key label-text (buffer-size 100) (size-hint "twenty chars        ")
		    init-text flags)
  (let ((textbox (make-instance 'textbox
				:fp (foreign-textbox-new parent-widget flags label-text)
				:buffer-size buffer-size)))
    (when init-text (setf (text textbox) init-text))
    (when size-hint (textbox-size-hint textbox size-hint))
    textbox))

(defmethod text ((textbox textbox))
  (foreign-string-to-lisp (text-buffer-ptr textbox)))

(defmethod (setf text) (text (textbox textbox))
  (textbox-set-string textbox text))
