<?php

$list = ""; // put the list here with CRLF line-endings.

$listex = explode("\r\n", $list);
$salt = 'c2sl4cl';

// This is the example text you should send in your email to Care2
?>
Here's the samples:

someone@someTHing.com
someone@something.org
someone@something.net

<?php
// This is the list with CRLF line-endings that you should send as a separate txt file.
echo sha1($salt.'someone@something.com')."\r\n";
echo sha1($salt.'someone@something.org')."\r\n";
echo sha1($salt.'someone@something.net')."\r\n";

echo "\r\n\r\n\r\n";

$fp = fopen('/Users/walker/Sites/list_match.csv', 'w');
foreach($listex as $email) {
	fwrite($fp, sha1($salt.strtolower(trim($email)))."\r\n");
}
fclose($fp);
