# -*- mode: qore; indent-tabs-mode: nil -*-
# Qore AbstractConnection class definition

/*  AbstractConnection.qc Copyright 2016 - 2019 Qore Technologies, s.r.o.

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
*/

%require-types
%enable-all-warnings
%new-style
%strict-args

#! the ConnectionProvider namespace. All classes used in the ConnectionProvider module should be inside this namespace
public namespace ConnectionProvider {
    #! abstract base class for connections
    /** this class can be specialized to provide for user-defined connection types
     */
    public class AbstractConnection {
        public {
            #! connection name
            string name;

            #! connection description
            string desc;

            #! connection URL (potentially with password info)
            string url;

            #! "safe" URL (password information removed)
            string safe_url;

            #! original connection options
            *hash orig_opts;

            #! connection options
            *hash opts;

            #! broken down URL hash (as returned by @ref Qore::parse_url())
            hash urlh;

            #! date/time of last check/ping
            date last_check;

            #! status string; in case of a connection error this string will be the error string
            string status = "not checked";

            #! connection status flag; set by monitoring or explicit pings/connections
            bool up = False;

            #! monitoring flag
            bool monitor;

            #! date/time of last update
            date updated;

            #! set to @ref Qore::True "True" for loopback connections
            bool loopback = False;

            #! optional code for default post-processing of objects created by getImpl(); must take the object created and the connection name as arguments
            static *code post_processing;

            #! enabled/disabled indicator flag
            bool enabled = True;

            #! locked/unlocked flag
            bool locked = False;
        }

        #! creates the AbstractConnection object
        /** @param n_name the name of the connection
            @param n_desc connection description
            @param n_url connection URL (potentially with password info)
            @param n_monitor monitoring flag
            @param n_opts connection options
            @param n_urlh broken down URL hash (as returned by @ref Qore::parse_url())
            @param n_safe_url "safe" URL (password information removed); if not set this will be set automatically by calling @ref getSafeUrl()
            @param n_enabled enabled/disabled flag
         */
        deprecated
        constructor(string n_name,
                    string n_desc,
                    string n_url,
                    bool n_monitor,
                    *hash n_opts,
                    hash n_urlh,
                    *string n_safe_url,
                    *bool n_enabled) {
            # remove "enabled" option from option hash, if any
            *bool opt_enabled = remove n_opts.enabled;
            hash<auto> attributes = {
                "monitor": n_monitor,
                "enabled": n_enabled ?? opt_enabled ?? True,
            };
            constructorInit(n_name, n_desc, n_url, attributes, n_opts ?? {});
        }

        #! creates the AbstractConnection object
        /** @param name the name of the connection
            @param description connection description
            @param url connection URL (potentially with password info)
            @param attributes various attributes. See below
            @param options connection options

            @par Attributes

            Attributes are special flags for given connection - stored as public
            attributes of the object instance.
            For now there are:
                - \c enabled, default \c True
                - \c monitor, default \c True
                - \c locked, default \c False
         */
        constructor(string name, string description, string url, hash attributes = {}, hash options = {}) {
            constructorInit(name, description, url, attributes, options);
        }

        private:internal constructorInit(string name, string description, string url, hash attributes, hash options) {
            # metadata
            self.name = name;
            self.desc = description;

            # url handling
            self.url = url;
            self.urlh = parseUrl(self.url);
            self.safe_url = getSafeUrl(self.urlh);

            # attributes to flags
            self.monitor = attributes.monitor ?? True;
            self.enabled = attributes.enabled ?? True;
            self.locked = attributes.locked ?? False;

            self.orig_opts = options;
            self.opts = validateOptions(options);
        }

        #! performs options validation in the constructor
        /** @param options a has with options from the constructor
            @return hash validated option hash

            This method can be overloaded in connections where are options
            created dynamically for example.
         */
        hash validateOptions(hash options) {
            options = getDefaultOptions() + options;
            if (options) {
                *hash<auto> oh = getOptions();
                foreach string opt in (keys options) {
                    if (!oh{opt})
                        throw "CONNECTION-ERROR", sprintf("connection %y (type %y url %y) has unknown option %y (known options: %y)", name, urlh.protocol, url, opt, oh.keys());
                }
            }
            return options;
        }

        #! Parse the URL to a hash
        /** @param url a string with url
            @return hash untyped, depends on the parsing method

            The base implementation calls @ref Qore::parse_url().

            Reimplement \c parseUrl() if your connection uses different URL schema.
            Like eg. Qore::Datasource connection string.
         */
        private hash parseUrl(string url) {
            return Qore::parse_url(url);
        }

        #! creates a "safe" URL string with password information removed
        /** @param urlh a parsed hash (as returned from parseUrl()
            @return string with safe URL

            This base/default implementation expects the \c urlh
            as returned by @ref Qore::parse_url())

            Public attribute \c safe_url is created from the \c url calling
            AbstractConnection::getSafeUrl(). Reimplement this method if your
            connection does not follow standard URL in form:
            @code
schema://user:pass@hostname:port/path
            @endcode
         */
        private string getSafeUrl(hash urlh) {
            string url = urlh.protocol + "://";
            if (urlh.username)
                url += urlh.username + "@";
            url += urlh.host;
            if (urlh.port)
                url += ":" + urlh.port;
            if (urlh.path && urlh.path != "/")
                url += urlh.path;
            return url;
        }

        #! returns a hash with the results of the ping operation
        /** @param throw_exception throw an exception if a connection error occurs

            @return a @ref PingInfo hash
         */
        hash<PingInfo> ping(bool throw_exception = False) {
            hash<PingInfo> rv(hash(self).("name", "desc", "opts"));
            rv.url = safe_url;

            last_check = now_us();

            if (throw_exception)
                return pingIntern(rv);

            try {
                return pingIntern(rv);
            } catch (hash<ExceptionInfo> ex) {
                return rv += {
                    "ok": False,
                    "info": sprintf("%s: %s", ex.err, ex.desc),
                };
            }
        }

        #! performs the ping by executing get(); returns a @ref PingInfo hash
        private hash<PingInfo> pingIntern(hash<PingInfo> rv) {
            date start = now_us();
            get();
            return rv += {
                "ok": True,
                "time": now_us() - start,
                "info": "OK",
            };
        }

        #! returns a @ref ConnectionInfo hash of information about the connection
        /** @param with_password determines if the password is returned or not

            @return a @ref ConnectionInfo hash of information about the connection
         */
        hash<ConnectionInfo> getInfo(bool with_password = False) {
            hash<ConnectionInfo> h = cast<hash<ConnectionInfo>>(self.("name", "desc", "url", "monitor", "last_check", "updated", "status", "up", "loopback", "enabled", "locked") + ("type": getType(), "url_hash": urlh));
            if (!with_password) {
                h.url = safe_url;
                delete h.url_hash.password;
            }
            h.opts = orig_opts;
            return h;
        }

        #! returns a @ref ConfigInfo hash of static configuration information about the connection
        /** @returns a @ref ConfigInfo hash of static configuration information about the connection
         */
        hash<ConfigInfo> getConfigHash() {
            return cast<hash<ConfigInfo>>(self.("name", "desc", "url", "opts"));
        }

        #! returns static / initialization options
        *hash getOptions() {
        }

        #! returns runtime options
        *hash getRuntimeOptions() {
        }

        #! returns default options
        *hash getDefaultOptions() {
        }

        #! returns options for saving the connection's configuration information
        *hash getRealOptions() {
            return orig_opts;
        }

        #! returns the underlying connection object
        /** calls @ref getImpl() to actually acquire the connection object
         */
        object get(bool connect = True, *hash rtopts) {
            if (!connect) {
                object o = getImpl(False, rtopts);
                if (post_processing)
                    post_processing(o, name);
                return o;
            }

            on_exit
                last_check = now_us();

            try {
                object o = getImpl(True, rtopts);
                if (post_processing)
                    post_processing(o, name);
                up = True;
                status = "OK";
                return o;
            } catch (hash<ExceptionInfo> ex) {
                status = sprintf("%s: %s", ex.err, ex.desc);
                up = False;
                rethrow;
            }
        }

        #! returns a @ref ConnectionProvider::ConnectionConstructorInfo "ConnectionConstructorInfo" hash for creating the connection object dynamically
        /** @return a @ref ConnectionProvider::ConnectionConstructorInfo "ConnectionConstructorInfo" hash for creating the connection object dynamically

            @since ConnectionProvider 1.1
        */
        hash<ConnectionConstructorInfo> getConstructorInfo() {
            return getConstructorInfoImpl();
        }

        #! this method is called when parsing connection file definitions from text files when loading into the database
        /** reimplement this method in subclasses to parse the option hash as set from a text file if needed (for special option formats, etc)
        */
        parseTextOptions() {
        }

        #! this method must return the connection object corresponding to the object's configuration
        /** @param connect if @ref Qore::True "True" then the connection should be returned connected (and if possible a round-trip "ping" of the server should be made)
            @param rtopts if the object acquisition requires any runtime options, then these are passed here

            @return the connection object
        */
        private abstract object getImpl(bool connect = True, *hash rtopts);

        #! this method must return a @ref ConnectionProvider::ConnectionConstructorInfo "ConnectionConstructorInfo" hash for creating the connection object dynamically
        /** @return a @ref ConnectionProvider::ConnectionConstructorInfo "ConnectionConstructorInfo" hash for creating the connection object dynamically

            @since ConnectionProvider 1.1
        */
        private abstract hash<ConnectionConstructorInfo> getConstructorInfoImpl();

        #! returns the string type name for the connection object
        abstract string getType();
    }
} # ConnectionProvider namespace