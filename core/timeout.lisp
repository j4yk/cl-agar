(in-package agar)

(defmacro define-bitfield-from-enum (name base)
  `(defbitfield ,name
     ,@(loop for keyword in (foreign-enum-keyword-list base)
	  collect `(,keyword ,(convert-to-foreign keyword base)))))

(define-bitfield-from-enum timeout-flags ag-cffi::timeout-flags)

(define-foreign-class (timeout ag-cffi::timeout) ()
  ())

(defcfun ("AG_SetTimeout" set-timeout) :void
  "Initializes a pre-allocted AG_Timeout struture
using the specified callback function and argument"
  (timeout timeout) (fn :pointer) (arg :pointer) (flags timeout-flags))

(defcfun ("AG_ScheduleTimeout" schedule-timeout) :void
  "Schedules (or reschedules) the previously configured callback
function for execution in t+ival ticks.  The obj argument specifies
the AG_Object which is responsible for the scheduling and execution of
the given callback function.

Different types of objects may implement different timing schemes
involving either real-time or simulated real-time.  If the obj
argument is NULL, the callback is associated with a global \"timer
manager\" object which uses the default timing algorithm.

With the default (real-time) timing algorithm, a \"tick\" is
considered equivalent to roughly 1 millisecond.  Different timing
schemes can assign different meanings to a \"tick\".  The AG_Timeout
interface remains consistent across different timing schemes."
  (obj :pointer) (timeout timeout) (ival :uint32))

(defcfun ("AG_DelTimeout" delete-timeout) :void
  "Removes the given timeout from the queue if it is currently
  scheduled for execution.  It is not necessary to invoke
  AG_DelTimeout before AG_SchedTimeout when re-scheduling an event."
  (obj :pointer) (timeout timeout))

(defcfun "Timeout_Is_Scheduled" :boolean
  "Returns t if the given timeout is currently scheduled for execution.
The timeouts must have been locked by the caller of the function"
  (obj :pointer) (timeout timeout))

(defcfun "Lock_Timeouts" :void
  "Locks the timeouts associated with obj"
  (obj :pointer))

(defcfun "Unlock_Timeouts" :void
  "Unlocks the timeouts associated with obj"
  (obj :pointer))

(defmacro with-locked-timeouts (obj &body body)
  `(progn
     (lock-timeouts ,obj)
     (unwind-protect (progn ,@body)
       (unlock-timeouts ,obj))))

(defmacro define-timeout-callback (name-and-options (object ival arg) &body body)
  `(defcallback ,name-and-options :uint32
       ((,object :pointer) (,ival :uint32) (,arg :pointer))
     ,@body))

(defcfun ("AG_ProcessTimeouts" process-timeouts) :void
  (ticks :uint32))

(defcvar ("agTimeoutObjQ" *timeout-object-queue*) tailqueue-head)

(defun timeouts-queued-p ()
  "AG_TIMEOUTS_QUEUED macro"
  (not (tailqueue-empty-p *timeout-object-queue*)))

(defcvar ("agIdleThresh" *idle-thresh*) :int)
