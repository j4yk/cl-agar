(defpackage agar-cffi
  (:use :cl :cffi)
  (:export #:sdl-event
	   #:tailq-head
	     #:tqh-first
	   #:tailq-entry
	     #:tqe-next
	   #:rect2
	   #:display
	     #:opengl
	     #:windows
	   #:widget
	     #:r-view
	   #:window
	     #:visible))

(defpackage agar
  (:use :cl :cffi :agar-cffi)
  (:import-from lispbuilder-sdl
		#:foreign-object
		#:fp))
