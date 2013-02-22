/* -*- mode: c++; indent-tabs-mode: nil -*- */
/*
 QoreIntPostIncrementOperatorNode.h

 Qore Programming Language

 Copyright 2003 - 2013 David Nichols

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

#ifndef _QORE_QOREINTPOSTINCREMENTOPERATORNODE_H
#define _QORE_QOREINTPOSTINCREMENTOPERATORNODE_H

class QoreIntPostIncrementOperatorNode : public QoreSingleExpressionOperatorNode<LValueOperatorNode> {
OP_COMMON
protected:
   DLLLOCAL virtual AbstractQoreNode *evalImpl(ExceptionSink *xsink) const;
   DLLLOCAL virtual AbstractQoreNode *evalImpl(bool &needs_deref, ExceptionSink *xsink) const;

   DLLLOCAL virtual int64 bigIntEvalImpl(ExceptionSink *xsink) const;
   DLLLOCAL virtual int integerEvalImpl(ExceptionSink *xsink) const;
   DLLLOCAL virtual double floatEvalImpl(ExceptionSink *xsink) const;
   DLLLOCAL virtual bool boolEvalImpl(ExceptionSink *xsink) const;

   DLLLOCAL virtual const QoreTypeInfo* getTypeInfo() const {
      return bigIntTypeInfo;
   }

   DLLLOCAL virtual AbstractQoreNode *parseInitImpl(LocalVar *oflag, int pflag, int &lvids, const QoreTypeInfo *&typeInfo) {
      // should never be called
      assert(false);
      return this;
   }

public:
   DLLLOCAL QoreIntPostIncrementOperatorNode(AbstractQoreNode *n_exp) : QoreSingleExpressionOperatorNode<LValueOperatorNode>(n_exp) {
   }
};

#endif

