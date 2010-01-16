(in-package :agar-cffi)
(include "agar/core.h" "agar/gui.h")
(flag "-I/usr/local/include/agar")
(flag "-I/usr/include/SDL")
(flag "-D_GNU_SOURCE=1")
(flag "-D_REENTRANT")
(flag "-I/usr/include/freetype2")
(flag "-I/usr/include")

(ctype :size "size_t")

(cstruct sdl-event "SDL_Event")

(cstruct tailq-head "AG_TAILQ_HEAD(,ag_object)"
	 (tqh-first "tqh_first" :type :pointer)
	 (tqh-last "tqh_last" :type :pointer))

(cstruct tailq-entry "AG_TAILQ_ENTRY(ag_object)"
	 (tqe-next "tqe_next" :type :pointer)
	 (tqe-prev "tqe_prev" :type :pointer))
	   
(cstruct display "AG_Display"
	 (windows "windows" :type tailq-head))
