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
  (:documentation "Ein bei Benutzung von Agar aufgetretener Fehler"))

(defvar *initialized* nil "Gibt an, ob init-core schon aufgerufen wurde")

(defbitfield init-flags
  (:verbose #x1)
  :create-datadir
  :no-cfg-autoload)

;; HACK: callback schreiben, damit *initialized* ggf. auch wieder nil wird
(defun init-core (progname flags)
  "int AG_InitCore(const char* progname, uint flags)
Initislisiert Agar, wenn dies nicht schon vorher getan wurde"
  (unless *initialized* 
    ;; progname wird von AG_InitCore kopiert, daher muss der nicht aufbewahrt werden
    (agar-funcall "AG_InitCore" :string progname init-flags flags))
    (setq *initialized* t))

(defcfun ("AG_Destroy" destroy) :void)

(defun process-event (sdl-event)
  "int AG_ProcessEvent(SDL_Event *ev)
Gibt 1 zurück, wenn das Ereignis irgendwie verarbeitet wurde,
-1, wenn die Anwendung beendet wird."
  (foreign-funcall "AG_ProcessEvent" :pointer sdl-event :int))

(defun tailq-to-list (tailq-head field)
  (do* ((var (foreign-slot-value tailq-head 'agar-cffi:tailq-head 'agar-cffi:tqh-first)
	     (foreign-slot-value (foreign-slot-value var 'agar-cffi:tailq-entry field) 'agar-cffi:tailq-entry 'agar-cffi:tqe-next))
	(list (list var) (push var list)))
       ((not (null-pointer-p var)) (nreverse list))))
