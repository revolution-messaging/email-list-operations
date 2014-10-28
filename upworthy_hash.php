<?php
if(!defined('DS')) define('DS', DIRECTORY_SEPARATOR);
require_once(dirname(__FILE__).DS.'init.php');

// This is the example text you should send in your email to Upworthy
?><html>
<head>
	<title>Care2 Hashing</title>
</head>
<body>
	<h2>Care2 Hashing</h2>
	<p>Here's the samples:</p>

	<p>someone@someTHing.com<br />
	someone@something.org<br />
	someone@something.net</p>

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
