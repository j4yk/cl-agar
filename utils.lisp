(in-package agar)

(defmacro agar-funcall (name-and-options &rest args)
  "Calls an Agar function which returns an error code. Signals an
  error of type agar-error if the return value is not 0.
This is according to AG_Intro(3)."
  `(unless (= 0 (foreign-funcall ,name-and-options ,@args agar-code))
     (error 'agar-error)))

(defmacro defagarfun (foreign-name function-name &body args)
  "Define a thin wrapper around an Agar function that behaves like the
  int-returning functions according to AG_Intro(3)."
  `(defun ,function-name ,(mapcar #'car args)
     (agar-funcall ,foreign-name ,@(loop for (arg type) in args
				      append (list type arg)))))
