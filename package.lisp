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
   #:post-event
   #:event-self
   #:event-ptr
   #:event-string
   #:event-int
   ;; variables
   #:bind-pointer
   #:bind-int
   #:bind-float
   #:bind-double
   ;; object
   #:attach-object
   #:detach-object
   #:parent-object
   #:destroy-object
   #:lock-object
   #:unlock-object
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
   #:hide-widget
   #:show-widget
   #:expand
   #:expand-horiz
   ;; vbox
   #:vbox-new
   ;; hbox
   #:hbox-new
   ;; label
   #:label-new-string
   #:size-hint-label
   #:new-polled-label
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
   #:button-new-fn
   ;; tlist
   #:tlist
   #:tlist-begin
   #:tlist-end
   #:tlist-add
   #:tlist-add-ptr
   #:tlist-select
   #:tlist-select-ptr
   #:tlist-items
   #:tlist-n-items #:tlist-items-count
   #:tlist-item
   #:tlist-item-ptr
   #:tlist-item-selected-p
   #:tlist-item-flags
   ;; ucombo
   #:new-ucombo
   #:new-polled-ucombo
   #:ucombo-list
   ;; window
   #:window
   #:window-new
   #:window-new-named
   #:window-show
   #:window-set-caption
   #:window-set-position
   #:set-window-padding
   #:window-draw
   #:hide-window
   #:next-window
   #:window-update
   #:set-window-geometry
   ;; layouting language
   #:event-callback
   #:with-widgets
   #:vbox
   #:hbox
   #:label
   #:button))
