(defpackage agar-system
  (:use :cl :asdf))

(in-package agar-system)

(eval-when (:load-toplevel :execute)
  (operate 'load-op 'cffi-grovel))

(defsystem agar
  :description "Agar Binding"
  :version "0.1"
  :author "Jakob Reschke <jakres@gmail.com>"
  :license "BSD"
  :depends-on (:cffi)
  :serial t
  :components ((:file "package")
	       (cffi-grovel:grovel-file "agar-grovel")
	       (:file "agar-cffi")))
