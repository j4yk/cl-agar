(defpackage agar-cffi
  (:use :cl :cffi)
  (:export #:sdl-event
	   #:object-class
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
  (:nicknames :ag)
  (:use :cl :cffi :agar-cffi)
  (:import-from lispbuilder-sdl
		#:foreign-object
		#:fp)
  (:export #:with-agar-core
	   #:with-video
	   #:with-sdl-video

	   #:process-event
	   #:label-new-string
	   #:window
	   #:window-new
	   #:window-show
	   #:window-set-caption
	   #:window-draw
	   #:render))
