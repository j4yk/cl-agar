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
	       (:file utils :depends-on (package))
	       (:file wrapper-classes :depends-on (package))
	       (:file "libraries" :depends-on (package))
	       #-windows (cffi-grovel:grovel-file agar-grovel :depends-on (package))
	       (:module core :depends-on (utils libraries #-windows agar-grovel wrapper-classes)
			:components ((:file core)
				     (:file queues)
				     (:file timeout :depends-on (queues))
				     (:file object)))
	       (:module gui :depends-on (core)
			:components ((:file gui)
				     (:file view)
				     (:file widget)
				     (:file box :depends-on (widget))
				     (:file label :depends-on (widget))
				     (:file window :depends-on (widget))))
	       (:module lispy :depends-on (core gui)
			:components ((:file lispy)
				     (:file layout)
				     #+5am (:file layout-tests)))
	       (:file tests :depends-on (core gui lispy))))
