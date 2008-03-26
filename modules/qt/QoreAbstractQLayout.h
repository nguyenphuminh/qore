/*
 QoreAbstractQLayout.h
 
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

#ifndef _QORE_QOREABSTRACTQLAYOUT_H

#define _QORE_QOREABSTRACTQLAYOUT_H

#include "QoreAbstractQObject.h"
#include "QoreAbstractQWidget.h"

extern qore_classid_t CID_QWIDGET;

class QoreAbstractQLayout : public QoreAbstractQObject
{
   public:
      DLLLOCAL virtual QLayout *getQLayout() const = 0;
};

template<typename T, typename V>
class QoreQLayoutBase : public QoreQObjectBase<T, V>
{
   public:
      DLLLOCAL QoreQLayoutBase(T *qo) : QoreQObjectBase<T, V>(qo)
      {
      }
      DLLLOCAL virtual QLayout *getQLayout() const
      {
         return &(*this->qobj);
      }
};

template<typename T, typename V>
class QoreQtQLayoutBase : public QoreQtQObjectBase<T, V>
{
   public:
      DLLLOCAL QoreQtQLayoutBase(QoreObject *obj, T *qo) : QoreQtQObjectBase<T, V>(obj, qo)
      {
      }

      DLLLOCAL virtual QLayout *getQLayout() const
      {
         return this->qobj;
      }
};

#endif
