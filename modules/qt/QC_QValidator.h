/*
 QC_QValidator.h
 
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

#ifndef _QORE_QT_QC_QVALIDATOR_H

#define _QORE_QT_QC_QVALIDATOR_H

#define _IS_QORE_QVALIDATOR 1

#include <QValidator>
#include "QoreAbstractQValidator.h"
#include "qore-qt-events.h"

DLLLOCAL extern qore_classid_t CID_QVALIDATOR;
DLLLOCAL extern class QoreClass *QC_QValidator;

DLLLOCAL class QoreClass *initQValidatorClass(QoreClass *);

class myQValidator : public QValidator, public QoreQValidatorExtension
{
#define QOREQTYPE QValidator
#define MYQOREQTYPE myQValidator
#include "qore-qt-metacode.h"
#include "qore-qt-qvalidator-methods.h"
#undef MYQOREQTYPE
#undef QOREQTYPE

   public:
      DLLLOCAL myQValidator(QoreObject *obj, QObject* parent) : QValidator(parent), QoreQValidatorExtension(obj, this)
      {
         
      }
};

class QoreQValidator : public QoreAbstractQValidator
{
   public:
      QPointer<myQValidator> qobj;

      DLLLOCAL QoreQValidator(QoreObject *obj, QObject* parent) : qobj(new myQValidator(obj, parent))
      {
      }
      DLLLOCAL virtual class QObject *getQObject() const
      {
         return static_cast<QObject *>(&(*qobj));
      }
      DLLLOCAL virtual class QValidator *getQValidator() const 
      { 
	 return static_cast<QValidator *>(&(*qobj)); 
      }

      QORE_VIRTUAL_QVALIDATOR_METHODS
};

class QoreQtQValidator : public QoreAbstractQValidator
{
   public:
      QoreObject *qore_obj;
      QPointer<QValidator> qobj;

      DLLLOCAL QoreQtQValidator(QoreObject *obj, QValidator *qv) : qore_obj(obj), qobj(qv)
      {
      }
      DLLLOCAL virtual class QObject *getQObject() const
      {
         return static_cast<QObject *>(&(*qobj));
      }
      DLLLOCAL virtual class QValidator *getQValidator() const 
      { 
	 return static_cast<QValidator *>(&(*qobj)); 
      }
#include "qore-qt-static-qvalidator-methods.h"
};

#undef _IS_QORE_QVALIDATOR

#endif // _QORE_QT_QC_QVALIDATOR_H
