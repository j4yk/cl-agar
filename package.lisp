(defpackage agar-cffi
  (:nicknames :ag-cffi)
  (:use :cl :cffi))

(defpackage agar
  (:nicknames :ag)
  (:use :cl :cffi #+5am :5am)
  (:export #:with-agar-core
	   #:with-video
	   #:with-sdl-video
	   #:render

	   #:process-event

	   #:label-new-string

	   #:editable
	   #:editable-new* #:editable-new #:editbable-bind
	   #:editable-set-string #:editable-clear-string
	   #:editable-set-password #:editable-set-int-only
	   #:editable-set-wordwrap #:editable-set-float-only
	   #:editable-size-hint #:editable-size-hint-pixels #:editable-size-hint-lines
	   #:editable-widget #:get-string
	   
	   #:window
	   #:window-new
	   #:window-new-named
	   #:window-show
	   #:window-set-caption
	   #:window-draw

	   #:with-widgets
	   #:vbox
	   #:hbox
	   #:label))
