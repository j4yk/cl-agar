(in-package agar)

(defmacro defagarvar ((foreign-name varname) foreign-type &optional documentation)
  (let ((internal-varname (intern (concatenate 'string "__" (symbol-name varname)))))
    `(progn
       (defcvar (,foreign-name ,internal-varname) ,foreign-type ,documentation)
       (define-symbol-macro ,varname (if *initialized*
					 ,internal-varname
					 (restart-case (error "Agar must be initialized prior to accessing ~s" ',varname)
					    (init-agar-core ()
					      (init-core (symbol-name (gensym "AGAR")) 0)
					      ,internal-varname)))))))
