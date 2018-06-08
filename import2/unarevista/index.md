---
layout: page
status: publish
published: true
title: Revistas Inform&aacute;ticas Libres
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1093
wordpress_url: http://www.josedomingo.org/pledin/?page_id=1093
date: '2014-11-30 19:33:16 +0000'
date_gmt: '2014-11-30 18:33:16 +0000'
categories: []
tags: []
comments: []
---
<p>[insert_php]<br />
$base="https://dl.dropboxusercontent.com/u/50678558/Revistas/";<br />
$d=$_GET["id"];<br />
$rev=(string)$d;<br />
if(strlen($rev)==1) $rev="0".$rev;<br />
$lines = file($base.$rev."/info.txt");<br />
echo '<br />
<h1><a href="http://www.josedomingo.org/pledin/revistas">Revistas Inform&aacute;ticas</a></h1>
<p>';<br />
echo '<br />
<h2>'.$lines[0].'</h2>
<p>';<br />
echo '<a href="'.trim($lines[1]).'">P&aacute;gina web</a>';<br />
array_splice($lines, 0, 2);<br />
$lines=array_reverse($lines);<br />
$cont2=1;</p>
<p>echo '<br />
<table width="100%" border="0">
<tbody>';<br />
echo '<br />
<tr>';<br />
foreach ($lines as $line_num => $line) {<br />
	$dimg=$base.$rev.'/'.(count($lines)-$cont2+1).'.jpg';<br />
	$dnum=$base.$rev.'/'.(count($lines)-$cont2+1).'.pdf';<br />
	echo '
<td width="25%" valign="top"><a href="'.$dnum.'"><img src="'.$dimg.'" alt="'.$cont.'" width="100px" height="150px" border="0" hspace="0" vspace="0" /></a><br />'.$line.'</p>
</td>
<p>';<br />
	if($cont2%4==0) echo '</tr>
<tr>';<br />
	$cont2++;<br />
}<br />
echo '</tr>
</tbody>
</table>
<p>';</p>
<p>[/insert_php]</p>
