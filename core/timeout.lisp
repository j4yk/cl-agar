(in-package agar)

(defcfun ("AG_ProcessTimeouts" process-timeouts) :void
  (ticks :uint32))
(setf (symbol-function 'process-timeout) #'process-timeouts)

(defcvar ("agTimeoutObjQ" *timeout-object-queue*) (tailqueue-head :type object))

(defun timeouts-queued-p ()
  (not (tailqueue-empty-p *timeout-object-queue*)))
