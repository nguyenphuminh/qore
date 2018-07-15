/*
    QoreValueCoalescingOperatorNode.cpp

    Qore Programming Language

    Copyright (C) 2003 - 2018 Qore Technologies, s.r.o.

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

#include "qore/intern/QoreValueCoalescingOperatorNode.h"
//#include <qore/intern/qore_program_private.h>

QoreString QoreValueCoalescingOperatorNode::value_coalescing_str("value coalescing operator");

// if del is true, then the returned QoreString * should be mapd, if false, then it must not be
QoreString *QoreValueCoalescingOperatorNode::getAsString(bool &del, int foff, ExceptionSink *xsink) const {
    del = false;
    return &value_coalescing_str;
}

int QoreValueCoalescingOperatorNode::getAsString(QoreString &str, int foff, ExceptionSink *xsink) const {
    str.concat(&value_coalescing_str);
    return 0;
}

AbstractQoreNode* QoreValueCoalescingOperatorNode::parseInitImpl(LocalVar *oflag, int pflag, int &lvids, const QoreTypeInfo *&typeInfo) {
    assert(!typeInfo);

    const QoreTypeInfo* lti = nullptr;
    parse_init_value(left, oflag, pflag, lvids, lti);

    lti = nullptr;
    parse_init_value(right, oflag, pflag, lvids, lti);

    return this;
}

QoreValue QoreValueCoalescingOperatorNode::evalValueImpl(bool& needs_deref, ExceptionSink* xsink) const {
    {
        ValueEvalRefHolder arg(left, xsink);
        if (*xsink)
        return QoreValue();

        if (arg->getAsBool())
        return arg.takeValue(needs_deref);
    }

    ValueEvalRefHolder arg(right, xsink);
    if (*xsink)
        return QoreValue();

    return arg.takeValue(needs_deref);
}
