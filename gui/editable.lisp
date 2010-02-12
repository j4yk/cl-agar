(in-package agar)

(define-foreign-class (editable ag-cffi::editable t) (widget)
  ((text-buffer-ptr :accessor text-buffer-ptr)
   (text-buffer-size :reader text-buffer-size :initarg :buffer-size :initform 100))
  (:documentation "A wrapper for an editable widget that holds the text buffer"))

(defclass editable (editable-class) ())	; use the nice name instead of editable-class

(defmethod initialize-instance :after ((editable editable) &key)
  "Allocates the foreign text buffer and defines a garbage collecting procedure"
  (setf (text-buffer-ptr editable)
	(foreign-alloc :char :count (1+ (text-buffer-size editable)))) ; 1+ for null-termination
  (editable-bind editable (text-buffer-ptr editable) (text-buffer-size editable))
  (let ((buffer-ptr (text-buffer-ptr editable)))
    (trivial-garbage:finalize
     editable
     #'(lambda () (foreign-free buffer-ptr)))))
  
(defbitfield editable-flags
  :multiline
  :static
  :password
  :abandon-focus
  :int-only
  :flt-only
  :catch-tab
  :noscroll
  :noscroll-once
  :noemacs
  :nowordseek
  :nolatin1
  :hfill
  :vfill
  :expand)

(defun foreign-editable-new (parent &rest flags)
  (foreign-funcall "AG_EditableNew"
		   widget parent
		   editable-flags flags
		   editable))

(defun editable-new (parent &rest flags)
  "Makes a new AG_Editable with text buffer of size 100"
  (make-instance 'editable :fp (apply #'foreign-editable-new parent flags)))

(defun editable-new* (parent &key buffer-size init-text flags)
  "Makes a new AG_Editable with text buffer of arbitrary size"
  (let ((editable (make-instance 'editable :fp (apply #'foreign-editable-new parent flags)
				 :buffer-size buffer-size)))
    (when init-text (setf (text editable) init-text))
    editable))

(defcfun ("AG_EditableBindUTF8" editable-bind) :void
  (editable editable) (buffer :pointer) (buffer-size :size))

;; this is only from Agar 1.4.0:
;; (defcfun ("AG_EditableBindAutoUTF8" editable-bind-auto
;; 				    :documentation "Tells Agar to automatically resize the text buffer to accomodate new input")
;;     :void
;;   (editable editable) (ptr-to-bufferptr :pointer) (ptr-to-buffer-size :pointer))

(set-flag-function "AG_EditableSetPassword" editable-set-password editable)
(set-flag-function "AG_EditableSetWrodWrap" editable-set-wordwrap editable)
(set-flag-function "AG_EditableSetIntOnly" editable-set-int-only editable)
(set-flag-function "AG_EditableSetFltOnly" editable-set-float-only editable)

(defcfun ("AG_EditableSizeHint" editable-size-hint) :void
  (editable editable) (text :string))

(defcfun ("AG_EditableSizeHintPixels" editable-size-hint-pixels) :void
  (editable editable) (w :uint) (h :uint))

(defcfun ("AG_EditableSizeHintLines" editable-size-hint-lines) :void
  (editable editable) (number-of-lines :uint))

(defcfun ("AG_EditableSetString" editable-set-string) :void
  (editable editable) (string :string))

(defcfun ("AG_EditableClearString" editable-clear-string) :void
  (editable editable))

(defmethod text ((editable editable))
  "Returns the translation of the string in the buffer that Agar binds for that AG_Editable"
  ;; dereference the pointer text-buffer-ptr-ptr points to
  ;; and use the size value that text-buffer-size-ptr points to
  (foreign-string-to-lisp (text-buffer-ptr editable)
			  :count (text-buffer-size editable)))

(defmethod (setf text) (text (editable editable))
  "Sets the contents of the Editable's text buffer"
  (editable-set-string editable text))
