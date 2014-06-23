/*
  support.cpp

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

#include <qore/intern/qore_program_private.h>

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>

extern bool threads_initialized;

#define QORE_SERIALIZE_DEBUGGING_OUTPUT 1

#ifdef QORE_SERIALIZE_DEBUGGING_OUTPUT
static QoreThreadLock debug_output_lock;
#endif

int printe(const char *fmt, ...) {
   va_list args;
   QoreString buf;

   while (true) {
      va_start(args, fmt);
      int rc = buf.vsprintf(fmt, args);
      va_end(args);
      if (!rc)
	 break;
   }
		    
   fputs(buf.getBuffer(), stderr);
   fflush(stderr);
   return 0;
}

static void get_timestamp(QoreString &str) {
   if (!threads_initialized)
      return;

   int us;
   int64 secs = q_epoch_us(us);
   DateTime now;
   now.setDate(currentTZ(), secs, us);
   now.format(str, "YYYY-MM-DD HH:mm:SS.xx");
}

int print_debug(int level, const char *fmt, ...) {
   if (level > debug)
      return 0;

   va_list args;
   QoreString buf;

   while (true) {
      va_start(args, fmt);
      int rc = buf.vsprintf(fmt, args);
      va_end(args);
      if (!rc)
	 break;
   }

   QoreString ts;
   get_timestamp(ts);

#ifdef QORE_SERIALIZE_DEBUGGING_OUTPUT
   AutoLocker al(debug_output_lock);
#endif
   int tid = (threads_initialized && is_valid_qore_thread()) ? gettid() : -1;
   fprintf(stderr, "%s: TID %d: %s", ts.getBuffer(), tid, buf.getBuffer());
   fflush(stderr);
   return 0;
}

void trace_function(int code, const char *funcname) {
   if (!qore_trace)
      return;

   QoreString ts;
   get_timestamp(ts);
   if (code == TRACE_IN)
      printe("%s: TID %d: %s entered\n", ts.getBuffer(), threads_initialized ? gettid() : 0, funcname);
   else
      printe("%s: TID %d: %s exited\n", ts.getBuffer(), threads_initialized ? gettid() : 0, funcname);
}

char *remove_trailing_newlines(char *str) {
   int i = strlen(str);
   while (i && (str[i - 1] == '\n'))
      str[--i] = '\0';
   return str;
}

char *remove_trailing_blanks(char *str) {
   int i = strlen(str);
   while (i && (str[--i] == ' '))
      str[i] = '\0';
   return str;
}

void parse_error(const char *fmt, ...) {
   printd(5, "parse_error(\"%s\", ...) called\n", fmt);

   QoreStringNode *desc = new QoreStringNode;
   while (true) {
      va_list args;
      va_start(args, fmt);
      int rc = desc->vsprintf(fmt, args);
      va_end(args);
      if (!rc)
	 break;
   }
   qore_program_private::makeParseException(getProgram(), desc);
}

void parse_error(const QoreProgramLocation& loc, const char *fmt, ...) {
   printd(5, "parse_error(\"%s\", ...) called\n", fmt);

   QoreStringNode *desc = new QoreStringNode;
   while (true) {
      va_list args;
      va_start(args, fmt);
      int rc = desc->vsprintf(fmt, args);
      va_end(args);
      if (!rc)
	 break;
   }
   qore_program_private::makeParseException(getProgram(), loc, desc);
}

void parseException(const QoreProgramLocation& loc, const char *err, QoreStringNode *desc) {
   printd(5, "parseException(%s, %s) called\n", err, desc->getBuffer());
   qore_program_private::makeParseException(getProgram(), loc, err, desc);
}

void parseException(const char *err, QoreStringNode *desc) {
   printd(5, "parseException(%s, %s) called\n", err, desc->getBuffer());
   qore_program_private::makeParseException(getProgram(), err, desc);
}

void parseException(const char *err, const char *fmt, ...) {
   QoreStringNode *desc = new QoreStringNode;
   while (true) {
      va_list args;
      va_start(args, fmt);
      int rc = desc->vsprintf(fmt, args);
      va_end(args);
      if (!rc)
	 break;
   }
   parseException(err, desc);
}

void parseException(const QoreProgramLocation& loc, const char *err, const char *fmt, ...) {
   QoreStringNode *desc = new QoreStringNode;
   while (true) {
      va_list args;
      va_start(args, fmt);
      int rc = desc->vsprintf(fmt, args);
      va_end(args);
      if (!rc)
         break;
   }
   parseException(loc, err, desc);
}

// returns 1 for success
static inline int tryIncludeDir(QoreString *dir, const char *file) {
   //printd(5, "tryIncludeDir(dir='%s', file='%s')\n", dir->getBuffer(), file);

   // make fully-justified path
   if (dir->strlen() && dir->getBuffer()[dir->strlen() - 1] != QORE_DIR_SEP)
      dir->concat(QORE_DIR_SEP);
   dir->concat(file);
   struct stat sb;
   //printd(5, "tryIncludeDir() trying \"%s\"\n", dir->getBuffer());
   return !stat(dir->getBuffer(), &sb);
}

// FIXME: this could be a lot more efficient
QoreString *findFileInPath(const char *file, const char *path) {
   // if path is empty, return null
   if (!path || !path[0])
      return 0;

   // duplicate string for invasive searches
   QoreString plist(path);
   char *idir = (char *)plist.getBuffer();
   //printd(5, "findFileInEnvPath() %s=%s\n", varname, idir);

   // try each directory
   while (char *p = strchr(idir, ':')) {
      if (p != idir) {
#if (defined _WIN32 || defined __WIN32__) && ! defined __CYGWIN__
	 // do not assume ':' separates paths on windows if it's the second character in a path
	 if (p == idir + 1) {
	    p = strchr(p + 1, ':');
	    if (!p)
	       break;
	 }
#endif
	 *p = '\0';
	 TempString str(new QoreString(idir));
	 if (tryIncludeDir(*str, file))
	    return str.release();
      }
      idir = p + 1;
   }

   // try last directory
   if (idir[0]) {
      TempString str(new QoreString(idir));
      if (tryIncludeDir(*str, file))
	 return str.release();
   }

   return 0;
}

// FIXME: this could be a lot more efficient
QoreString *findFileInEnvPath(const char *file, const char *varname) {
   //printd(5, "findFileInEnvPath(file=%s var=%s)\n", file, varname);

   // if the file is an absolute path, then return it
   if (file[0] == QORE_DIR_SEP)
      return new QoreString(file);

   // get path from environment
   QoreString str;
   if (SysEnv.get(varname, str))
      return 0;

   return findFileInPath(file, str.getBuffer());
}
