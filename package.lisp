(defpackage agar-cffi
  (:nicknames :ag-cffi)
  (:use :cl :cffi)
  (:export #:size))

(defpackage agar
  (:nicknames :ag)
  (:use :cl :cffi #+5am :5am :ag-cffi)
  (:export
   ;; macros
   #:with-agar-core
   #:with-video
   #:with-sdl-video
   #:render
   ;; generic functions
   #:text
   ;; core functions
   #:process-event
   ;; label
   #:label-new-string
   ;; editable
   #:editable
   #:editable-new* #:editable-new #:editbable-bind
   #:editable-set-string #:editable-clear-string
   #:editable-set-password #:editable-set-int-only
   #:editable-set-wordwrap #:editable-set-float-only
   #:editable-size-hint #:editable-size-hint-pixels #:editable-size-hint-lines
   #:editable-widget #:get-string
   ;; textbox
   #:textbox
   #:textbox-new
   ;; window
   #:window
   #:window-new
   #:window-new-named
   #:window-show
   #:window-set-caption
   #:window-draw
   ;; layouting language
   #:with-widgets
   #:vbox
   #:hbox
   #:label))
