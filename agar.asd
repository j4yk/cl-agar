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
  :depends-on (:cffi :lispbuilder-sdl)
  :components ((:file "package")
	       (:file wrapper-classes :depends-on (package))
	       (:file "libraries" :depends-on (package))
	       (cffi-grovel:grovel-file agar-grovel :depends-on (package))
	       (:module core :depends-on (libraries agar-grovel wrapper-classes)
			:components ((:file core)
				     (:file queues)
				     (:file object)))
	       (:module gui :depends-on (core)
			:components ((:file gui)
				     (:file view)
				     (:file widget)
				     (:file label)
				     (:file window)))
	       (:file lispy :depends-on (core gui))
	       (:file tests :depends-on (core gui lispy))))
