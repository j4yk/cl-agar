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
	((>= (- tr2 tr1) (rnom *view*)) ; time to redraw?
	 (render
	   (dolist (win (tailqueue-to-list (windows *view*) #'next-window))
	     (window-draw win)))
	 ;; recalibrate the effective refresh rate
	 (setf (rcur *view*) (- (rnom *view*) (- tr1 tr2)))
	 (if (< (rcur *view*) 1)
	     (setf (rcur *view*) 1)))
	((not (null-pointer-p (tailqueue-first *timeout-object-queue*))) ; advance the timing wheels
	 (process-timeout tr2))))))

(defun lispbuilder-sdl-test ()
  (sdl:with-init ()
    (sdl:window 320 240 :opengl t)
    (setf (sdl:frame-rate) 36)
    (with-agar-core ("lispbuilder-sdl with Agar")
      (with-sdl-video ((sdl:fp sdl:*default-display*))
	(text-msg :info "Hello, world!")
	(let ((win (window-new)))
	  (label-new-string win "Another window")
	  (window-show win))
	(sdl:with-events (:poll sdl-event)
	  (:quit-event () t)
	  (:mouse-motion-event ()
			       (handle-event sdl-event))
	  (:mouse-button-down-event ()
				    (handle-event sdl-event))
	  (:mouse-button-up-event ()
				  (handle-event sdl-event))
	  (:idle ()
		 (timestep)
		 (sdl:update-display)))))))
