(in-package agar)

(defbitfield window-flags
  )

(defctype window :pointer "AG_Window Pointer")

(defcfun ("AG_WindowNew" window-new) window
  (flags window-flags))
