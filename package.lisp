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
   ;; time
   #:get-ticks
   ;; queues
   #:tailqueue-first
   #:tailqueue-last
   #:tailqueue-end
   #:tailqueue-empty-p
   #:tailqueue-next
   #:tailqueue-prev
   #:tailqueue-to-list
   #:tailqueue-init
   #:tailqueue-insert-head
   #:tailqueue-insert-tail
   #:tailqueue-insert-after
   #:tailqueue-insert-before
   #:tailqueue-remove
   #:tailqueue-replace
   ;; list
   #:agar-list-n #:agar-list-count
   #:agar-list-v #:agar-list-items
   ;; timeout
   #:timeout
   #:timeout-ival
   #:timeout-ticks
   #:timeout-flags
   #:timeout-timeouts
   #:set-timeout
   #:schedule-timeout
   #:delete-timeout
   #:define-timeout-callback
   #:lock-timeouts
   #:unlock-timeouts
   #:with-locked-timeouts
   #:timeout-is-scheduled
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
   #:object-timeouts
   #:object-tobjs
   ;; gui
   #:*video-initialized*
   #:init-video-sdl
   #:destroy-video
   ;; view
   #:windows
   #:lmodal
   #:*view*
   ;; widget
   #:enable-widget
   #:disable-widget
   #:hide-widget
   #:show-widget
   #:expand
   #:expand-horiz
   #:expand-vert
   #:widget-x
   #:widget-y
   ;; boxes
   #:set-box-label
   #:set-box-depth
   #:set-box-spacing
   #:set-box-padding
   ;; vbox
   #:vbox-new
   ;; hbox
   #:hbox-new
   ;; label
   #:label-new-string
   #:size-hint-label
   #:new-polled-label
   #:new-label
   #:label-string
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
   #:textbox-size-hint
   ;; button
   #:button-new
   #:button-new-fn
   #:new-button
   #:button-text
   #:set-button-padding
   ;; radio
   #:new-radio
   #:new-radio-fn
   #:new-radio-int
   #:new-radio-uint
   #:set-radio-changed-event
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
   #:ucombo-button
   #:set-ucombo-selected-event
   ;; window
   #:window
   #:window-new
   #:window-new-named
   #:window-show
   #:window-set-caption
   #:set-window-position
   #:set-window-padding
   #:window-draw
   #:hide-window
   #:next-window
   #:window-update
   #:set-window-geometry
   #:set-window-shown-event
   ;; text
   #:text-msg
   #:prompt-options
   ;; layouting language
   #:event-callback
   #:with-widgets
   #:vbox
   #:hbox
   #:label
   #:button))
