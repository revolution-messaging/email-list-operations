<?php
if(!defined('DS')) define('DS', DIRECTORY_SEPARATOR);
require_once(dirname(__FILE__).DS.'init.php');

// This is the example text you should send in your email to Upworthy
?><html>
<head>
	<title>Upworthy Hashing</title>
</head>
<body>
	<h2>Upworthy Hashing</h2>
	
	<p>Most org/sites doing matching want to see samples to know you "did it right". You can send them the below.</p>
	
	<p>Here's the samples:</p>

	<p>someone@someTHing.com<br />
	someone@something.org<br />
	someone@something.net</p>

<?php
// This is the list with CRLF line-endings that you should send as a separate CSV file.
echo '<p>'.md5(strtolower('someone@something.com'))."<br />\r\n";
echo md5(strtolower('someone@something.org'))."<br />\r\n";
echo md5(strtolower('someone@something.net'))."</p>\r\n";

echo "\r\n\r\n\r\n";

	$csvFile = new Keboola\Csv\CsvFile(dirname(__FILE__).DS.'list_to_hash.csv');
	$fp = fopen(dirname(__FILE__).DS.'hashed_list.csv', 'w');

	echo '<p>';
	foreach($csvFile as $index => $item) {
		fwrite($fp, md5(strtolower(trim($item[0])))."\r\n");
		echo '.'
		ob_flush();
	}
	fclose($fp);
	echo '</p>
			<p>Done.</p>
		</body>
</html>';
exit();