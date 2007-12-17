/*
  QoreNode.cc

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

#include <qore/Qore.h>
#include <qore/intern/Find.h>

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#define TRACK_REFS 1

QoreNodeCStringHelper::QoreNodeCStringHelper(const QoreNode *n, class QoreEncoding *enc, class ExceptionSink *xsink) : temp(false)
{
   if (is_nothing(n) || is_null(n))
   {
      node = NULL;
      return;
   }
   if (n->type == NT_STRING)
   {
      if (n->val.String->getEncoding() == enc)
      {
	 node = const_cast<QoreNode *>(n);
	 return;
      }
      class QoreString *str = n->val.String->convertEncoding(enc, xsink);
      if (!str)
      {
	 node = 0;
	 return;
      }
      node = new QoreNode(str);
      temp = true;
      return;
   }
   // if an exception occurs, node is NULL and temp is true                                                                                                                                
   // NOTE: converting to a string means that the string will be effectively in ASCII encoding even though it will be marked with the default encoding                                     
   // because only ASCII characters are generated when converted to a string (boolean, numbers, dates)                                                                                     
   // since ASCII is the lowest common denominator for all encodings supported by Qore, this works regardless of the target encoding specified                                             
   node = n->convert(NT_STRING, xsink);
   temp = true;
}

const char *QoreNodeCStringHelper::operator*()
{
   if (!node)
      return "";
   return node->val.String->getBuffer();
}

int QoreNodeCStringHelper::strlen() const
{
   return node ? node->val.String->strlen() : 0;
}

QoreNodeTypeHelper::QoreNodeTypeHelper(QoreNode *n, const QoreType *t, class ExceptionSink *xsink) : temp(false)
{
   if (!n)
   {
      node = t->getDefaultValue();
      temp = true;
   }
   else if (n->type != t)
   {
      node = n->convert(t, xsink);
      temp = true;
   }
   else
      node = n;
}

QoreNode::QoreNode() 
{
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=unknown (0->1)\n", this);
#endif
}

#if TRACK_REFS

#endif

QoreNode::QoreNode(class QoreType *t) 
{
   type = t; 
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(int64 v) 
{ 
   type = NT_INT;
   val.intval = v; 
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1) value=%lld\n", this, type->getName(), v);
#endif
}

QoreNode::QoreNode(long v) 
{ 
   type = NT_INT;
   val.intval = (int64)v; 
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1) value=%lld\n", this, type->getName(), val.intval);
#endif
}

QoreNode::QoreNode(class QoreType *t, int64 v) 
{ 
   type = t;
   val.intval = v; 
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1) value=%lld\n", this, type->getName(), val.intval);
#endif
}

QoreNode::QoreNode(bool v)
{
   type = NT_BOOLEAN;
   val.boolval = v;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class QoreHash *h)
{
   type = NT_HASH;
   val.hash = h;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(QoreObject *o)
{
   type = NT_OBJECT;
   val.object = o;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1) object=%08p, class=%s\n", this, type->getName(), o, o->getClass()->getName());
#endif
}

QoreNode::QoreNode(QoreList *l)
{
   type = NT_LIST;
   val.list = l;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(double f)
{
   type = NT_FLOAT;
   val.floatval = f;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class BinaryObject *b)
{
   type = NT_BINARY;
   val.bin = b;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(DateTime *dt)
{
   type = NT_DATE;
   val.date_time = dt;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class QoreString *str)
{
   type = NT_STRING;
   val.String = str;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1) '%s'\n", this, type->getName(), str->getBuffer());
#endif
}

/*
QoreNode::QoreNode(char *str)
{
   //fprintf(stderr,"QoreNode::QoreNode(char *= %s)\n", str);
   type = NT_STRING;
   val.String = new QoreString(str);
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1) '%s'\n", this, type->getName(), str);
#endif
}
*/

QoreNode::QoreNode(const char *str)
{
   //fprintf(stderr,"QoreNode::QoreNode(char *= %s)\n", str);
   type = NT_STRING;
   val.String = new QoreString(str);
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1) '%s'\n", this, type->getName(), str);
#endif
}

QoreNode::QoreNode(const std::string &str)
{
   //fprintf(stderr,"QoreNode::QoreNode(char *= %s)\n", str);
   type = NT_STRING;
   val.String = new QoreString(str);
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::~QoreNode()
{
#if 0
   printd(5, "QoreNode::~QoreNode() type=%s\n", type->getName());
#endif
   type->deleteContents(this);
}

QoreNode::QoreNode(char *name, class QoreNode *a)
{
   type = NT_FUNCTION_CALL;
   val.fcall = new FunctionCall(name, a);
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

// for non-scoped in-object calls
QoreNode::QoreNode(class QoreNode *a, char *name)
{
   type = NT_FUNCTION_CALL;
   val.fcall = new FunctionCall(a, name);
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

// for in-object base class calls
QoreNode::QoreNode(class QoreNode *a, class NamedScope *n)
{
   type = NT_FUNCTION_CALL;
   val.fcall = new FunctionCall(a, n);
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class UserFunction *u, class QoreNode *a)
{
   type = NT_FUNCTION_CALL;
   val.fcall = new FunctionCall(u, a);
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class BuiltinFunction *b, class QoreNode *a)
{
   type = NT_FUNCTION_CALL;
   val.fcall = new FunctionCall(b, a);
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class NamedScope *n, class QoreNode *a)
{
   type = NT_SCOPE_REF;
   val.socall = new ScopedObjectCall(n, a);
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class NamedScope *n)
{
   type = NT_CONSTANT;
   val.scoped_ref = n;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class ClassRef *c)
{
   type = NT_CLASSREF;
   val.classref = c;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class VarRef *v)
{
   type = NT_VARREF;
   val.vref = v;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class QoreNode *l, class Operator *o, class QoreNode *r)
{
   type = NT_TREE;
   val.tree = new Tree(l, o, r);
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class RegexSubst *rs)
{
   type = NT_REGEX_SUBST;
   val.resub = rs;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class RegexTrans *rt)
{
   type = NT_REGEX_TRANS;
   val.retrans = rt;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class QoreRegex *r)
{
   type = NT_REGEX;
   val.regex = r;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class Tree *t)
{
   type = NT_TREE;
   val.tree = t;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class ComplexContextRef *ccref)
{
   type = NT_COMPLEXCONTEXTREF;
   val.complex_cref = ccref;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class FunctionReferenceCall *frc)
{
   type = NT_FUNCREFCALL;
   val.funcrefcall = frc;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class AbstractFunctionReference *afr)
{
   type = NT_FUNCREF;
   val.funcref = afr;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class AbstractParseObjectMethodReference *objmethref)
{
   type = NT_OBJMETHREF;
   val.objmethref = objmethref;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

QoreNode::QoreNode(class FunctionCall *fc)
{
   type = NT_FUNCTION_CALL;
   val.fcall = fc;
#if TRACK_REFS
   printd(5, "QoreNode::ref() %08p type=%s (0->1)\n", this, type->getName());
#endif
}

class QoreNode *QoreNode::convert(const QoreType *new_type) const
{
   if (type == new_type)
      return RefSelf();
   
   return new_type->convertTo(this, NULL);
}

class QoreNode *QoreNode::convert(const QoreType *new_type, class ExceptionSink *xsink) const
{
   if (type == new_type)
      return RefSelf();
   
   return new_type->convertTo(this, xsink);
}

void QoreNode::ref() const
{
#ifdef DEBUG
#if TRACK_REFS
   if (type == NT_OBJECT)
      printd(5, "QoreNode::ref() %08p type=%s (%d->%d) object=%08p, class=%s\n", this, type->getName(), references, references + 1, val.object, val.object->getClass()->getName());
   else
      printd(5, "QoreNode::ref() %08p type=%s (%d->%d)\n", this, type->getName(), references, references + 1);
#endif
#endif
   ROreference();
}

class QoreNode *QoreNode::RefSelf() const
{
   ref();
   return const_cast<QoreNode *>(this);
}

static class QoreString *dni(class QoreString *s, class QoreNode *n, int indent, class ExceptionSink *xsink);

void QoreNode::deref(ExceptionSink *xsink)
{
   //tracein("QoreNode::deref()");
#ifdef DEBUG
#if TRACK_REFS
   if (type == NT_STRING) printd(5, "QoreNode::deref() %08p (%d->%d) string='%s'\n", this, references, references - 1, val.String ? val.String->getBuffer() : "(null)");
   else if (type == NT_OBJECT) printd(5, "QoreNode::deref() %08p (%d->%d) object=%08p class=%s\n", this, references, references - 1, val.object, val.object->getClass()->getName());
   else
      printd(5, "QoreNode::deref() %08p type=%s (%d->%d)\n", this, type->getName(), references, references - 1);

/*
   else if (type == NT_HASH && references <= 51200 && references > 0) { 
      QoreString tmp; 
      dni(&tmp, this, 0, xsink);
      printd(5, "QoreNode::deref() %08p hash=%s\n", this, tmp.getBuffer());
   }
*/

#endif
   if (references > 51200 || references < 0)
   {
      if (type == NT_INT)
	 printd(0, "QoreNode::deref() WARNING, node %08p references=%d (type=%s) (val=%d)\n",
		this, references, type->getName(), val.intval);
      else if (type == NT_STRING)
	 printd(0, "QoreNode::deref() WARNING, node %08p references=%d (type=%s) (val=\"%s\")\n",
		this, references, type->getName(), val.String->getBuffer());
      else
	 printd(0, "QoreNode::deref() WARNING, node %08p references=%d (type=%s)\n",
		this, references, type->getName());
      assert(false);
   }
#endif
   assert(references > 0);

   if (ROdereference())
   {
      if (type == NT_LIST)
	 val.list->dereference(xsink);
      else if (type == NT_HASH)
	 val.hash->dereference(xsink);
      else if (type == NT_OBJECT)
	 val.object->dereference(xsink);
      else if (type == NT_FUNCREF)
	 val.funcref->del(xsink);
	 
      // now delete this QoreNode
      delete this;
   }

   //traceout("QoreNode::deref()");
}

class QoreNode *QoreNode::realCopy(ExceptionSink *xsink) const
{
   //tracein("QoreNode::realCopy()");
   assert(this);

   //traceout("QoreNode::realCopy()");
   return type->copy(this, xsink);
}

bool QoreNode::needs_eval() const
{
   return type->needs_eval(this);
}

/*
  QoreNode::eval(): return value requires a dereference
 */
class QoreNode *QoreNode::eval(ExceptionSink *xsink) const
{
   return type->eval(this, xsink);
}

/*
 QoreNode::eval(): return value requires a dereference if needs_deref is true
 */
class QoreNode *QoreNode::eval(bool &needs_deref, ExceptionSink *xsink) const
{
   if (is_value(this))
   {
      needs_deref = false;
      return const_cast<QoreNode *>(this);
   }
   return type->eval(needs_deref, this, xsink);
}

int64 QoreNode::bigIntEval(ExceptionSink *xsink) const
{
   return type->bigint_eval(this, xsink);
}

int QoreNode::integerEval(ExceptionSink *xsink) const
{
   return (int)type->bigint_eval(this, xsink);
}

bool QoreNode::boolEval(ExceptionSink *xsink) const
{
   return type->bool_eval(this, xsink);
}

class QoreString *QoreNode::getAsString(int foff, class ExceptionSink *xsink) const
{
   if (!this)
      return new QoreString("<NOTHING>");
   
   return type->getAsString(this, foff, xsink);
}

bool QoreNode::getAsBool() const
{
   if (type == NT_BOOLEAN)
      return val.boolval;
   else if (type == NT_FLOAT)
      return (bool)val.floatval;
   else if (type == NT_INT)
      return (bool)val.intval;

   QoreNode *t = this->convert(NT_BOOLEAN);
   bool rc = t->val.boolval;
   t->deref(NULL);
   return rc;
}

int QoreNode::getAsInt() const
{
   if (type == NT_INT)
      return val.intval;
   else if (type == NT_BOOLEAN)
      return (int)val.boolval;
   else if (type == NT_FLOAT)
      return (int)val.floatval;

   QoreNode *t = this->convert(NT_INT);
   int rc = t->val.intval;
   t->deref(NULL);
   return rc;
}

int64 QoreNode::getAsBigInt() const
{
   if (type == NT_INT)
      return val.intval;
   else if (type == NT_BOOLEAN)
      return (int64)val.boolval;
   else if (type == NT_FLOAT)
      return (int64)val.floatval;

   QoreNode *t = this->convert(NT_INT);
   int64 rc = t->val.intval;
   t->deref(NULL);
   return rc;
}

double QoreNode::getAsFloat() const
{
   if (type == NT_FLOAT)
      return val.floatval;
   else if (type == NT_BOOLEAN)
      return (double)val.boolval;
   else if (type == NT_INT)
      return (double)val.intval;

   QoreNode *t = this->convert(NT_FLOAT);
   double rc = t->val.floatval;
   t->deref(NULL);
   return rc;
}

// for getting relative time values or integer values
int getSecZeroInt(const class QoreNode *a)
{
   if (is_nothing(a))
      return 0;
   if (a->type == NT_DATE)
      return (int)a->val.date_time->getRelativeSeconds();
   return a->getAsInt();
}

int getSecZeroBigInt(const class QoreNode *a)
{
   if (is_nothing(a))
      return 0;
   if (a->type == NT_DATE)
      return a->val.date_time->getRelativeSeconds();
   return a->getAsBigInt();
}

// for getting relative time values or integer values
int getSecMinusOneInt(const class QoreNode *a)
{
   if (is_nothing(a))
      return -1;
   if (a->type == NT_DATE)
      return (int)a->val.date_time->getRelativeSeconds();
   return a->getAsInt();
}

int getSecMinusOneBigInt(const class QoreNode *a)
{
   if (is_nothing(a))
      return -1;
   if (a->type == NT_DATE)
      return a->val.date_time->getRelativeSeconds();
   return a->getAsBigInt();
}

int getMsZeroInt(const class QoreNode *a)
{
   if (is_nothing(a))
      return 0;
   if (a->type == NT_DATE)
      return (int)a->val.date_time->getRelativeMilliseconds();
   return a->getAsInt();
}

int getMsZeroBigInt(const class QoreNode *a)
{
   if (is_nothing(a))
      return 0;
   if (a->type == NT_DATE)
      return a->val.date_time->getRelativeMilliseconds();
   return a->getAsBigInt();
}

// for getting relative time values or integer values
int getMsMinusOneInt(const class QoreNode *a)
{
   if (is_nothing(a))
      return -1;
   if (a->type == NT_DATE)
      return (int)a->val.date_time->getRelativeMilliseconds();
   return a->getAsInt();
}

int getMsMinusOneBigInt(const class QoreNode *a)
{
   if (is_nothing(a))
      return -1;
   if (a->type == NT_DATE)
      return a->val.date_time->getRelativeMilliseconds();
   return a->getAsBigInt();
}

int getMicroSecZeroInt(const class QoreNode *a)
{
   if (is_nothing(a))
      return 0;
   if (a->type == NT_DATE)
      return (int)a->val.date_time->getRelativeMilliseconds() * 1000;
   return a->getAsInt();
}

bool is_nothing(const QoreNode *n)
{
   if (!n || (n->type == NT_NOTHING))
      return true;
   
   if (n->type == NT_OBJECT && !n->val.object->isValid())
      return true;
   
   return false;
}

bool is_value(const class QoreNode *node)
{
   // the only container types that can be created at parse time are lists and hashes
   
   if (node->type == NT_LIST)
      return !node->val.list->needsEval();
   else if (node->type == NT_HASH)
      return !node->val.hash->needsEval();
   
   return node->type->isValue();
}

static inline QoreNode *crlr_list_copy(const QoreNode *n, ExceptionSink *xsink)
{
   // if it's not an immediate list, then there can't be any
   // variable references in it at any level, so return copy
   if (!n->val.list->needsEval())
      return n->RefSelf();

   // otherwise process each list element
   QoreList *l = new QoreList(1);
   for (int i = 0; i < n->val.list->size(); i++)
      l->push(copy_and_resolve_lvar_refs(n->val.list->retrieve_entry(i), xsink));
   return new QoreNode(l);   
}

static inline QoreNode *crlr_hash_copy(const QoreNode *n, ExceptionSink *xsink)
{
   // if it's not an immediate hash, then there can't be any
   // variable references in it at any level, so return copy
   if (!n->val.hash->needsEval())
      return n->RefSelf();

   QoreHash *h = new QoreHash(1);
   HashIterator hi(n->val.hash);
   while (hi.next())
      h->setKeyValue(hi.getKey(), copy_and_resolve_lvar_refs(hi.getValue(), xsink), xsink);
   return new QoreNode(h);
}

static inline QoreNode *crlr_tree_copy(const QoreNode *n, ExceptionSink *xsink)
{
   class Tree *t = new Tree(copy_and_resolve_lvar_refs(n->val.tree->left, xsink), n->val.tree->op, 
			    n->val.tree->right ? copy_and_resolve_lvar_refs(n->val.tree->right, xsink) : NULL);
   return new QoreNode(t);
}

static inline QoreNode *crlr_fcall_copy(const QoreNode *n, ExceptionSink *xsink)
{
   QoreNode *nn = new QoreNode(NT_FUNCTION_CALL);
   QoreNode *na;
   if (n->val.fcall->args)
      na = copy_and_resolve_lvar_refs(n->val.fcall->args, xsink);
   else
      na = NULL;

   switch (n->val.fcall->type)
   {
      case FC_USER:
	 nn->val.fcall = new FunctionCall(n->val.fcall->f.ufunc, na);
	 break;
      case FC_BUILTIN:
	 nn->val.fcall = new FunctionCall(n->val.fcall->f.bfunc, na);
	 break;
      case FC_SELF:
	 nn->val.fcall = new FunctionCall(n->val.fcall->f.sfunc->func, na);
	 break;
      case FC_UNRESOLVED:
	 nn->val.fcall = new FunctionCall(strdup(n->val.fcall->f.c_str), na);
	 break;
      case FC_IMPORTED:
	 nn->val.fcall = new FunctionCall(n->val.fcall->f.ifunc->pgm, n->val.fcall->f.ifunc->func, na);
	 break;
      case FC_METHOD:
	 nn->val.fcall = new FunctionCall(strdup(n->val.fcall->f.c_str), na);
	 nn->val.fcall->type = FC_METHOD;
	 break;
   }
   return nn;
}

static inline class QoreNode *eval_notnull(const class QoreNode *n, ExceptionSink *xsink)
{
   n = n->eval(xsink);
   if (!xsink->isEvent() && !n)
      return nothing();
   return const_cast<QoreNode *>(n);
}

class QoreNode *copy_and_resolve_lvar_refs(const class QoreNode *n, ExceptionSink *xsink)
{
   if (!n) return NULL;

   if (n->type == NT_LIST)
      return crlr_list_copy(n, xsink);

   if (n->type == NT_HASH)
      return crlr_hash_copy(n, xsink);

   if (n->type == NT_TREE)
      return crlr_tree_copy(n, xsink);

   if (n->type == NT_FUNCTION_CALL)
      return crlr_fcall_copy(n, xsink);

   // must make sure to return a value here or it could cause a segfault - parse expressions expect non-NULL values for the operands
   if (n->type == NT_FIND || n->type == NT_SELF_VARREF)
      return eval_notnull(n, xsink);

   if (n->type == NT_VARREF && n->val.vref->type == VT_LOCAL)
      return eval_notnull(n, xsink);

   return n->RefSelf();
}
