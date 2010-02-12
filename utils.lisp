(in-package agar)

(defun conc-symbols (&rest symbols)
  "Concatenates symbol names and returns an interned symbol with the concatenated name"
  (intern (apply #'concatenate 'string (mapcar #'symbol-name symbols))))

(defun allocate-garbage-collected-buffer (lifetime-object type count)
  "Returns the pointer to a foreign allocated buffer which will be garbage collected with object"
  (let ((buffer (foreign-alloc type :count count)))
    (trivial-garbage:finalize lifetime-object #'(lambda () (foreign-free buffer)))
    buffer))
