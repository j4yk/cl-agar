(in-package agar)

(define-foreign-class (display ag-cffi::display) (object))

(define-slot-accessors display
  (ag-cffi::rnom nominal-refresh-rate rnom)
  (ag-cffi::rcur current-refresh-rate rcur)
  (ag-cffi::opengl opengl-p)
  (ag-cffi::windows windows))

(defcvar ("agView" *view*) (:pointer display) "Agar Device Context")
