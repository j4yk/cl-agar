#include <agar/core.h>
#include <agar/gui.h>

/* This file is for Agar Macros that should better be expanded by the precompiler */

AG_Object *
Parent_Object(AG_Object *obj)
{
  return(AG_ObjectParent(obj));
}

void
Lock_Object(AG_Object *obj)
{
  AG_ObjectLock(obj);
}

void
Unlock_Object(AG_Object *obj)
{
  AG_ObjectLock(obj);
}

Uint32
Get_Ticks(void)
{
  return AG_GetTicks();
}

void
Tlist_Begin(AG_Tlist *tlist)
{
  AG_TlistBegin(tlist);
}

void
Tlist_End(AG_Tlist *tlist)
{
  AG_TlistEnd(tlist);
}

void
Set_Window_Geometry(AG_Window *win, int x, int y, int w, int h)
{
  AG_WindowSetGeometry(win, x, y, w, h);
}
