/*
  QoreGetOpt.cpp

  Qore Programming Language

  Copyright 2003 - 2012 David Nichols

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
#include <qore/intern/QoreGetOpt.h>

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

QoreGetOpt::~QoreGetOpt() {
   getopt_node_list_t::iterator i;
   while ((i = node_list.begin()) != node_list.end()) {
      QoreGetOptNode* n = *i;
      node_list.erase(i);
      delete n;
   }
   long_map.clear();
   short_map.clear();
}

QoreGetOptNode* QoreGetOpt::find(const char* opt) const {
   getopt_long_map_t::const_iterator i = long_map.find(opt);
   if (i != long_map.end())
      return i->second;

   return 0;
}

QoreGetOptNode* QoreGetOpt::find(char opt) const {
   getopt_short_map_t::const_iterator i = short_map.find(opt);
   if (i != short_map.end())
      return i->second;
   return 0;
}

int QoreGetOpt::add(const char* name, char short_opt, const char* long_opt, qore_type_t argtype, int option) {
   // check input for validity
   if (!name || !name[0])
      return QGO_ERR_NO_NAME;
   if (!short_opt && (!long_opt || !long_opt[0]))
      return QGO_ERR_NO_OPTION;

   //printf("QoreGetOpt::add(%s, %03d (%c), %s, %d, %d)\n", name, short_opt, short_opt ? short_opt : '-', long_opt, argtype, option);
   // look for duplicate entries
   if (short_opt && find(short_opt))
      return QGO_ERR_DUP_SHORT_OPT;
   if (long_opt && find(long_opt))
      return QGO_ERR_DUP_LONG_OPT;

   QoreGetOptNode* n = new QoreGetOptNode(name, short_opt, long_opt, argtype, option);
   if (short_opt)
      short_map[short_opt] = n;
   if (long_opt)
      long_map[n->long_opt.c_str()] = n;
   node_list.push_back(n);
   
   return 0;
}

static void addError(QoreHashNode* h, QoreStringNode* err) {
   //printd(5, "addError() adding: %s\n", err->getBuffer())
   hash_assignment_priv ha(*h, "_ERRORS_");
   QoreListNode* l = reinterpret_cast<QoreListNode* >(*ha);
   if (!l) {
      l = new QoreListNode;
      ha.assign(l, 0);
   }
      
   l->push(err);
}

// private, static method
DateTimeNode* QoreGetOpt::parseDate(const char* val) {
   return new DateTimeNode(val);
}

void QoreGetOpt::doOption(class QoreGetOptNode* n, class QoreHashNode* h, const char* val) {
   hash_assignment_priv ha(*h, n->name);

   // get a value ready
   if (n->argtype == -1) {
      if (*ha)
	 return;
      ha.assign(&True, 0);
      return;
   }

   // handle option values
   if (!val) {
      if (n->option & QGO_OPT_ADDITIVE) {
	 if (n->argtype == NT_INT) {
	    if (!*ha)
	       ha.assign(new QoreBigIntNode(1), 0);
	    else {
	       QoreBigIntNode* b = reinterpret_cast<QoreBigIntNode* >(*ha);
	       b->val++;
	    }
	 }
	 else {
	    if (!*ha)
	       ha.assign(ZeroFloat->refSelf(), 0);
	    else {
	       QoreFloatNode* f = reinterpret_cast<QoreFloatNode* >(*ha);
	       f->f++;
	    }
	 }
      }
      else if (!*ha)
	 ha.assign(&True, 0);
      return;
   }

   AbstractQoreNode* v;
   if (n->argtype == NT_STRING)
      v = new QoreStringNode(val);
   else if (n->argtype == NT_INT)
      v = new QoreBigIntNode(strtoll(val, 0, 10));
   else if (n->argtype == NT_FLOAT)
      v = new QoreFloatNode(strtod(val, 0));
   else if (n->argtype == NT_DATE)
      v = parseDate(val);
   else if (n->argtype == NT_BOOLEAN)
      v = get_bool_node((bool)strtol(val, 0, 10));
   else // default string
      v = new QoreStringNode(val);
   
   if (!(n->option & QGO_OPT_LIST_OR_ADD)) {
      ha.assign(v, 0);
      return;
   }

   if (n->option & QGO_OPT_LIST) {
      QoreListNode* l = reinterpret_cast<QoreListNode* >(*ha);
      if (!l) {
	 l = new QoreListNode;
	 ha.assign(l, 0);
      }
      //else printf("cv->getType()=%s\n", cv->getTypeName());
      l->push(v);
      return;
   }
   
   // additive
   if (*ha) {
      if (n->argtype == NT_INT) {
	 QoreBigIntNode* b = reinterpret_cast<QoreBigIntNode* >(*ha);
	 b->val += reinterpret_cast<QoreBigIntNode* >(v)->val;
      }
      else { // float
	 QoreFloatNode* f = reinterpret_cast<QoreFloatNode* >(*ha);
	 f->f += reinterpret_cast<const QoreFloatNode* >(v)->f;
      }
      v->deref(0);
      return;
   }

   ha.assign(v, 0);
}

char* QoreGetOpt::getNextArgument(QoreListNode* l, QoreHashNode* h, unsigned &i, const char* lopt, char sopt) {
   if (i < (l->size() - 1)) {
      i++;
      QoreStringNode* n = dynamic_cast<QoreStringNode* >(l->retrieve_entry(i));
      if (n)
	 return (char* )n->getBuffer();
   }
   QoreStringNode* err = new QoreStringNode;
   if (lopt)
      err->sprintf("long option '--%s' requires an argument", lopt);
   else
      err->sprintf("short option '-%c' requires an argument", sopt);
   addError(h, err);
   return 0;
}

void QoreGetOpt::processLongArg(const char* arg, QoreListNode* l, class QoreHashNode* h, unsigned &i, bool modify) {
   const char* opt;
   char* val;

   // get a copy of the argument
   QoreString vstr(arg);
   arg = vstr.getBuffer();

   // see if there is an assignment character
   char* tok = (char* )strchr(arg, '=');
   if (tok) {
      (*tok) = '\0';
      opt = arg;
      val = tok + 1;
   }
   else {  
      opt = arg;
      val = 0;
   }
   // find option
   QoreGetOptNode* w = find(opt);
   if (!w) {
      QoreStringNode* err = new QoreStringNodeMaker("unknown long option '--%s'", opt);
      addError(h, err);
      return;
   }
   bool do_modify = false;
   // if we need a value and there isn't one, then try to get the next argument in the list
   if (w->argtype && !val && (w->option & QGO_OPT_MANDATORY)) {
      val = (char* )getNextArgument(l, h, i, opt, '\0');
      if (val && modify)
	 do_modify = true;
      if (!val)
	 return;
   }
   doOption(w, h, val);
   if (do_modify)
      l->pop_entry(--i, 0);
}

int QoreGetOpt::processShortArg(const char* arg, QoreListNode* l, class QoreHashNode* h, unsigned &i, int &j, bool modify) {
   char opt = (arg + j)[0];
   // find option
   QoreGetOptNode* w = find(opt);
   if (!w) {
      QoreStringNode* err = new QoreStringNodeMaker("unknown short option '-%c'", opt);
      addError(h, err);
      return 0;
   }
   bool do_modify = false;
   const char* val = 0;
   if (w->argtype != -1) {
      if ((j < (signed)(strlen(arg) - 1))
	  && ((w->option & QGO_OPT_MANDATORY) || ((arg + j + 1)[0] == '='))) {
	 val = arg + j + 1;
	 if (*val == '=')
	    val++;
	 j = 0;
      }
      else if (w->option & QGO_OPT_MANDATORY) {
	 if (!(val = getNextArgument(l, h, i, 0, opt)))
	    return 0;
	 if (modify)
	    do_modify = true;
      }
   }
   doOption(w, h, val);
   if (do_modify)
      l->pop_entry(--i, 0);
   //printd(5, "processShortArg(%c) val=%08p %s returning %d\n", opt, val, val, !j);
   return !j;
}

QoreHashNode* QoreGetOpt::parse(QoreListNode* l, bool modify, ExceptionSink *xsink) {
   QoreHashNode* h = new QoreHashNode;

   for (unsigned i = 0; i < l->size(); i++) {
      //printf("QoreGetOpt::parse() %d/%d\n", i, l->size());
      AbstractQoreNode* n = l->retrieve_entry(i);
      if (get_node_type(n) != NT_STRING)
	 continue;

      QoreStringNode* str = reinterpret_cast<QoreStringNode*>(n);
      const char* arg = str->getBuffer();

      if (arg[0] == '-') {
	 if (!arg[1])
	    continue;
	 if (arg[1] == '-') {
	    if (!arg[2])
	       break;
	    processLongArg(arg + 2, l, h, i, modify);
	    if (modify) {
	       //printd(5, "parse() opt=%s size=%d\n", arg, l->size()); 
	       l->pop_entry(i--, 0);
	       //printd(5, "parse() popped entry, size=%d\n", l->size());
	    }
	    continue;
	 }
	 int len = strlen(arg);
	 for (int j = 1; j < len; j++)
	    if (processShortArg(arg, l, h, i, j, modify))
	       break;
	 l->pop_entry(i--, 0);
      }
   }
   //printd(5, "QoreGetOpt::parse() returning h=%08p (size %d)\n", h, h->size());
   return h;
}
