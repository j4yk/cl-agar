(in-package agar)

(defun get-error ()
  "const char* AG_GetError()"
  (let ((pmsg (foreign-funcall "AG_GetError" charpointer)))
    (when pmsg (foreign-string-to-lisp pmsg))))

(define-condition agar-error (error)
  ((error-message :initarg :message :initform (get-error)))
  (:report (lambda (condition stream)
	     (format stream "Error in agar: ~a" (slot-value condition 'error-message))))
  (:documentation "An error that occured when using Agar"))

(define-foreign-type agar-code-type ()
  ()
  (:actual-type :int)
  (:simple-parser agar-code))

(defmethod translate-from-foreign (value (type agar-code-type))
  (unless (= value 0)
    (error 'agar-error :message (get-error)))
  (values))

(defvar *initialized* nil "Set to t when init-core is called")

(defbitfield init-flags
  (:verbose #x1)
  :create-datadir
  :no-cfg-autoload)

;; HACK: callback schreiben, damit *initialized* ggf. auch wieder nil wird?
(defun init-core (progname flags)
  "int AG_InitCore(const char* progname, uint flags)
Initializes Agar if not done so previously"
  (if *initialized*
      (warn "Agar has been previously initialized!")
      (progn
	(foreign-funcall "AG_InitCore"
			 :string progname
			 init-flags flags
			 agar-code)
	(setq *initialized* t))))

;; (defun destroy ()
;;   "void AG_Destroy()
;; frees all of Agar's resources"
;;   (unwind-protect
;;        (foreign-funcall "AG_Destroy" :void)
;;     (setq *initialized* nil)))
;; commented out to avoid trouble when this was called

(defun process-event (sdl-event)
  "int AG_ProcessEvent(SDL_Event *ev)
Returns 1 if the event was processed somehow, -1 if the application exits."
  (foreign-funcall "AG_ProcessEvent" :pointer sdl-event :int))
