(in-package agar)

(defmacro agar-funcall (name-and-options &rest args)
  "Ruft eine Agar-Funktion, die einen Fehlerstatus zurückgibt, auf und
  singalisiert einen Fehler vom Typ agar-error, wenn die Funktion
  nicht 0 zurückgibt."
  `(unless (= 0 (foreign-funcall ,name-and-options ,@args agar-code))
     (error 'agar-error)))

(defmacro defagarfun (foreign-name function-name &body args)
  `(defun ,function-name ,(mapcar #'car args)
     (agar-funcall ,foreign-name ,@(loop for (arg type) in args
				      append (list type arg)))))
