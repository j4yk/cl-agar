(in-package agar)

(define-foreign-class (ucombo ag-cffi::ucombo) (widget))

(define-slot-accessors ucombo
  (ag-cffi::list ucombo-list)
  (ag-cffi::button ucombo-button))

(defbitfield ucombo-flags
  :hfill :vfill
  (:scroll-to-sel #x40))

(defcfun ("AG_UComboNew" %new-ucombo) ucombo
  (parent :pointer) (flags ucombo-flags))

(defun new-ucombo (parent &rest flags)
  (funcall #'%new-ucombo parent flags))

(defcfun ("AG_UComboNewPolled" new-polled-ucombo) ucombo
  (parent :pointer) (flags ucombo-flags) (fn :pointer) (fmt :string) &rest)
