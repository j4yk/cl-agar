(in-package agar)

(define-foreign-class (button ag-cffi::button) (widget)
  ())

(defbitfield button-flags)

(defcfun ("AG_ButtonNew" button-new) button
  (parent widget) (flags button-flags) (label :string))

(defcfun ("AG_ButtonNewFn" button-new-fn) button
  (parent widget) (flags button-flags) (caption :string)
  (fn :pointer) (fmt :string) &rest)

(defmacro new-button (parent flags label &optional fn (fmt "") &rest varargs)
  (if fn
      `(button-new-fn ,parent ,flags ,label ,fn ,fmt ,@varargs)
      `(button-new ,parent ,flags ,label)))

(defcfun ("AG_ButtonText" button-text) :void
  (button button) (text :string))

(define-set-event-macros button-pushed)
