(in-package agar)

(defbitfield window-flags
  :modal :maximized :minimized :keepabove :keepbelow
  :denyfocus :notitle :noborders :nohresize :novresize
  :noclose :nominimize :nomaximize
  :cascade :minsizepct
  :nobackground :noupdaterect
  :focusonattach :hmaximize :vmazimize
  :nomove :noclipping
  :modkeyevents)

(defctype window :pointer "AG_Window Pointer")

(defcfun ("AG_WindowNew" window-new) window
  (flags window-flags))
