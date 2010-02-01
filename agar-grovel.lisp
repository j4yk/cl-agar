(in-package :agar-cffi)
(include "agar/core.h" "agar/gui.h")
(flag "-I/usr/local/include/agar")
(flag "-I/usr/include/SDL")
(flag "-D_GNU_SOURCE=1")
(flag "-D_REENTRANT")
(flag "-I/usr/include/freetype2")
(flag "-I/usr/include")

(ctype :size "size_t")

(constant (+object-type-max+ "AG_OBJECT_TYPE_MAX"))

(cstruct sdl-event "SDL_Event")

(cstruct tailq-head "AG_TAILQ_HEAD(,ag_object)"
	 (tqh-first "tqh_first" :type :pointer)
	 (tqh-last "tqh_last" :type :pointer))

(cstruct tailq-entry "AG_TAILQ_ENTRY(ag_object)"
	 (tqe-next "tqe_next" :type :pointer)
	 (tqe-prev "tqe_prev" :type :pointer))

(cstruct object-class "AG_ObjectClass"
	 (name "name" :type :pointer)
	 (subclasses "subclasses" :type tailq-entry)
	 (sub "sub" :type tailq-head))

(cstruct rect2 "AG_Rect2")
	   
(cstruct display "AG_Display"
	 (w "w" :type :int)
	 (h "h" :type :int)
	 (depth "depth" :type :int)
	 (rcur "rCur" :type :int)
	 (rnom "rNom" :type :uint)
	 (opengl "opengl" :type :boolean)
	 (windows "windows" :type tailq-head))

(cstruct widget "AG_Widget"
	 (rview "rView" :type rect2))

(cstruct window "AG_Window"
	 (windows "windows" :type tailq-entry)
	 (visible "visible" :type :boolean))
	 
