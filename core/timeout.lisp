(in-package agar)

(defcfun ("AG_ProcessTimeouts" process-timeouts) :void
  (ticks :uint32))
(setf (symbol-function 'process-timeout) #'process-timeouts)

(defagarvar ("agTimeoutObjQ" *agtimeoutobjq* :library agar-core) ag-cffi::tailqueue-head)
(define-symbol-macro *timeout-object-queue* (convert-from-foreign *agtimeoutobjq* '(tailqueue-head :type object)))
;; '(tailqueue-head :type object) needs the var to be a pointer...

(defun timeouts-queued-p ()
  (not (tailqueue-empty-p *timeout-object-queue*)))

(defagarvar ("agIdleThresh" *idle-thresh*) :int)