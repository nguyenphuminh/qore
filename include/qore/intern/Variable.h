/*
  Variable.h

  Qore Programming Language

  Copyright (C) 2003, 2004, 2005, 2006, 2007 David Nichols

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#ifndef _QORE_VARIABLE_H

#define _QORE_VARIABLE_H

#define VT_UNRESOLVED 1
#define VT_LOCAL      2
#define VT_GLOBAL     3
#define VT_OBJECT     4  // used for references only

#define GV_VALUE  1
#define GV_IMPORT 2

#include <qore/intern/VRMutex.h>

#include <string.h>
#include <stdlib.h>

#include <string>

#ifndef QORE_THREAD_STACK_BLOCK
#define QORE_THREAD_STACK_BLOCK 128
#endif

// structure for local variables
class LVar {
   private:
      AbstractQoreNode *value;
      AbstractQoreNode *vexp;  // partially evaluated lvalue expression for references
      QoreObject *obj;     // for references to object members
      mutable lvh_t id;

      DLLLOCAL AbstractQoreNode *evalReference(class ExceptionSink *xsink);

   public:

      DLLLOCAL void set(lvh_t nid, class AbstractQoreNode *nvalue);
      DLLLOCAL void set(lvh_t nid, class AbstractQoreNode *ve, class QoreObject *o);
      
      DLLLOCAL AbstractQoreNode **getValuePtr(class AutoVLock *vl, class ExceptionSink *xsink) const;
      DLLLOCAL AbstractQoreNode *getValue(class AutoVLock *vl, class ExceptionSink *xsink);
      DLLLOCAL void setValue(class AbstractQoreNode *val, class ExceptionSink *xsink);
      DLLLOCAL AbstractQoreNode *eval(class ExceptionSink *xsink);
      DLLLOCAL AbstractQoreNode *eval(bool &needs_deref, class ExceptionSink *xsink);
      DLLLOCAL bool checkRecursiveReference(lvh_t nid);
      DLLLOCAL void deref(class ExceptionSink *xsink);
      DLLLOCAL lvh_t get_id() const
      {
	 return id;
      }
};

union VarValue {
      // for value
      struct {
	    AbstractQoreNode *value;
	    char *name;
      } val;
      // for imported variables
      struct {
	    class Var *refptr;
	    bool readonly;
      } ivar;
};

// structure for global variables
class Var : public ReferenceObject
{
   private:
      int type;
      // holds the value of the variable or a pointer to the imported variable
      union VarValue v;
      mutable class VRMutex gate;

      DLLLOCAL void del(class ExceptionSink *xsink);

   protected:
      DLLLOCAL ~Var() {}

   public:
      DLLLOCAL Var(const char *nme, class AbstractQoreNode *val = NULL);
      DLLLOCAL Var(class Var *ref, bool ro = false);
      DLLLOCAL const char *getName() const;
      DLLLOCAL void setValue(class AbstractQoreNode *val, class ExceptionSink *xsink);
      DLLLOCAL void makeReference(class Var *v, class ExceptionSink *xsink, bool ro = false);
      DLLLOCAL bool isImported() const;
      DLLLOCAL void deref(class ExceptionSink *xsink);
      DLLLOCAL class AbstractQoreNode *eval(class ExceptionSink *xsink);
      DLLLOCAL class AbstractQoreNode **getValuePtr(class AutoVLock *vl, class ExceptionSink *xsink) const;
      DLLLOCAL class AbstractQoreNode *getValue(class AutoVLock *vl, class ExceptionSink *xsink);
};

DLLLOCAL class AbstractQoreNode *getNoEvalVarValue(class AbstractQoreNode *n, class AutoVLock *vl, class ExceptionSink *xsink);
DLLLOCAL class AbstractQoreNode *getExistingVarValue(const AbstractQoreNode *n, class ExceptionSink *xsink, class AutoVLock *vl, class AbstractQoreNode **pt);
DLLLOCAL void delete_var_node(class AbstractQoreNode *node, class ExceptionSink *xsink);
DLLLOCAL void delete_global_variables();
DLLLOCAL class LVar *instantiateLVar(lvh_t id, class AbstractQoreNode *value);
DLLLOCAL class LVar *instantiateLVar(lvh_t id, class AbstractQoreNode *ve, class QoreObject *o);
DLLLOCAL void uninstantiateLVar(class ExceptionSink *xsink);
DLLLOCAL class LVar *find_lvar(lvh_t id);

DLLLOCAL extern class QoreHashNode *ENV;

#endif // _QORE_VARIABLE_H
