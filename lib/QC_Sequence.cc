/*
  QC_Sequence.cc
  
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
#include <qore/intern/QC_Sequence.h>

int CID_SEQUENCE;

static void SEQUENCE_constructor(class QoreObject *self, const QoreList *params, ExceptionSink *xsink)
{
   int start;
   class QoreNode *p0 = get_param(params, 0);
   if (p0)
      start = p0->getAsInt();
   else
      start = 0;
   self->setPrivate(CID_SEQUENCE, new QoreSequence(start));
}

static void SEQUENCE_copy(class QoreObject *self, class QoreObject *old, class QoreSequence *s, class ExceptionSink *xsink)
{
   self->setPrivate(CID_SEQUENCE, new QoreSequence(s->getCurrent()));
}

static class QoreNode *SEQUENCE_next(class QoreObject *self, class QoreSequence *s, const QoreList *params, ExceptionSink *xsink)
{
   return new QoreNode((int64)s->next());
}

static class QoreNode *SEQUENCE_getCurrent(class QoreObject *self, class QoreSequence *s, const QoreList *params, ExceptionSink *xsink)
{
   return new QoreNode((int64)s->getCurrent()); 
}

class QoreClass *initSequenceClass()
{
   tracein("initSequenceClass()");

   // note that this class does not block therefore has no QDOM_THREAD
   class QoreClass *QC_SEQUENCE = new QoreClass("Sequence");
   CID_SEQUENCE = QC_SEQUENCE->getID();
   QC_SEQUENCE->setConstructor(SEQUENCE_constructor);
   QC_SEQUENCE->setCopy((q_copy_t)SEQUENCE_copy);
   QC_SEQUENCE->addMethod("next",          (q_method_t)SEQUENCE_next);
   QC_SEQUENCE->addMethod("getCurrent",    (q_method_t)SEQUENCE_getCurrent);

   traceout("initSequenceClass()");
   return QC_SEQUENCE;
}
