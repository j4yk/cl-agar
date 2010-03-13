(in-package :agar-cffi)
(include "agar/core.h" "agar/gui.h")
#-windows (flag "-I/usr/local/include/agar")
(flag #+windows "-I\"%USERPROFILE%\\include\\sdl\"" #-windows "-I/usr/include/SDL")
(flag "-D_GNU_SOURCE=1")
(flag "-D_REENTRANT")
#-windows (flag "-I/usr/include/freetype2")
(flag #+windows "-I\"%USERPROFILE%\\include\"" #-windows "-I/usr/include")

(ctype size "size_t")

(constant (+object-type-max+ "AG_OBJECT_TYPE_MAX"))
(constant (+object-name-max+ "AG_OBJECT_NAME_MAX"))
(constant (+event-args-max+ "AG_EVENT_ARGS_MAX"))

(cstruct sdl-event "SDL_Event")

(cstruct object "AG_Object"
	 (name "name" :type :char :count "AG_OBJECT_NAME_MAX")
	 (lock "lock" :type :long))

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

(cenum variable-type
       ((:pointer "AG_VARIABLE_POINTER"))
       ((:string "AG_VARIABLE_STRING"))
       ((:int "AG_VARIABLE_INT")))

(cunion variable-data "union ag_variable_data"
	(p "p" :type :pointer)
	(s "s" :type :string)
	(i "i" :type :int)
	(u "u" :type :uint)
	(flt "flt" :type :float)
	(dbl "dbl" :type :double))

(cstruct variable "AG_Variable"
	 (type "type" :type variable-type)
	 (data "data" :type variable-data))

(cstruct event "AG_Event"
	 (argv "argv" :type variable :count "AG_EVENT_ARGS_MAX"))

(cstruct rect2 "AG_Rect2")

(cstruct widget "AG_Widget"
	 (x "x" :type :int)
	 (y "y" :type :int)
	 (flags "flags" :type :uint)
	 (rview "rView" :type rect2))

(cstruct label "AG_Label")

(cstruct editable "AG_Editable")

(cstruct box "AG_Box")

(cstruct vbox "AG_VBox")

(cstruct hbox "AG_HBox")

(cstruct button "AG_Button")

(cstruct textbox "AG_Textbox"
	 (ed "ed" :type :pointer))

(cstruct radio "AG_Radio"
	 (oversel "oversel" :type :int))

(cstruct tlist "AG_Tlist"
	 (nitems "nitems" :type :int)
	 (items "items" :type tailqueue-head))

(cstruct tlist-item "AG_TlistItem"
	 (ptr "p1" :type :pointer)
	 (p1 "p1" :type :pointer)
	 (selected "selected" :type :boolean)
	 (flags "flags" :type :uint))

(cstruct ucombo "AG_UCombo"
	 (list "list" :type :pointer)
	 (button "button" :type :pointer))

(cenum window-alignment
       ((:tl "AG_WINDOW_TL"))
       ((:tc "AG_WINDOW_TC"))
       ((:tr "AG_WINDOW_TR"))
       ((:ml "AG_WINDOW_ML"))
       ((:mc "AG_WINDOW_MC"))
       ((:mr "AG_WINDOW_MR"))
       ((:bl "AG_WINDOW_BL"))
       ((:bc "AG_WINDOW_BC"))
       ((:br "AG_WINDOW_BR")))

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
	 
