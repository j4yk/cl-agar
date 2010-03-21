(in-package agar)

(define-foreign-class (display ag-cffi::display) (object))

(define-slot-accessors display
  (ag-cffi::rnom nominal-refresh-rate rnom)
  (ag-cffi::rcur current-refresh-rate rcur :writable)
  (ag-cffi::opengl opengl-p)
  (ag-cffi::lmodal lmodal)
  (ag-cffi::windows windows))

(defcvar ("agView" *view*) (:pointer display) "Agar VFS")
