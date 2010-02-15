(in-package agar)

(defun init-display-test ()
  (with-agar-core ("init-display-test")
    (with-video (320 240 32 :resizable)
      (text-msg :info "Hello, world!")
      (event-loop))))

(defmethod handle-event (sdl-event)
  (not (= -1 (process-event sdl-event))))    

(let ((start-ticks nil))
  (defmethod timestep ()
    (unless start-ticks (setf start-ticks (sdl:system-ticks)))
    (let ((tr2 (sdl:system-ticks)))
      (cond
	((>= (- tr2 start-ticks) (rnom *view*)) ; time to redraw?
	 (render
	   (dolist (win (tailqueue-to-list (windows *view*) #'next-window))
	     (window-draw win)))
	 ;; recalibrate the effective refresh rate
	 (setf (rcur *view*) (- (rnom *view*) (- start-ticks tr2)))
	 (if (< (rcur *view*) 1)
	     (setf (rcur *view*) 1)))
	((not (null-pointer-p (tailqueue-first *timeout-object-queue*))) ; advance the timing wheels
	 (process-timeout tr2))))))

(defmacro test-run ((&body init-body) (sdl-event-arg &body idle-body))
  `(sdl:with-init ()
     (sdl:window 640 480 :opengl t)
     (setf (sdl:frame-rate) 36)
     (with-agar-core ("test-run")
       (with-sdl-video ((sdl:fp sdl:*default-display*))
	 ,@init-body
	 (sdl:with-events (:poll ,sdl-event-arg)
	   (:quit-event ()
	      (handle-event ,sdl-event-arg)
	      t)
	   (:mouse-motion-event ()
              (handle-event ,sdl-event-arg))
	   (:mouse-button-down-event ()
	      (handle-event ,sdl-event-arg))
	   (:mouse-button-up-event ()
	      (handle-event ,sdl-event-arg))
	   (:active-event ()
	      (handle-event ,sdl-event-arg))
	   (:video-resize-event ()
	      (handle-event ,sdl-event-arg))
	   (:video-expose-event ()
	      (handle-event ,sdl-event-arg))
	   (:sys-wm-event ()
	      (handle-event ,sdl-event-arg))
	   (:user-event ()
	      (handle-event ,sdl-event-arg))
	   (:idle ()
		  ,@idle-body
		  (sdl:update-display)))))))

(defun lispbuilder-sdl-test ()
  (test-run ((text-msg :info "Hello, world!")
	     (let ((win (window-new)))
	       (label-new-string win "Another window")
	       (window-show win)))
	    (sdl-event (timestep))))
