/*
 QC_QPushButton.cc
 
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

#include "QC_QPushButton.h"
#include "QC_QIcon.h"
#include "QC_QWidget.h"
#include "QC_QMenu.h"

int CID_QPUSHBUTTON;
class QoreClass *QC_QPushButton = 0;

//QPushButton ( QWidget * parent = 0 )
//QPushButton ( const QString & text, QWidget * parent = 0 )
//QPushButton ( const QIcon & icon, const QString & text, QWidget * parent = 0 )
static void QPUSHBUTTON_constructor(QoreObject *self, const QoreList *params, ExceptionSink *xsink)
{
   QoreNode *p = get_param(params, 0);
   if (is_nothing(p)) {
      self->setPrivate(CID_QPUSHBUTTON, new QoreQPushButton(self));
      return;
   }
   if (p && p->type == NT_OBJECT) {
      QoreQIcon *icon = (QoreQIcon *)p->val.object->getReferencedPrivateData(CID_QICON, xsink);
      if (!icon) {
         QoreQWidget *parent = (QoreQWidget *)p->val.object->getReferencedPrivateData(CID_QWIDGET, xsink);
         if (*xsink)
            return;
         ReferenceHolder<AbstractPrivateData> parentHolder(static_cast<AbstractPrivateData *>(parent), xsink);
         self->setPrivate(CID_QPUSHBUTTON, new QoreQPushButton(self, parent ? static_cast<QWidget *>(parent->getQWidget()) : 0));
         return;
      }
      ReferenceHolder<AbstractPrivateData> iconHolder(static_cast<AbstractPrivateData *>(icon), xsink);
      p = get_param(params, 1);
      QString text;
      if (get_qstring(p, text, xsink))
         return;
      p = get_param(params, 2);
      QoreQWidget *parent = (p && p->type == NT_OBJECT) ? (QoreQWidget *)p->val.object->getReferencedPrivateData(CID_QWIDGET, xsink) : 0;
      if (*xsink)
         return;
      ReferenceHolder<AbstractPrivateData> parentHolder(static_cast<AbstractPrivateData *>(parent), xsink);
      self->setPrivate(CID_QPUSHBUTTON, new QoreQPushButton(self, *(static_cast<QIcon *>(icon)), text, parent ? static_cast<QWidget *>(parent->getQWidget()) : 0));
      return;
   }
   QString text;
   if (get_qstring(p, text, xsink))
      return;
   p = get_param(params, 1);
   QoreQWidget *parent = (p && p->type == NT_OBJECT) ? (QoreQWidget *)p->val.object->getReferencedPrivateData(CID_QWIDGET, xsink) : 0;
   if (*xsink)
      return;
   ReferenceHolder<AbstractPrivateData> parentHolder(static_cast<AbstractPrivateData *>(parent), xsink);
   self->setPrivate(CID_QPUSHBUTTON, new QoreQPushButton(self, text, parent ? static_cast<QWidget *>(parent->getQWidget()) : 0));
   return;
}

static void QPUSHBUTTON_copy(class QoreObject *self, class QoreObject *old, class QoreQPushButton *qpb, ExceptionSink *xsink)
{
   xsink->raiseException("QPUSHBUTTON-COPY-ERROR", "objects of this class cannot be copied");
}

//bool autoDefault () const
static QoreNode *QPUSHBUTTON_autoDefault(QoreObject *self, QoreAbstractQPushButton *qpb, const QoreList *params, ExceptionSink *xsink)
{
   return new QoreNode(qpb->getQPushButton()->autoDefault());
}

//bool isDefault () const
static QoreNode *QPUSHBUTTON_isDefault(QoreObject *self, QoreAbstractQPushButton *qpb, const QoreList *params, ExceptionSink *xsink)
{
   return new QoreNode(qpb->getQPushButton()->isDefault());
}

//bool isFlat () const
static QoreNode *QPUSHBUTTON_isFlat(QoreObject *self, QoreAbstractQPushButton *qpb, const QoreList *params, ExceptionSink *xsink)
{
   return new QoreNode(qpb->getQPushButton()->isFlat());
}

//QMenu * menu () const
static QoreNode *QPUSHBUTTON_menu(QoreObject *self, QoreAbstractQPushButton *qpb, const QoreList *params, ExceptionSink *xsink)
{
   QMenu *qt_qobj = qpb->getQPushButton()->menu();
   if (!qt_qobj)
      return 0;
   QVariant qv_ptr = qt_qobj->property("qobject");
   QoreObject *rv_obj = reinterpret_cast<QoreObject *>(qv_ptr.toULongLong());
   assert(rv_obj);
   rv_obj->ref();
   return new QoreNode(rv_obj);
}

//void setAutoDefault ( bool )
static QoreNode *QPUSHBUTTON_setAutoDefault(QoreObject *self, QoreAbstractQPushButton *qpb, const QoreList *params, ExceptionSink *xsink)
{
   QoreNode *p = get_param(params, 0);
   bool b = p ? p->getAsBool() : false;
   qpb->getQPushButton()->setAutoDefault(b);
   return 0;
}

//void setDefault ( bool )
static QoreNode *QPUSHBUTTON_setDefault(QoreObject *self, QoreAbstractQPushButton *qpb, const QoreList *params, ExceptionSink *xsink)
{
   QoreNode *p = get_param(params, 0);
   bool b = p ? p->getAsBool() : false;
   qpb->getQPushButton()->setDefault(b);
   return 0;
}

//void setFlat ( bool )
static QoreNode *QPUSHBUTTON_setFlat(QoreObject *self, QoreAbstractQPushButton *qpb, const QoreList *params, ExceptionSink *xsink)
{
   QoreNode *p = get_param(params, 0);
   bool b = p ? p->getAsBool() : false;
   qpb->getQPushButton()->setFlat(b);
   return 0;
}

//void setMenu ( QMenu * menu )
static QoreNode *QPUSHBUTTON_setMenu(QoreObject *self, QoreAbstractQPushButton *qpb, const QoreList *params, ExceptionSink *xsink)
{
   QoreNode *p = get_param(params, 0);
   QoreAbstractQMenu *menu = (p && p->type == NT_OBJECT) ? (QoreAbstractQMenu *)p->val.object->getReferencedPrivateData(CID_QMENU, xsink) : 0;
   if (!menu) {
      if (!xsink->isException())
         xsink->raiseException("QPUSHBUTTON-SETMENU-PARAM-ERROR", "expecting a QMenu object as first argument to QPushButton::setMenu()");
      return 0;
   }
   ReferenceHolder<AbstractPrivateData> menuHolder(static_cast<AbstractPrivateData *>(menu), xsink);
   qpb->getQPushButton()->setMenu(menu->getQMenu());
   return 0;
}

//void showMenu ()
static QoreNode *QPUSHBUTTON_showMenu(QoreObject *self, QoreAbstractQPushButton *qpb, const QoreList *params, ExceptionSink *xsink)
{
   qpb->getQPushButton()->showMenu();
   return 0;
}

//void initStyleOption ( QStyleOptionButton * option ) const
/*
static QoreNode *QPUSHBUTTON_initStyleOption(QoreObject *self, QoreAbstractQPushButton *qpb, const QoreList *params, ExceptionSink *xsink)
{
   QoreNode *p = get_param(params, 0);
   QoreQStyleOptionButton *option = (p && p->type == NT_OBJECT) ? (QoreQStyleOptionButton *)p->val.object->getReferencedPrivateData(CID_QSTYLEOPTIONBUTTON, xsink) : 0;
   if (!option) {
      if (!xsink->isException())
         xsink->raiseException("QPUSHBUTTON-INITSTYLEOPTION-PARAM-ERROR", "expecting a QStyleOptionButton object as first argument to QPushButton::initStyleOption()");
      return 0;
   }
   ReferenceHolder<AbstractPrivateData> optionHolder(static_cast<AbstractPrivateData *>(option), xsink);
   qpb->initStyleOption(static_cast<QStyleOptionButton *>(option));
   return 0;
}
*/

QoreClass *initQPushButtonClass(QoreClass *qabstractbutton)
{
   QC_QPushButton = new QoreClass("QPushButton", QDOM_GUI);
   CID_QPUSHBUTTON = QC_QPushButton->getID();

   QC_QPushButton->addBuiltinVirtualBaseClass(qabstractbutton);

   QC_QPushButton->setConstructor(QPUSHBUTTON_constructor);
   QC_QPushButton->setCopy((q_copy_t)QPUSHBUTTON_copy);

   QC_QPushButton->addMethod("autoDefault",                 (q_method_t)QPUSHBUTTON_autoDefault);
   QC_QPushButton->addMethod("isDefault",                   (q_method_t)QPUSHBUTTON_isDefault);
   QC_QPushButton->addMethod("isFlat",                      (q_method_t)QPUSHBUTTON_isFlat);
   QC_QPushButton->addMethod("menu",                        (q_method_t)QPUSHBUTTON_menu);
   QC_QPushButton->addMethod("setAutoDefault",              (q_method_t)QPUSHBUTTON_setAutoDefault);
   QC_QPushButton->addMethod("setDefault",                  (q_method_t)QPUSHBUTTON_setDefault);
   QC_QPushButton->addMethod("setFlat",                     (q_method_t)QPUSHBUTTON_setFlat);
   QC_QPushButton->addMethod("setMenu",                     (q_method_t)QPUSHBUTTON_setMenu);
   QC_QPushButton->addMethod("showMenu",                    (q_method_t)QPUSHBUTTON_showMenu);

   //QC_QPushButton->addMethod("initStyleOption",             (q_method_t)QPUSHBUTTON_initStyleOption, true);

   return QC_QPushButton;
}
