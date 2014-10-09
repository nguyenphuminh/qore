#!/usr/bin/env qore 

%requires UnitTest

my UnitTest $t(True);

my string $tmp = $t.tmpLocation();
my string $file = $tmp + '/iso-8859-1.txt';
my string $str = "Öffentl. Körperschaft/\n\n";

my $f = new File("ISO-8859-1");
$f.open($file, O_WRONLY | O_CREAT);
$f.write($str);
$f.close();

my string $content = backquote('cat ' + $file);
$content = force_encoding($content, "iso-8859-1");
$t.cmp($content, $str, 'file content check');

unlink($file);
