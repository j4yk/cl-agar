(in-package agar)

(defcfun ("AG_ProcessTimeouts" process-timeouts) :void
  (ticks :uint32))

(defcvar ("agTimeoutObjQ" *timeout-object-queue*) tailqueue-head)

(defun timeouts-queued-p ()
  "AG_TIMEOUTS_QUEUED macro"
  (not (tailqueue-empty-p *timeout-object-queue*)))

(defcvar ("agIdleThresh" *idle-thresh*) :int)
