#!/usr/bin/env qore
# -*- mode: qore; indent-tabs-mode: nil -*-

%new-style
%enable-all-warnings
%require-types
%strict-args

class FtpServer {
    private {
        Socket s();
        Counter cnt();
        bool quit;
        int verbose;
        hash broken;
        bool get_empty;

        *string pwd;

        const PollInterval = 250ms;
    }

    constructor(int port, int verbose = 0, string address = "localhost") {
        self.verbose = verbose;
        s.bindINET(address, port.toString(), True);
        if (s.listen()) {
            throw "FTPSERVER-ERROR", strerror();
        }
        if (verbose > 1) {
            printf("FTP server bound and listening on %s:%d\n", address, s.getSocketInfo().port);
        }
        cnt.inc();
        background listener();
    }

    shutdown() {
        quit = True;
        cnt.waitForZero();
    }

    private listener() {
        on_exit cnt.dec();

        while (!quit) {
            *Socket ns = s.accept(PollInterval);
            if (ns) {
                cnt.inc();
                background connectionThread(ns);
            }
        }
    }

    private ftpSend(Socket ns, int code, string msg) {
        string str = sprintf("%d %s\r\n", code, vsprintf(msg, argv));
        if (verbose > 2)
            printf("FTP > %s", str);
        ns.send(str);
    }

    private string ftpGetCommand(Socket ns) {
        string str;
        while (True) {
            if (quit)
                return "";
            try {
                string c = ns.recv(1, PollInterval);
                str += c;
                if (c == "\n")
                    break;
            }
            catch (hash ex) {
                if (ex.err == "SOCKET-NOT-OPEN" || ex.err == "SOCKET-CLOSED")
                    return "";
                if (ex.err != "SOCKET-TIMEOUT")
                    rethrow;
            }
        }
        trim str;
        if (verbose > 2)
            printf("FTP < %s\n", str);
        return str;
    }

    private connectionThread(Socket ns) {
        on_exit cnt.dec();

        # output banner
        ftpSend(ns, 220, "Qore FtpClient Test Fake FTP Server");

        # wait for user
        while (True) {
            string cmd = ftpGetCommand(ns);
            if (quit)
                return;
            if (cmd !~ /^USER \w+/i) {
                ftpSend(ns, 530, "Please login with USER and PASS.");
                continue;
            }
            break;
        }
        ftpSend(ns, 331, "Please specify the password.");
        # wait for pass
        while (True) {
            string cmd = ftpGetCommand(ns);
            if (quit)
                return;
            if (cmd !~ /^PASS \w+/i) {
                ftpSend(ns, 530, "Please login with USER and PASS.");
                continue;
            }
            break;
        }
        ftpSend(ns, 230, "Login successful.");

        Socket data();
        Counter dcnt();
        bool dataquit;

        # port data connection pending
        hash<auto> port_info;

        while (True) {
            string cmd = ftpGetCommand(ns);
            if (quit || cmd == "")
                break;

            if (cmd =~ /^EPSV$/i) {
                remove port_info;
                termWaitData(data, dcnt, \dataquit);
                doEpsv(ns, \data, dcnt, \dataquit);
                continue;
            }

            if (cmd =~ /^PASV$/i) {
                remove port_info;
                termWaitData(data, dcnt, \dataquit);
                doPasv(ns, \data, dcnt, \dataquit);
                continue;
            }

            if (cmd =~ /^PORT .+$/i) {
                string arg = (cmd =~ x/PORT (.+)$/i)[0];
                termWaitData(data, dcnt, \dataquit);
                doPort(ns, arg, \port_info);
                continue;
            }

            if (cmd =~ /^QUIT$/i) {
                ftpSend(ns, 221, "Goodbye.");
                break;
            }

            if (cmd =~ /^TYPE /i) {
                *string arg = (cmd =~ x/^TYPE (.*)$/i)[0];
                if (arg == "A")
                    ftpSend(ns, 200, "Switching to Text mode.");
                else if (arg != "I")
                    ftpSend(ns, 500, "Unrecognised TYPE command %y.", arg);
                else
                    ftpSend(ns, 200, "Switching to Binary mode.");
                continue;
            }

            if (cmd =~ /^STOR .+$/i) {
                string file = (cmd =~ x/^STOR (.+)$/i)[0];
                if (!data.isOpen()) {
                    if (port_info) {
                        if (broken.PORT) {
                            continue;
                        }
                        # connect to the remote socket
                        data.connectINET(port_info.ip, port_info.port, 10s);
                    } else {
                        ftpSend(ns, 425, "Use EPASV first.");
                        continue;
                    }
                }
                dcnt.waitForZero();
                ftpSend(ns, 150, "Opening BINARY mode data connection for %s.", file);

                if (doBroken("stor", data))
                    break;

                # read all data from data connection until closed
                while (data.isOpen()) {
                    data.recv(0, 20s);
                }
                data.close();
                ftpSend(ns, 226, "Transfer completed.");
                continue;
            }

            if (cmd =~ /^RETR .+$/i) {
                string file = (cmd =~ x/^RETR (.+)$/i)[0];
                if (!data.isOpen()) {
                    ftpSend(ns, 425, "Use EPASV first.");
                    continue;
                }
                dcnt.waitForZero();
                ftpSend(ns, 150, "Opening BINARY mode data connection for %s.", file);

                if (doBroken("retr", data))
                    break;

                #printf("get: empty %y\n", get_empty);
                if (!get_empty) {
                    # write a bunch of data and then exit
                    for (int i = 0; i < 200; ++i)
                        data.send("testing abcdefghijklmnopqrstuvwxyz 0123456789\n");
                }

                data.close();
                ftpSend(ns, 226, "Transfer completed.");
                continue;
            }

            if (cmd =~ /^NLST/i) {
                if (!data.isOpen()) {
                    ftpSend(ns, 425, "Use EPASV first.");
                    continue;
                }
                dcnt.waitForZero();
                ftpSend(ns, 150, "Here comes the directory listing.");

                if (doBroken("nlst", data))
                    break;

                #printf("get: empty %y\n", get_empty);
                if (!get_empty && !pwd) {
                    # write a bunch of data and then exit
                    for (int i = 0; i < 200; ++i)
                        data.send(sprintf("drwxr-xr-x    2 0        0            4096 Jul 08  2016 pub_%s\n", get_random_string(5)));
                } else if (pwd) {
                    Dir dir();
                    dir.chdir(pwd);
                    auto files = dir.list(".*", 0, True);
                    string result;
                    map result += $1.name + "\r\n", files;
                    data.send(result);
                }

                data.close();
                ftpSend(ns, 226, "Directory send OK.");
                continue;
            }

            if (cmd =~ /^PWD/i) {
                ftpSend(ns, 257, pwd);
                continue;
            }

            if (cmd =~ /^CWD/i) {
                string path = (cmd =~ x/^CWD (.+)$/i)[0];
                pwd = path;
                ftpSend(ns, 250, "Okay.");
                continue;
            }

            if (cmd =~ /^MDTM/i) {
                string file_name = (cmd =~ x/^MDTM (.+)$/i)[0];
                # printf("FILE_NAME: %y\n", file_name);

                Dir dir();
                dir.chdir(pwd);
                auto file = dir.list(file_name, 0, True)[0];

                ftpSend(ns, 250, file.mtime.toString());
                continue;
            }

            if (cmd =~ /^SIZE/i) {
                string file_name = (cmd =~ x/^SIZE (.+)$/i)[0];
                # printf("FILE_NAME: %y\n", file_name);

                Dir dir();
                dir.chdir(pwd);
                auto file = dir.list(file_name, 0, True)[0];

                ftpSend(ns, 250, file.size.toString());
                continue;
            }

            ftpSend(ns, 500, "Unknown command: " + cmd);
        }

        # ensure any data connections terminate
        termWaitData(data, dcnt, \dataquit);
    }

    private bool doBroken(string cmd, Socket data) {
        if (broken{cmd}) {
            usleep(broken{cmd});
            data.close();
            return True;
        }
        return False;
    }

    private termWaitData(Socket data, Counter dcnt, reference dataquit) {
        if (data.isOpen()) {
            dataquit = True;
            dcnt.waitForZero();
            dataquit = False;
        }
    }

    private doEpsv(Socket ns, reference data, Counter dcnt, reference dataquit) {
        # get random port
        int dport;
        # workaround for issue #1259 (https://github.com/qorelanguage/qore/issues/1259)
        while (True) {
            dport = 10000 + (rand() % 40000);
            try {
                data.bindINET("localhost", dport, True, AF_INET);
                break;
            }
            catch (hash ex) {
                continue;
            }
        }
        data.listen();
        ftpSend(ns, 229, "Entering Extended Passive Mode (|||%d|)", dport);

        dcnt.inc();
        background doDataConnection(\data, dcnt, \dataquit);
    }

    private doPasv(Socket ns, reference data, Counter dcnt, reference dataquit) {
        # bind on random port; NOTE: PASV only supports IPv4, so we can't bind on "localhost",
        # which might resolve to an IPv6 address
        data.bindINET("127.0.0.1", 0, True);
        data.listen();
        int dport = data.getSocketInfo().port;
        {
            int dport_high = dport >> 8;
            int dport_low = (dport & 0xff);
            ftpSend(ns, 227, "Entering Passive Mode (127,0,0,1,%d,%d)", dport_high, dport_low);
        }

        dcnt.inc();
        background doDataConnection(\data, dcnt, \dataquit);
    }

    private doPort(Socket ns, string arg, reference<hash> port_info) {
        # NOTE: PORT only supports IPv4; EPRT (RFC 2428: https://tools.ietf.org/html/rfc2428)
        # adds support for IPv6
        list<string> l = arg.split(",");
        port_info = {
            "ip": l[0..3].join("."),
            "port": (l[4] << 8) + l[5].toInt(),
        };

        #printf("arg: %y ip: %y port: %y\n", arg, ip, port);

        # send reply immediately
        ftpSend(ns, 200, "PORT command successful");
    }

    private doDataConnection(reference data, Counter dcnt, reference dataquit) {
        on_exit dcnt.dec();

        while (!dataquit) {
            *Socket ns = data.accept(PollInterval);
            if (ns) {
                data = ns;
                return;
            }
        }
    }

    int getPort() {
        return s.getSocketInfo().port;
    }

    setBroken(string cmd, timeout v) {
        broken{cmd} = v;
    }

    clearBroken() {
        delete broken;
    }

    setGetEmpty(bool v = True) {
        get_empty = v;
    }

    setPwd(string pwd) {
        self.pwd = pwd;
    }
}