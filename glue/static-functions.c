#include <agar/core.h>
#include <agar/gui.h>

/* This file is for functions that shall surround calls to static
   inline C functions, because CFFI cannot bind to those */

int
Timeout_Is_Scheduled(void *obj, AG_Timeout *to)
{
  return (AG_TimeoutIsScheduled(obj, to));
}

void
Lock_Timeouts(void *p)
{
  AG_LockTimeouts(p);
}

void
Unlock_Timeouts(void *p)
{
  AG_UnlockTimeouts(p);
}

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

void
Expand_Vert(void *wid)
{
  AG_ExpandVert(wid);
}
