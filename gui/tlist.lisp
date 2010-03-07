(in-package agar)

(define-foreign-class (tlist ag-cffi::tlist) (widget))

(define-slot-accessors tlist
  (ag-cffi::items tlist-items)
  (ag-cffi::nitems tlist-n-items tlist-items-count))

(define-foreign-class (tlist-item ag-cffi::tlist-item) ())

(define-slot-accessors tlist-item
  (ag-cffi::ptr tlist-item-ptr :writable)
  (ag-cffi::selected tlist-item-selected-p)
  (ag-cffi::flags tlist-item-flags))

(defcfun "Tlist_Begin" :void
  (tlist tlist))

(defcfun "Tlist_End" :void
  (tlist tlist))

(defcfun ("AG_TlistAdd" tlist-add) tlist-item
  (tlist tlist) (iconsrc :pointer) (format :string) &rest)

(defcfun ("AG_TlistAddPtr" tlist-add-ptr) tlist-item
  (tlist tlist) (iconsrc :pointer) (text :string) (ptr :pointer))

(defcfun ("AG_TlistSelect" tlist-select) :void
  (tlist tlist) (tlist-item tlist-item))

(defcfun ("AG_TlistSelectPtr" tlist-select-ptr) :void
  (tlist tlist) (ptr :pointer))
