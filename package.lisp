(defpackage agar-cffi
  (:use :cl :cffi)
  (:export #:sdl-event
	   #:tailq-head
	   #:tqh-first
	   #:tailq-entry
	   #:tqe-next
	   #:display))

(defpackage agar
  (:use :cl :cffi :agar-cffi))
