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

(use-foreign-library jpeg)
(use-foreign-library freetype)
(use-foreign-library agar-core)
(use-foreign-library agar-gui)
