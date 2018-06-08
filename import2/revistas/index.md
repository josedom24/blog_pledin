---
layout: page
status: publish
published: true
title: Revistas inform&aacute;ticas libres
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1087
wordpress_url: http://www.josedomingo.org/pledin/?page_id=1087
date: '2014-11-30 20:14:22 +0000'
date_gmt: '2014-11-30 19:14:22 +0000'
categories: []
tags: []
comments: []
---
<p>[insert_php]<br />
$base="https://dl.dropboxusercontent.com/u/50678558/Revistas/";<br />
$revistas = file($base."/lista.txt");<br />
echo'<br />
<table border="0">';<br />
echo'<br />
<tbody>';<br />
foreach ($revistas as $i)<br />
{<br />
	$rev=$i;<br />
	$rev = substr($rev, 0, -1);<br />
	if(strlen($rev)==1) $rev="0".$rev;<br />
	$lines = file($base.$rev."/info.txt");<br />
	$nombre=$lines[0];<br />
	$url=trim($lines[1]);<br />
	array_splice($lines, 0, 2);<br />
	$cant_rev=count($lines);<br />
	$desc  = file($base.$rev."/desc.txt");<br />
	$desc=$desc[0];<br />
	$ult_publicacion=$lines[$cant_rev-1];<br />
    echo'<br />
<tr>';<br />
	echo '
<td width="20%"><img src="'.$base.$rev.'/'.$cant_rev.'.jpg" alt="0" width="100px" height="120px" border="0" hspace="0" vspace="0" /></td>
<p>';<br />
	echo'
<td width="80%">';<br />
	echo'<br />
<h1><a href="http://www.josedomingo.org/pledin/unarevista/?id='.$i.' ">'.$nombre.'</a></h1>
<p>';<br />
	echo'<a href="'.$url.'">P&aacute;gina Web</a><br />';<br />
	echo $desc;<br />
	echo '<strong>&Uacute;ltima publicaci&oacute;n:'.$ult_publicacion.'</strong></td>
<p>';<br />
}<br />
echo '</tr>
</tbody>
</table>
<p>';</p>
<p>[/insert_php]</p>
