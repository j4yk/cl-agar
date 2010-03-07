(in-package agar)

(defcenum text-msg-title
  (:error)
  (:warning)
  (:info))

(defun text-msg (title format-string &rest format-args)
  "void AG_TextMsg(enum ag_text_msg_title title, const char *format, ...)"
  (let ((message (apply #'format nil format-string format-args)))
    (foreign-funcall "AG_TextMsg"
		     text-msg-title title
		     :string message :void)))

(defun prompt-options (text &rest options)
  "Binding to AG_TextPromptOptions
options ::= option | option options
option ::= (option-text callback)
option-text ::= button text
callback ::= button callback

Callbacks will receive the created window as AG_PTR(1)"
  (with-foreign-object (button-ptr-array :pointer (length options))
    ;; make the prompt dialog
    (let ((window (foreign-funcall "AG_TextPromptOptions"
				   :pointer button-ptr-array
				   :int (length options)
				   :string text
				   window)))
      (restart-case
	  (prog1 window
	    ;; label and link the buttons
	    (do ((n 0 (1+ n))
		 (ptr button-ptr-array (incf-pointer ptr (foreign-type-size :pointer)))
		 (options options (cdr options)))
		((null options))
	      (destructuring-bind (caption callback) (car options)
		(let ((button-ptr (mem-aref ptr :pointer)))
		  (button-text button-ptr caption)
		  (set-button-pushed-event button-ptr callback "%p" :pointer window)))))
	(hide-and-detach-window () :report "Hide the window created by AG_TextPromptOptions and detach it"
				(hide-window window)
				(detach-object window)
				(null-pointer))))))
