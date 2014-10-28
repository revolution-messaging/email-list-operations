<?php

$list = ""; // put the CSV list here.

$listex = explode("\n", $list);

// This is the example text you should send in your email to Upworthy
?>
Here's the samples:

someone@someTHing.com
someone@something.org
someone@something.net

<?php
// This is the list with CRLF line-endings that you should send as a separate CSV file.
echo md5(strtolower('someone@something.com'))."\r\n";
echo md5(strtolower('someone@something.org'))."\r\n";
echo md5(strtolower('someone@something.net'))."\r\n";

echo "\r\n\r\n\r\n";

$fp = fopen('/Users/walker/Sites/list_match.csv', 'w');
foreach($listex as $email) {
	fwrite($fp, md5(strtolower(trim($email)))."\r\n");
}
fclose($fp);
