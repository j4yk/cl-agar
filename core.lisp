(in-pacakge agar)

(defctype charpointer :pointer "char*")
(defctype agar-code :int)		; Fehlerstatus

(defun get-error ()
  "const char* AG_GetError()"
  (let ((pmsg (foreign-funcall "AG_GetError" charpointer)))
    (when pmsg (foreign-string-to-lisp pmsg))))

(define-condition agar-error (error)
  ((error-message :initarg :message :initform (get-error)))
  (:report (lambda (condition stream)
	     (format stream "Error in agar: ~a" (slot-value condition 'error-message))))
  (:documentation "An error that occured when using Agar"))

(defvar *initialized* nil "Set to t when init-core is called")

(defbitfield init-flags
  (:verbose #x1)
  :create-datadir
  :no-cfg-autoload)

;; HACK: callback schreiben, damit *initialized* ggf. auch wieder nil wird
(defun init-core (progname flags)
  "int AG_InitCore(const char* progname, uint flags)
Initializes Agar if not done so previously"
  (unless *initialized* 
    ;; progname wird von AG_InitCore kopiert, daher muss der nicht aufbewahrt werden
    (agar-funcall "AG_InitCore" :string progname init-flags flags))
    (setq *initialized* t))

(defcfun ("AG_Destroy" destroy) :void)

(defun process-event (sdl-event)
  "int AG_ProcessEvent(SDL_Event *ev)
Returns 1 if the event was processed somehow, -1 if the application exits."
  (foreign-funcall "AG_ProcessEvent" :pointer sdl-event :int))

(defun tailq-to-list (tailq-head field)
  (do* ((var (foreign-slot-value tailq-head 'agar-cffi:tailq-head 'agar-cffi:tqh-first)
	     (foreign-slot-value (foreign-slot-value var 'agar-cffi:tailq-entry field) 'agar-cffi:tailq-entry 'agar-cffi:tqe-next))
	(list (list var) (push var list)))
       ((not (null-pointer-p var)) (nreverse list))))
