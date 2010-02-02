(defpackage agar-cffi
  (:nicknames :ag-cffi)
  (:use :cl :cffi))

(defpackage agar
  (:nicknames :ag)
  (:use :cl :cffi)
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
