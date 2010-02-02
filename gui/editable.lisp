(in-package agar)

(define-foreign-class (editable ag-cffi::editable) (widget))

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

(defun %editable-new (parent &rest flags)
  (foreign-funcall "AG_EditableNew"
		   widget parent
		   editable-flags flags
		   editable))

(defcfun ("AG_EditableBindUTF8" editable-bind :documentation "Binds the widget to a text buffer in UTF8 encoding") :void
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
;; this may be used for AG_EditablePrintf as will in combination with #'format

(defcfun ("AG_EditableClearString" editable-clear-string) :void
  (editable editable))

(defclass editable-widget (editable)
  ((text-buffer-ptr :accessor text-buffer-ptr)
   (text-buffer-size :reader text-buffer-size :initarg :buffer-size :initform 100))
  (:documentation "A wrapper for an editable widget that holds the text buffer"))

(defun editable-new (parent &rest flags)
  (make-instance 'editable-widget :fp (apply #'%editable-new parent flags)))

(defun editable-new* (parent buffer-size &rest flags)
  (make-instance 'editable-widget :fp (apply #'%editable-new parent flags)
		 :buffer-size buffer-size))

(defmethod initialize-instance :after ((editable editable-widget) &key)
  ;; allocate buffer
  (setf (text-buffer-ptr-ptr editable)
	(foreign-alloc :char :count (text-buffer-size editable)))
  ;; let agar bind the buffer
  (editable-bind editable (text-buffer-ptr editable) (text-buffer-size editable))
  ;; make sure those resources are freed when our editable ceases to exist
  (let ((text-buffer-ptr (text-buffer-ptr-ptr editable)))
    (tg:finalize editable (lambda ()
			    ;; problem: the memory allocated by Agar was not allocated with foreign-alloc,
			    ;; that's why I doubt it can be freed with foreign-free
			    ;; meanwhile I hope that the Editable cleans up its buffer itself
			    (foreign-free text-buffer-ptr)))))

(defmethod get-string ((editable editable-widget))
  "Returns the translation of the string in the buffer that Agar binds for that AG_Editable"
  ;; dereference the pointer text-buffer-ptr-ptr points to
  ;; and use the size value that text-buffer-size-ptr points to
  (foreign-string-to-lisp (text-buffer-ptr editable)
			  :count (text-buffer-size editable)))
