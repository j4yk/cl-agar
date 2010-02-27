(in-package agar)

(define-foreign-class (editable ag-cffi::editable) (widget))
  
(defbitfield editable-flags
  :hfill
  :vfill
  :multiline
  (:password #x10)
  :abandon-focus
  :int-only
  :flt-only
  :catch-tab
  (:noscroll #x800)
  :noscroll-once
  (:static #x4000)
  :noemacs
  :nowordseek
  :nolatin1
  :wordwrap
  (:expand #x3))

(defun editable-new (parent &rest flags)
  (foreign-funcall "AG_EditableNew"
		   widget parent
		   editable-flags flags
		   editable))

(defcfun ("AG_EditableBindUTF8" editable-bind) :void
  (editable editable) (buffer :pointer) (buffer-size size))

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
