---
layout: post
status: publish
published: true
title: Codificaci&oacute;n de caracteres en python 2.X
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1762
wordpress_url: http://www.josedomingo.org/pledin/?p=1762
date: '2017-02-21 16:17:44 +0000'
date_gmt: '2017-02-21 15:17:44 +0000'
categories:
- General
tags:
- Programaci&oacute;n
- Python
comments: []
---
<p style="text-align: justify;">
  <a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2016/11/bart-simpson-utf8.gif"><img class="aligncenter size-full wp-image-1763" src="https://www.josedomingo.org/pledin/wp-content/uploads/2016/11/bart-simpson-utf8.gif" alt="bart-simpson-utf8" width="657" height="352" /></a></p>
<p style="text-align: justify;">
  Cuando mis alumnos se enfrentan a realizar su proyecto de fin de curso creando una aplicaci&oacute;n web en python casi siempre se encuentran con la problem&aacute;tica de las diferentes codificaciones con las que trabaja python. Normalmente trabajan con variables locales de tipo cadena que est&aacute;n codificada en <strong>utf-8</strong>, sin embargo cuando leen datos que provienen de una API web se puede dar el caso que la codificaci&oacute;n sea <strong>unicode</strong>. En estos casos siempre les cuesta mucho trabajo tratar con los caracteres no ingleses codificados de diferente forma.</p>
<p style="text-align: justify;">
  En estos d&iacute;as estoy desarrollando una aplicaci&oacute;n web y me estoy encontrado con el mismo problema. Por lo tanto el objetivo de escribir esta entrada en el blog es hacer un resumen de c&oacute;mo python gestiona las diferentes codificaciones y que sirva como material de apoyo para la realizaci&oacute;n de los proyectos de mis alumnos.</p>
<h2>Codificaciones de caracteres</h2>
<p style="text-align: justify;">
  Entendemos un car&aacute;cter como el componente m&aacute;s peque&ntilde;o que puede formar un texto. Aunque muchos caracteres son iguales en los distintos idiomas, hay caracteres espec&iacute;ficos para cada alfabeto, que tienen graf&iacute;as diferentes. Evidentemente para guardar en un ordenador cada uno de los caracteres es necesario asignar a cada uno un n&uacute;mero que lo identifique, y dependiendo del sistema que utilicemos para asignar estos "c&oacute;digos" nacen las distintas codificaciones de caracteres.</p>
<p style="text-align: justify;">
  En los principios de la inform&aacute;tica los ordenadores se dise&ntilde;aron para utilizar s&oacute;lo caracteres ingleses, por lo tanto se cre&oacute; una codificaci&oacute;n de caracteres, llamada <strong>ascii</strong> (<em>American Standard Code for Information Interchange</em>) que utiliza 7 bits para codificar los 128 caracteres necesarios en el alfabeto ingl&eacute;s. Por lo tanto con esta codificaci&oacute;n, es imposible representar caracteres espec&iacute;ficos de otros alfabetos, como por ejemplo, los caracteres acentuados.</p>
<p style="text-align: justify;">
  Posteriormente se extendi&oacute; esta codificaci&oacute;n para incluir caracteres no ingleses. Al utilizar 8 bits se pueden representar 256 caracteres. De esta forma para codificar el alfabeto latino aparece la codificaci&oacute;n ISO-8859-1 o Lat&iacute;n 1. Puedes ver las tablas de estos c&oacute;digos en la siguiente <a href="http://cs.stanford.edu/people/miles/iso8859.html">tabla</a>.<!--more--></p>
<h3>Unicode</h3>
<p style="text-align: justify;">
  En el momento en que la inform&aacute;tica evolucion&oacute; y los ordenadores se interconectaron, se demostr&oacute; que los c&oacute;digos anteriores son insuficientes, al existir en el mundo muchos idiomas con alfabetos y graf&iacute;as diferentes. Por lo tanto se crea la codificaci&oacute;n <strong>unicode</strong> que nos permite representar todos los caracteres de todos los alfabetos del mundo, en realidad permite representar m&aacute;s de un mill&oacute;n de caracteres, ya que utiliza 32 bits para su representaci&oacute;n, pero en la realidad s&oacute;lo se definen unos 110.000 caracteres.</p>
<p>Por lo tanto esa es una de sus limitaciones, que utiliza muchos bytes para la representaci&oacute;n, cuando normalmente vamos a utilizar un conjunto peque&ntilde;os de caracteres. De este modo, aunque existen c&oacute;digos que utilizan 32 bits (utf-32) y que utilizan 16 bits (utf-16) el sistema de codificaci&oacute;n que m&aacute;s se utiliza es el</p>
<p><strong>utf-8</strong>. Aqu&iacute; tienes un enlace a la tabla de <a href="http://unicode-table.com/es/">c&oacute;digos unicode</a>.</p>
<h3>utf-8</h3>
<p><strong>UTF-8</strong> es un sistema de codificaci&oacute;n de longitud variable para <strong>Unicode</strong>. Esto significa que los caracteres pueden utilizar diferente n&uacute;mero de bytes. Para los caracteres ASCII utiliza un &uacute;nico byte por car&aacute;cter. De hecho, utiliza exactamente los mismos bytes que ASCII por lo que los 128 primeros caracteres son indistinguibles. Los caracteres "latinos extendidos" como la &ntilde; o la &ouml; utilizan dos bytes. Los caracteres chinos utilizan tres bytes, y los caracteres m&aacute;s "raros'' utilizan cuatro. Por lo tanto la representaci&oacute;n de los caracteres espa&ntilde;oles que no son ASCII:</p>
<table id="id1" class="docutils" border="1">
<thead valign="bottom">
<tr class="row-odd">
<th class="head">
        char
      </th>
<th class="head">
        ANSI#
      </th>
<th class="head">
        Unicode
      </th>
<th class="head">
        UTF-8
      </th>
<th class="head">
        Latin 1
      </th>
<th class="head">
        nombre
      </th>
</tr>
</thead>
<tbody valign="top">
<tr class="row-even">
<td>
        &iexcl;
      </td>
<td>
        161
      </td>
<td>
        u&rsquo;\xa1&rsquo;
      </td>
<td>
        \xc2\xa1
      </td>
<td>
        \xa1
      </td>
<td>
        inverted exclamation mark
      </td>
</tr>
<tr class="row-odd">
<td>
        &iquest;
      </td>
<td>
        191
      </td>
<td>
        u&rsquo;\xbf&rsquo;
      </td>
<td>
        \xc2\xbf
      </td>
<td>
        \xbf
      </td>
<td>
        inverted question mark
      </td>
</tr>
<tr class="row-even">
<td>
        &Aacute;
      </td>
<td>
        193
      </td>
<td>
        u&rsquo;\xc1&rsquo;
      </td>
<td>
        \xc3\x81
      </td>
<td>
        \xc1
      </td>
<td>
        Latin capital a with acute
      </td>
</tr>
<tr class="row-odd">
<td>
        &Eacute;
      </td>
<td>
        201
      </td>
<td>
        u&rsquo;\xc9&rsquo;
      </td>
<td>
        \xc3\x89
      </td>
<td>
        \xc9
      </td>
<td>
        Latin capital e with acute
      </td>
</tr>
<tr class="row-even">
<td>
        &Iacute;
      </td>
<td>
        205
      </td>
<td>
        u&rsquo;\xcd&rsquo;
      </td>
<td>
        \xc3\x8d
      </td>
<td>
        \xcd
      </td>
<td>
        Latin capital i with acute
      </td>
</tr>
<tr class="row-odd">
<td>
        &Ntilde;
      </td>
<td>
        209
      </td>
<td>
        u&rsquo;\xd1&rsquo;
      </td>
<td>
        \xc3\x91
      </td>
<td>
        \xd1
      </td>
<td>
        Latin capital n with tilde
      </td>
</tr>
<tr class="row-even">
<td>
        &Oacute;
      </td>
<td>
        191
      </td>
<td>
        u&rsquo;\xbf&rsquo;
      </td>
<td>
        \xc3\x93
      </td>
<td>
        \xbf
      </td>
<td>
        Latin capital o with acute
      </td>
</tr>
<tr class="row-odd">
<td>
        &Uacute;
      </td>
<td>
        218
      </td>
<td>
        u&rsquo;\xda&rsquo;
      </td>
<td>
        \xc3\x9a
      </td>
<td>
        \xda
      </td>
<td>
        Latin capital u with acute
      </td>
</tr>
<tr class="row-even">
<td>
        &Uuml;
      </td>
<td>
        220
      </td>
<td>
        u&rsquo;\xdc&rsquo;
      </td>
<td>
        \xc3\x9c
      </td>
<td>
        \xdc
      </td>
<td>
        Latin capital u with diaeresis
      </td>
</tr>
<tr class="row-odd">
<td>
        &aacute;
      </td>
<td>
        225
      </td>
<td>
        u&rsquo;\xe1&rsquo;
      </td>
<td>
        \xc3\xa1
      </td>
<td>
        \xe1
      </td>
<td>
        Latin small a with acute
      </td>
</tr>
<tr class="row-even">
<td>
        &eacute;
      </td>
<td>
        233
      </td>
<td>
        u&rsquo;\xe9&rsquo;
      </td>
<td>
        \xc3\xa9
      </td>
<td>
        \xe9
      </td>
<td>
        Latin small e with acute
      </td>
</tr>
<tr class="row-odd">
<td>
        &iacute;
      </td>
<td>
        237
      </td>
<td>
        u&rsquo;\xed&rsquo;
      </td>
<td>
        \xc3\xad
      </td>
<td>
        \xed
      </td>
<td>
        Latin small i with acute
      </td>
</tr>
<tr class="row-even">
<td>
        &ntilde;
      </td>
<td>
        241
      </td>
<td>
        u&rsquo;\xf1&rsquo;
      </td>
<td>
        \xc3\xb1
      </td>
<td>
        \xf1
      </td>
<td>
        Latin small n with tilde
      </td>
</tr>
<tr class="row-odd">
<td>
        &oacute;
      </td>
<td>
        243
      </td>
<td>
        u&rsquo;\xf3&rsquo;
      </td>
<td>
        \xc3\xb3
      </td>
<td>
        \xf3
      </td>
<td>
        Latin small o with acute
      </td>
</tr>
<tr class="row-even">
<td>
        &uacute;
      </td>
<td>
        250
      </td>
<td>
        u&rsquo;\xfa&rsquo;
      </td>
<td>
        \xc3\xba
      </td>
<td>
        \xfa
      </td>
<td>
        Latin small u with acute
      </td>
</tr>
<tr class="row-odd">
<td>
        &uuml;
      </td>
<td>
        252
      </td>
<td>
        u&rsquo;\xfc&rsquo;
      </td>
<td>
        \xc3\xbc
      </td>
<td>
        \xfc
      </td>
<td>
        Latin small u with diaeresis
      </td>
</tr>
</tbody>
</table>
<h2>&iquest;C&oacute;mo trabaja python 2 con los distintos sistemas de codificaci&oacute;n? Vamos a entrar en materia: aunque podemos trabajar con distintas codificaciones, Python hace un procesamiento interno de los caracteres codific&aacute;ndolo con</h2>
<p><strong>Unicode</strong> y luego convierte la salida a otros formatos, lo m&aacute;s habitual a <strong>utf-8</strong>. Por lo tanto el flujo de trabajo que realiza python en el tratamiento de caracteres es el siguiente: <img src="http://www.nltk.org/images/unicode.png" alt="" /> Es decir, la cadena se decodifica a <strong>Unicode</strong>, se hace el tratamiento interno necesario, y posterior se codifica a la codificaci&oacute;n que necesitemos. Veamos algunos ejemplos: <strong>1) Cuando creamos una cadena de caracteres (type str) por defecto la codificaci&oacute;n es utf-8.</strong></p>
<pre>>>> cad="jos&eacute;"
>>> type (cad)
<type 'str'>
</pre>
<p>Si comprobamos lo que se ha guardado realmente:</p>
<pre>>>> cad
'jos\xc3\xa9'
</pre>
<p>Por lo tanto si vemos que longitud tiene la cadena:</p>
<pre>>>> print len(cad)
5
</pre>
<p>Como ve&iacute;amos en la tabla anterior el car&aacute;cter</p>
<p><strong>&eacute;</strong> se representa en** utf-8** con dos caracteres: <strong>\xc3\xa9</strong>. Si enviamos la cadena a la salida est&aacute;ndar, python es capaz de mostrarla de forma adecuada:</p>
<pre>>>> print cad
jos&eacute;
</pre>
<p>Y podemos, de esta manera imprimir el car&aacute;cter</p>
<p><strong>&eacute;</strong>, de la siguiente forma:</p>
<pre>>>> print '\xc3\xa9'
&eacute;
</pre>
<p><strong>2) Vamos a crear una cadena codificada con Unicode:</strong></p>
<pre>>>> cad_uni = u'jos&eacute;'
>>> type (cad_uni)
<type 'unicode'>
</pre>
<p>Hemos utilizado el car&aacute;cter</p>
<p><strong>u</strong> delante de la cadena para indicar la codificaci&oacute;n <strong>unicode</strong>. Adem&aacute;s la variable creada no es de tipo <strong>str</strong>, es de tipo <strong>unicode</strong>. Vemos realmente lo que tiene guardada la cadena:</p>
<pre>>>> cad_uni
u'jos\xe9'
</pre>
<p>En este caso, el car&aacute;cter</p>
<p><strong>&eacute;</strong> se codifica con un s&oacute;lo car&aacute;cter <strong>/xe9</strong>. Podemos comprobar que en este caso la funci&oacute;n <code>len</code> funciona de forma adecuada y que python tambi&eacute;n es capaz de representar de forma adecuada la cadena con <code>print</code>:</p>
<pre>>>> len (cad_uni)
4
>>> print cad_uni
jos&eacute;
</pre>
<p>Y por &uacute;ltimo si queremos imprimir el car&aacute;cter</p>
<p><strong>&eacute;</strong> en <strong>unicode</strong>:</p>
<pre>>>> print u'\xe9'
&eacute;
</pre>
<p><strong>3) Comparaci&oacute;n de cadenas de caracteres con distintas codificaciones:</strong> Si tenemos dos cadenas con codificaci&oacute;n distintas, aunque hayamos guardado el mismo valor, no son iguales:</p>
<pre>>>> cad == cad_uni
__main__:1: UnicodeWarning: Unicode equal comparison failed to convert both arguments to Unicode - interpreting them as being unequal
False
</pre>
<p>Por lo tanto tenemos que convertir una de las cadenas al otro c&oacute;digo.</p>
<ul>
<li>O convertimos de <strong>unicode</strong> a <strong>utf8</strong> (<strong>codificamos</strong>):</li>
</ul>
<pre>>>> cad==cad_uni.encode("utf8")
True
</pre>
<ul>
<li>O convertimos de <strong>utf8</strong> a <strong>unicode</strong> (<strong>descodificamos</strong>):</li>
</ul>
<pre>>>> cad.decode("utf8")==cad_uni
True
</pre>
<p>Otra forma de descodificar es utilizar la funci&oacute;n</p>
<p><code>unicode()</code>:</p>
<pre>>>> unicode(cad,"utf8")==cad_uni
True
</pre>
<p><strong>4) Podemos intentar codificar una cadena unicode a un c&oacute;digo ascii.</strong> En este caso si tenemos alg&uacute;n car&aacute;cter que no est&eacute; codificado en la tabla <strong>ascii</strong> (128 caracteres), nos dar&aacute; un error:</p>
<pre>>>> cad_uni.encode("ascii")
Traceback (most recent call last):
File "<stdin>", line 1, in <module>
UnicodeEncodeError: 'ascii' codec can't encode character u'\xe9' in position 3: ordinal not in range(128)
</pre>
<p>Podemos usar otras dos modalidades, ignorar el error:</p>
<pre>>>> cad_uni.encode("ascii",errors='ignore')
'jos'
</pre>
<p>O reemplazar el car&aacute;cter que no corresponde al c&oacute;digo</p>
<p>** ascii** con el car&aacute;cter "<em>reemplazo</em>" de <strong>unicode</strong> (U+FFFFD).</p>
<pre>>>> cad_uni.encode("ascii",errors='replace')
'jos?'
</pre>
<p><strong>5) &iquest;Qu&eacute; m&eacute;todos tiene la clase unicode?</strong> Tiene los mismos que la clase <strong>str</strong>, m&aacute;s dos nuvos m&eacute;todos: <code>isdecimal()</code> y <code>isnumeric()</code>.</p>
<pre>cad_uni.capitalize&nbsp; cad_uni.islower&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.rpartition
cad_uni.center&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.isnumeric&nbsp;&nbsp; cad_uni.rsplit
cad_uni.count&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.isspace&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.rstrip
cad_uni.decode&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.istitle&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.split
cad_uni.encode&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.isupper&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.splitlines
cad_uni.endswith&nbsp;&nbsp;&nbsp; cad_uni.join&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.startswith
cad_uni.expandtabs&nbsp; cad_uni.ljust&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.strip
cad_uni.find&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.lower&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.swapcase
cad_uni.format&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.lstrip&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.title
cad_uni.index&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.partition&nbsp;&nbsp; cad_uni.translate
cad_uni.isalnum&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.replace&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.upper
cad_uni.isalpha&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.rfind&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.zfill
cad_uni.isdecimal&nbsp;&nbsp; cad_uni.rindex
cad_uni.isdigit&nbsp;&nbsp;&nbsp;&nbsp; cad_uni.rjust
</pre>
<p>Veamos que ocurre con el m&eacute;todo</p>
<p><code>isnumeric()</code>:</p>
<pre>>>> cad.isnumeric()
Traceback (most recent call last):
File "<stdin>", line 1, in <module>
AttributeError: 'str' object has no attribute 'isnumeric'

>>> cad_uni.isnumeric()
False
</pre>
<p>Las cadenas de tipo</p>
<p><strong>str</strong> no tienen dicho m&eacute;todo, mientras las <strong>unicode</strong> si. <strong>6) Las funciones ord() y unichar()</strong> Al igual que podemos utilizar la funci&oacute;n <code>chr()</code> para obtener el caracter correspondiente a un c&oacute;digo ascii.</p>
<pre>>>> print chr(97)
a
</pre>
<p>Podemos usar la funci&oacute;n</p>
<p><code>unichar()</code> para mostrar un car&aacute;cter a partir de un c&oacute;digo <strong>unicode</strong>. La funci&oacute;n <code>ord()</code> nos devuelve el c&oacute;digo <strong>unicode</strong> a partir de un caracter.</p>
<pre>>>> cad_uni=u'&ntilde;'
>>> ord(cad_uni)
241

>>> unichr(241)
u'\xf1'
>>> print unichr(241)
&ntilde;
</pre>
<h2>Conclusi&oacute;n En esta entrada hemos abordado c&oacute;mo trabaja python2 con las distintas codificaciones de caracteres. Lo he escrito pensando en mis alumnos del m&oacute;dulo de "Lenguaje de marcas". Si hay que recordar que en python3 la clase string est&aacute; codificada con Unicode por lo que el tratamiento de la codificaci&oacute;n cambia radicalmente. Por lo tanto en una pr&oacute;xima entrada tratare la codificaci&oacute;n de caracteres en python3.</h2>
