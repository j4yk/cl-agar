(in-package :agar-cffi)
(include "agar/core.h" "agar/gui.h")
#-windows (flag "-I/usr/local/include/agar")
(flag #+windows "-I\"%USERPROFILE%\\include\\sdl\"" #-windows "-I/usr/include/SDL")
(flag "-D_GNU_SOURCE=1")
(flag "-D_REENTRANT")
#-windows (flag "-I/usr/include/freetype2")
(flag #+windows "-I\"%USERPROFILE%\\include\"" #-windows "-I/usr/include")

(ctype :size "size_t")

(constant (+object-type-max+ "AG_OBJECT_TYPE_MAX"))

(cstruct sdl-event "SDL_Event")

(cstruct object "AG_Object")

(cstruct tailqueue-head "AG_TAILQ_HEAD(,ag_object)"
	 (tqh-first "tqh_first" :type :pointer)
	 (tqh-last "tqh_last" :type :pointer))

(cstruct tailqueue-entry "AG_TAILQ_ENTRY(ag_object)"
	 (tqe-next "tqe_next" :type :pointer)
	 (tqe-prev "tqe_prev" :type :pointer))

(cstruct object-class "AG_ObjectClass"
	 (name "name" :type :pointer)
	 (subclasses "subclasses" :type tailqueue-entry)
	 (sub "sub" :type tailqueue-head))

(cstruct rect2 "AG_Rect2")

(cstruct widget "AG_Widget"
	 (rview "rView" :type rect2))

(cstruct label "AG_Label")

(cstruct editable "AG_Editable")

(cstruct box "AG_Box")

(cstruct vbox "AG_VBox")

(cstruct hbox "AG_HBox")

(cstruct textbox "AG_Textbox")

(cstruct window "AG_Window"
	 (windows "windows" :type tailqueue-entry)
	 (visible "visible" :type :boolean))
	   
(cstruct display "AG_Display"
	 (w "w" :type :int)
	 (h "h" :type :int)
	 (depth "depth" :type :int)
	 (rcur "rCur" :type :int)
	 (rnom "rNom" :type :uint)
	 (opengl "opengl" :type :boolean)
	 (windows "windows" :type tailqueue-head))
	 
