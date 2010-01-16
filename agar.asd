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
  :components ((:file "package")
	       (:file "libraries" :depends-on (package))
	       (cffi-grovel:grovel-file "agar-grovel" :depends-on (package))
	       (:file "utils" :depends-on (libraries))
	       (:file core :depends-on (libraries utils))
	       (:file gui :depends-on (core))
	       (:file lispy :depends-on (core gui))
	       (:file tests :depends-on (core gui lispy))))
