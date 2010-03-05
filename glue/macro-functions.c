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
