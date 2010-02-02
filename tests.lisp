(in-package agar)

(defun init-display-test ()
  (with-agar-core ("init-display-test")
    (with-video (320 240 32 :resizable)
      (text-msg :info "Hello, world!")
      (event-loop))))

(defun custom-event-loop ()
  ;; http://wiki.libagar.org/wiki/Custom_event_loop
  (with-foreign-objects ((ev 'agar-cffi::sdl-event)) ; actually a pointer
    (let ((tr1 (foreign-funcall "SDL_GetTicks" :uint32)))
      (loop
	 (let ((tr2 (foreign-funcall "SDL_GetTicks" :uint32)))
	   (cond
	     ((>= (- tr2 tr1) (rnom *view*)) ; time to redraw?
	      (format t "~%render")
	      (render
		(dolist (win (tailqueue-to-list (windows *view*) #'windows))
		  (window-draw win))))
	     ((not (= 0 (foreign-funcall "SDL_PollEvent" agar-cffi::sdl-event ev :int)))
	      (format t "~%event")
	      ;; send all SDL events to AGAR GUI
	      (when (= -1 (process-event ev))
		;; process event returns -1 if the app is going to be quit
		(return)))
	     ((not (null (tailqueue-first *timeout-object-queue*))) ; advance the timing wheels
	      (format t "~%timeout")
	      (process-timeout tr2))
	     ((> (rcur *view*) *idle-thresh*)
	      ;; idle the rest of the time
	      (format t "~%idle")
	      (foreign-funcall "SDL_Delay" :int (- (rcur *view*) *idle-thresh*)))))))))

(defun custom-event-loop-test ()
  (with-agar-core ("custom-event-loop-test")
    (with-video (320 300 32 :resizable)
      (let ((win (window-new)))
	(label-new-string win "Hello, world!")
	(window-show win)
	(custom-event-loop)))))
