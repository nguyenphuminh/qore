/* -*- mode: c++; indent-tabs-mode: nil -*- */
/*
  NamedScope.h

  Qore Programming Language

  Copyright (C) 2003 - 2015 David Nichols

  NamedScopes are children of a program object.  there is a parse
  lock per program object to ensure that objects are added (or backed out)
  atomically per program object.  All the objects referenced here should 
  be safe to read & copied at all times.  They will only be deleted when the
  program object is deleted (except the pending structures, which will be
  deleted any time there is a parse error, together with all other
  pending structures)

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

#ifndef QORE_NAMEDSCOPE_H

#define QORE_NAMEDSCOPE_H

#include <vector>
#include <string>

// for parsing namespace/class scope resolution
class NamedScope {
protected:
   typedef std::vector<std::string> nslist_t;

   bool del;

   DLLLOCAL void init();

public:
   char *ostr;
   nslist_t strlist;

   DLLLOCAL NamedScope(char *str) : del(true), ostr(str) {
      assert(str);
      init();
   }

   DLLLOCAL NamedScope(const char *str) : del(false), ostr((char *)str) {
      assert(str);
      init();
   }

   // takes all values from and deletes the argument
   DLLLOCAL NamedScope(NamedScope *ns) : del(ns->del), ostr(ns->ostr), strlist(ns->strlist) {
      ns->ostr = 0;
      delete ns;
   }

   DLLLOCAL NamedScope(const NamedScope &old) : del(true), ostr(strdup(old.ostr)), strlist(old.strlist) {
   }

   DLLLOCAL ~NamedScope() {
      clear();
   }

   DLLLOCAL void clear() {
      if (ostr && del)
         free(ostr);
      strlist.clear();
      ostr = 0;
      del = false;
   }

   DLLLOCAL const char *getIdentifier() const {
      return strlist[strlist.size() - 1].c_str();
   }

   DLLLOCAL const std::string &getIdentifierStr() const {
      return strlist[strlist.size() - 1];
   }

   DLLLOCAL const char* get(unsigned i) const {
      assert(i < strlist.size());
      return strlist[i].c_str();
   }

   DLLLOCAL const char* operator[](unsigned i) const {
      assert(i < strlist.size());
      return strlist[i].c_str();
   }         

   DLLLOCAL unsigned size() const {
      return strlist.size(); 
   }

   DLLLOCAL NamedScope *copy() const;
   DLLLOCAL void fixBCCall();

   DLLLOCAL char *takeName() {
      char *rv = del ? ostr : strdup(ostr);
      ostr = 0;
      clear();
      return rv;
   }
};

class ltns {
public:
   DLLLOCAL bool operator()(const NamedScope& s1, const NamedScope& s2) const {
      return strcmp(s1.ostr, s2.ostr) < 0;
   }
};

#endif // QORE_NAMEDSCOPE_H
