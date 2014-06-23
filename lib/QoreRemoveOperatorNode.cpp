/*
  QoreRemoveOperatorNode.cpp
 
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

QoreString QoreRemoveOperatorNode::remove_str("remove operator expression");

// if del is true, then the returned QoreString * should be removed, if false, then it must not be
QoreString *QoreRemoveOperatorNode::getAsString(bool &del, int foff, ExceptionSink *xsink) const {
   del = false;
   return &remove_str;
}

int QoreRemoveOperatorNode::getAsString(QoreString &str, int foff, ExceptionSink *xsink) const {
   str.concat(&remove_str);
   return 0;
}

int64 QoreRemoveOperatorNode::bigIntEvalImpl(ExceptionSink *xsink) const {
   LValueRemoveHelper lvrh(exp, xsink, false);
   if (!lvrh)
      return 0;
   return lvrh.removeBigInt();
}

int QoreRemoveOperatorNode::integerEvalImpl(ExceptionSink *xsink) const {
   LValueRemoveHelper lvrh(exp, xsink, false);
   if (!lvrh)
      return 0;
   return (int)lvrh.removeBigInt();
}

double QoreRemoveOperatorNode::floatEvalImpl(ExceptionSink *xsink) const {
   LValueRemoveHelper lvrh(exp, xsink, false);
   if (!lvrh)
      return 0;
   return lvrh.removeFloat();
}

AbstractQoreNode *QoreRemoveOperatorNode::evalImpl(ExceptionSink *xsink) const {
   LValueRemoveHelper lvrh(exp, xsink, false);
   if (!lvrh)
      return 0;
   return lvrh.remove();
}

AbstractQoreNode *QoreRemoveOperatorNode::evalImpl(bool &needs_deref, ExceptionSink *xsink) const {
   needs_deref = true;
   return QoreRemoveOperatorNode::evalImpl(xsink);
}

AbstractQoreNode *QoreRemoveOperatorNode::parseInitImpl(LocalVar *oflag, int pflag, int &lvids, const QoreTypeInfo *&typeInfo) {
   assert(!typeInfo);
   if (exp) {
      exp = exp->parseInit(oflag, pflag, lvids, typeInfo);
      if (exp && check_lvalue(exp))
         parse_error("the remove operator expects an lvalue as its operand, got '%s' instead", exp->getTypeName());
      returnTypeInfo = typeInfo;
   }
   return this;
}

QoreRemoveOperatorNode* QoreRemoveOperatorNode::copyBackground(ExceptionSink* xsink) const {
   ReferenceHolder<> n_exp(copy_and_resolve_lvar_refs(exp, xsink), xsink);
   if (*xsink)
      return 0;
   return new QoreRemoveOperatorNode(n_exp.release());
}
