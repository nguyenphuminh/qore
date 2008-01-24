/*
  QoreList.h

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

#ifndef _QORE_LIST_H

#define _QORE_LIST_H

#include <qore/QoreNode.h>

class QoreList : public QoreNode
{   
      friend class StackList;

   private:
      // not implemented
      DLLLOCAL QoreList(const QoreList&);
      DLLLOCAL QoreList& operator=(const QoreList&);

   protected:
      struct qore_list_private *priv;

      DLLLOCAL void resize(int num);
      DLLLOCAL void splice_intern(int offset, int length, class ExceptionSink *xsink);
      DLLLOCAL void splice_intern(int offset, int length, class QoreNode *l, class ExceptionSink *xsink);
      DLLLOCAL void check_offset(int &offset);
      DLLLOCAL void check_offset(int &offset, int &len);
      DLLLOCAL void deref_intern(class ExceptionSink *xisnk);
      // qsort sorts the list in-place (unstable)
      DLLLOCAL int qsort(const class AbstractFunctionReference *fr, int left, int right, bool ascending, class ExceptionSink *xsink);
      // mergesort sorts the list in-place (stable)
      DLLLOCAL int mergesort(const class AbstractFunctionReference *fr, bool ascending, class ExceptionSink *xsink);
      DLLEXPORT virtual ~QoreList();

   public:
      DLLEXPORT QoreList();

      // FIXME: move QoreString * to first argument
      // get string representation (for %n and %N), foff is for multi-line formatting offset, -1 = no line breaks
      // if del is true, then the returned QoreString * should be deleted, if false, then it must not be
      // the ExceptionSink is only needed for QoreObject where a method may be executed
      // use the QoreNodeAsStringHelper class (defined in QoreStringNode.h) instead of using this function directly
      DLLEXPORT virtual QoreString *getAsString(bool &del, int foff, class ExceptionSink *xsink) const;

      // default implementation returns false
      DLLEXPORT virtual bool needs_eval() const;
      DLLEXPORT virtual class QoreNode *realCopy() const;

      // performs a lexical compare, return -1, 0, or 1 if the "this" value is less than, equal, or greater than
      // the "val" passed
      //DLLLOCAL virtual int compare(const QoreNode *val) const;
      // the type passed must always be equal to the current type
      DLLEXPORT virtual bool is_equal_soft(const QoreNode *v, ExceptionSink *xsink) const;
      DLLEXPORT virtual bool is_equal_hard(const QoreNode *v, ExceptionSink *xsink) const;

      // returns the data type
      DLLEXPORT virtual const QoreType *getType() const;
      // returns the type name as a c string
      DLLEXPORT virtual const char *getTypeName() const;
      // eval(): return value requires a deref(xsink)
      // default implementation = returns "this" with incremented atomic reference count
      DLLEXPORT virtual class QoreNode *eval(class ExceptionSink *xsink) const;
      // eval(): return value requires a deref(xsink) if needs_deref is true
      // default implementation = needs_deref = false, returns "this"
      // note: do not use this function directly, use the QoreNodeEvalOptionalRefHolder class instead
      DLLEXPORT virtual class QoreNode *eval(bool &needs_deref, class ExceptionSink *xsink) const;
      // deletes the object when the reference count = 0
      DLLEXPORT virtual void deref(class ExceptionSink *xsink);
      // returns true if the node represents a value (default implementation)
      DLLEXPORT virtual bool is_value() const;

      DLLEXPORT class QoreNode *retrieve_entry(int index) const;
      DLLEXPORT int getEntryAsInt(int index) const;
      DLLEXPORT class QoreNode **get_entry_ptr(int index);
      DLLEXPORT class QoreNode **getExistingEntryPtr(int index);
      DLLEXPORT void set_entry(int index, class QoreNode *val, class ExceptionSink *xsink);
      DLLEXPORT class QoreNode *eval_entry(int num, class ExceptionSink *xsink) const;
      DLLEXPORT void push(class QoreNode *val);
      DLLEXPORT void insert(class QoreNode *val);
      DLLEXPORT class QoreNode *pop();
      DLLEXPORT class QoreNode *shift();
      DLLEXPORT void merge(const class QoreList *list);
      DLLEXPORT int delete_entry(int index, class ExceptionSink *xsink);
      DLLEXPORT void pop_entry(int index, class ExceptionSink *xsink);
      DLLEXPORT QoreList *evalList(class ExceptionSink *xsink) const;
      DLLEXPORT QoreList *evalList(bool &needs_deref, class ExceptionSink *xsink) const;
      DLLEXPORT QoreList *evalFrom(int offset, class ExceptionSink *xsink) const;
      DLLEXPORT QoreList *copy() const;
      DLLEXPORT QoreList *copyListFrom(int offset) const;
      DLLEXPORT QoreList *sort() const;
      DLLEXPORT QoreList *sort(const class AbstractFunctionReference *fr, class ExceptionSink *xsink) const;
      DLLEXPORT QoreList *sortStable() const;
      DLLEXPORT QoreList *sortStable(const class AbstractFunctionReference *fr, class ExceptionSink *xsink) const;
      DLLEXPORT QoreList *sortDescending() const;
      DLLEXPORT QoreList *sortDescending(const class AbstractFunctionReference *fr, class ExceptionSink *xsink) const;
      DLLEXPORT QoreList *sortDescendingStable() const;
      DLLEXPORT QoreList *sortDescendingStable(const class AbstractFunctionReference *fr, class ExceptionSink *xsink) const;
      DLLEXPORT class QoreNode *min() const;
      DLLEXPORT class QoreNode *max() const;
      DLLEXPORT class QoreNode *min(const class AbstractFunctionReference *fr, class ExceptionSink *xsink) const;
      DLLEXPORT class QoreNode *max(const class AbstractFunctionReference *fr, class ExceptionSink *xsink) const;
      DLLEXPORT void splice(int offset, class ExceptionSink *xsink);
      DLLEXPORT void splice(int offset, int length, class ExceptionSink *xsink);
      // the "l" QoreNode will be referenced for the assignment in the QoreList
      DLLEXPORT void splice(int offset, int length, class QoreNode *l, class ExceptionSink *xsink);
      DLLEXPORT int size() const;
      DLLEXPORT QoreList *reverse() const;

      // needed only while parsing
      DLLLOCAL QoreList(bool i);
      DLLLOCAL bool isFinalized() const;
      DLLLOCAL void setFinalized();
      DLLLOCAL bool isVariableList() const;
      DLLLOCAL void setVariableList();
      DLLLOCAL void clearNeedsEval();
};

class StackList : public QoreList
{
   private:
      class ExceptionSink *xsink;
      
      // none of these operators/methods are implemented - here to make sure they are not used
      DLLLOCAL void *operator new(size_t); 
      DLLLOCAL StackList();
      DLLLOCAL StackList(bool i);
      DLLLOCAL StackList(const StackList&);
      DLLLOCAL StackList& operator=(const StackList&);
   
   public:
      DLLEXPORT StackList(class ExceptionSink *xs)
      {
	 xsink = xs;
      }
      DLLEXPORT ~StackList()
      {
	 deref_intern(xsink);
      }
      DLLEXPORT class QoreNode *getAndClear(int i);
};

class TempList {
   private:
      QoreList *l;
      class ExceptionSink *xsink;

      // not implemented
      DLLLOCAL void *operator new(size_t); 
      DLLLOCAL TempList(const TempList&);
      DLLLOCAL TempList& operator=(const TempList&);

   public:
      DLLEXPORT TempList(QoreList *lst, class ExceptionSink *xs) : l(lst), xsink(xs)
      {
      }
      DLLEXPORT ~TempList()
      {
	 if (l)
	    l->deref(xsink);
      }
      DLLEXPORT QoreList *operator->(){ return l; };
      DLLEXPORT QoreList *operator*() { return l; };
      DLLEXPORT operator bool() const { return l != 0; }
      DLLLOCAL QoreList *release() { QoreList *rv = l; l = 0; return rv; }
};

class ListIterator
{
   private:
      QoreList* l;
      int pos;
   
   public:
      DLLEXPORT ListIterator(QoreList *lst);
      DLLEXPORT bool next();
      DLLEXPORT class QoreNode *getValue() const;
      DLLEXPORT class QoreNode **getValuePtr() const;
      DLLEXPORT class QoreNode *eval(class ExceptionSink *xsink) const;
      DLLEXPORT bool first() const;
      DLLEXPORT bool last() const;
      //DLLEXPORT void setValue(class QoreNode *val, class ExceptionSink *xsink) const;
};

class ConstListIterator
{
   private:
      const QoreList* l;
      int pos;
   
   public:
      DLLEXPORT ConstListIterator(const QoreList *lst);
      DLLEXPORT bool next();
      DLLEXPORT class QoreNode *getValue() const;
      DLLEXPORT class QoreNode *eval(class ExceptionSink *xsink) const;
      DLLEXPORT bool first() const;
      DLLEXPORT bool last() const;
};

class QoreListEvalOptionalRefHolder {
   private:
      QoreList *val;
      ExceptionSink *xsink;
      bool needs_deref;

      DLLLOCAL void discard_intern()
      {
	 if (needs_deref && val)
	    val->deref(xsink);
      }

      // not implemented
      DLLLOCAL QoreListEvalOptionalRefHolder(const QoreListEvalOptionalRefHolder&);
      DLLLOCAL QoreListEvalOptionalRefHolder& operator=(const QoreListEvalOptionalRefHolder&);
      DLLLOCAL void *operator new(size_t);

   public:
      DLLLOCAL QoreListEvalOptionalRefHolder(ExceptionSink *n_xsink) : xsink(n_xsink)
      {
	 needs_deref = false;
	 val = 0;
      }
      DLLLOCAL QoreListEvalOptionalRefHolder(const QoreList *exp, ExceptionSink *n_xsink) : xsink(n_xsink)
      {
	 needs_deref = false;
	 val = exp ? exp->evalList(needs_deref, xsink) : 0;
      }
      DLLLOCAL ~QoreListEvalOptionalRefHolder()
      {
	 discard_intern();
      }
      DLLLOCAL void discard()
      {
	 discard_intern();
	 needs_deref = false;
	 val = 0;
      }
      DLLLOCAL void assign(bool n_needs_deref, QoreList *n_val)
      {
	 discard_intern();
	 needs_deref = n_needs_deref;
	 val = n_val;
      }
      // returns a referenced value - the caller will own the reference
      DLLLOCAL QoreList *getReferencedValue()
      {
	 if (needs_deref)
	    needs_deref = false;
	 else if (val)
	    val->ref();
	 return val;
      }
      // takes the referenced value and leaves this object empty, value is referenced if necessary
      DLLLOCAL QoreList *takeReferencedValue()
      {
	 QoreList *rv = val;
	 if (val && !needs_deref)
	    rv->ref();
	 val = 0;
	 needs_deref = false;
	 return rv;
      }
      DLLLOCAL QoreList *operator->() { return val; }
      DLLLOCAL QoreList *operator*() { return val; }
      DLLLOCAL operator bool() const { return val != 0; }
};

#endif
