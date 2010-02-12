(in-package agar)

(defun conc-symbols (&rest symbols)
  "Concatenates symbol names and returns an interned symbol with the concatenated name"
  (intern (apply #'concatenate 'string (mapcar #'symbol-name symbols))))
