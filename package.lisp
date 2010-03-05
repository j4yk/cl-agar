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
   #:init-core
   #:process-event
   #:event-loop
   ;; queues
   #:tailqueue-to-list
   ;; timeout
   #:timeouts-queued-p
   #:process-timeouts
   ;; event
   #:event
   #:set-event
   #:event-self
   #:event-ptr
   #:event-string
   #:event-int
   ;; object
   #:detach-object
   #:destroy-object
   ;; gui
   #:*video-initialized*
   #:init-video-sdl
   #:destroy-video
   #:text-msg
   ;; view
   #:windows
   #:*view*
   ;; widget
   #:enable-widget
   #:disable-widget
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
   ;; button
   #:button-new
   ;; window
   #:window
   #:window-new
   #:window-new-named
   #:window-show
   #:window-set-caption
   #:window-set-position
   #:window-draw
   #:hide-window
   #:next-window
   ;; layouting language
   #:event-callback
   #:with-widgets
   #:vbox
   #:hbox
   #:label
   #:button))
