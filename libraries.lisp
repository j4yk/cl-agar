(in-package agar)

(define-foreign-library agar-core
  (:unix "libag_core.so")
  (:windows "ag_core.dll"))

(define-foreign-library agar-gui
  (:unix "libag_gui.so")
  (:windows "ag_gui.dll"))

(define-foreign-library freetype
  (:unix "libfreetype.so")
  (:windows "freetype.dll"))

(define-foreign-library jpeg
  (:unix "libjpeg.so"))

(define-foreign-library agar-glue
  (:unix "libclagar-glue.so"))

(use-foreign-library jpeg)
(use-foreign-library freetype)
(use-foreign-library agar-core)
(use-foreign-library agar-gui)
(push (merge-pathnames "") cffi:*foreign-library-directories*)
(push (pathname "/usr/local/lib/") cffi:*foreign-library-directories*)
(use-foreign-library agar-glue)
