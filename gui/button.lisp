(in-package agar)

(define-foreign-class (button ag-cffi::button t) (widget)
  ((associated-function :accessor associated-function :initarg :fn)))

(defbitfield button-flags)

(defcfun ("AG_ButtonNew" button-new) button
  (parent widget) (flags button-flags) (label :string))

(defun new-button-fn (parent label click-handler-function &rest flags)
  ;; to be done
  )