#include <agar/core.h>
#include <agar/gui.h>

/* This file is for functions that shall surround calls to static
   inline C functions, because CFFI cannot bind to those */

void
Window_Update(AG_Window *win)
{
  AG_WindowUpdate(win);
}

void
Update_Widget(void *obj)
{
  AG_WidgetUpdate(obj);
}

void
Hide_Widget(void *wid)
{
  AG_WidgetHide(wid);
}

void
Show_Widget(void *wid)
{
  AG_WidgetShow(wid);
}

void
Expand(void *wid)
{
  AG_Expand(wid);
}

void
Expand_Horiz(void *wid)
{
  AG_ExpandHoriz(wid);
}
