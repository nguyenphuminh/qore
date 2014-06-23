/*
  QoreCastOperatorNode.cpp
 
  Qore Programming Language
 
  Copyright (C) 2003 - 2014 David Nichols
 
  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the "Software"),
  to deal in the Software without restriction, including without limitation
  the rights to use, copy, modify, merge, publish, distribute, sublicense,
  and/or sell copies of the Software, and to permit persons to whom the
  Software is furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  Note that the Qore library is released under a choice of three open-source
  licenses: MIT (as above), LGPL 2+, or GPL 2+; see README-LICENSE for more
  information.
*/

#include <qore/Qore.h>
#include <qore/intern/QoreNamespaceIntern.h>

QoreString QoreCastOperatorNode::cast_str("cast operator expression");

// if del is true, then the returned QoreString * should be castd, if false, then it must not be
QoreString *QoreCastOperatorNode::getAsString(bool &del, int foff, ExceptionSink *xsink) const {
   del = false;
   return &cast_str;
}

int QoreCastOperatorNode::getAsString(QoreString &str, int foff, ExceptionSink *xsink) const {
   str.concat(&cast_str);
   return 0;
}

int QoreCastOperatorNode::evalIntern(const AbstractQoreNode *rv, ExceptionSink *xsink) const {
   if (!rv || rv->getType() != NT_OBJECT) {
      xsink->raiseException("RUNTIME-CAST-ERROR", "cannot cast from type '%s' to %s'%s'", get_type_name(rv), qc ? "class " : "", qc ? qc->getName() : "object");
      return -1;
   }

   const QoreObject *obj = reinterpret_cast<const QoreObject *>(rv);
   if (qc && !obj->getClass(qc->getID())) {
      xsink->raiseException("RUNTIME-CAST-ERROR", "cannot cast from class '%s' to class '%s'", obj->getClassName(), qc->getName());
      return -1;
   }

   return 0;
}

AbstractQoreNode *QoreCastOperatorNode::evalImpl(ExceptionSink *xsink) const {
   ReferenceHolder<AbstractQoreNode> rv(exp->eval(xsink), xsink);
   if (*xsink)
      return 0;

   if (evalIntern(*rv, xsink))
      return 0;

   return rv.release();
}

AbstractQoreNode *QoreCastOperatorNode::evalImpl(bool &needs_deref, ExceptionSink *xsink) const {
   QoreNodeEvalOptionalRefHolder rv(exp, xsink);
   if (*xsink)
      return 0;
   
   if (evalIntern(*rv, xsink))
      return 0;

   if (rv.isTemp()) {
      needs_deref = false;
      return const_cast<AbstractQoreNode *>(*rv);
   }
   needs_deref = true;
   return rv.getReferencedValue();
}

AbstractQoreNode *QoreCastOperatorNode::parseInitImpl(LocalVar *oflag, int pflag, int &lvids, const QoreTypeInfo *&typeInfo) {
   assert(!typeInfo);
   if (path->size() == 1) {
      // if the class is "object", then set qc = 0 to use as a catch-all and generic "cast to object"
      const char *id = path->getIdentifier();
      qc = !strcmp(id, "object") ? 0 : qore_root_ns_private::parseFindClass(loc, path->getIdentifier());
   }
   else {
      qc = qore_root_ns_private::parseFindScopedClass(loc, *path);
   }

   //printd(5, "QoreCastOperatorNode::parseInit() this=%p resolved %s->%s\n", this, path->getIdentifier(), qc ? qc->getName() : "<generic object cast>");

   if (exp)
      exp = exp->parseInit(oflag, pflag, lvids, typeInfo);

   if (typeInfo->hasType()) {
      if (!objectTypeInfo->parseAccepts(typeInfo)) {
	 parse_error(loc, "cast<>(%s) is invalid; cannot cast from %s to object", qc ? qc->getName() : "object", typeInfo->getName(), typeInfo->getName());
      }
#ifdef _QORE_STRICT_CAST
      else if (qc && (qc->getTypeInfo()->parseAccepts(typeInfo) == QTI_NOT_EQUAL) && typeInfo->parseAccepts(qc->getTypeInfo()) == QTI_NOT_EQUAL) {
	 parse_error(loc, "cannot cast from %s to %s; the classes are not compatible", typeInfo->getName(), path->ostr);
      }
#endif
   }

   // free temporary memory
   delete path;
   path = 0;

   // set return type info
   typeInfo = qc ? qc->getTypeInfo() : objectTypeInfo;
   return this;
}
