---
id: 1762
title: Codificación de caracteres en python 2.X
date: 2017-02-21T16:17:44+00:00


guid: http://www.josedomingo.org/pledin/?p=1762
permalink: /2017/02/codificacion-de-caracteres-en-python2/


tags:
  - Programación
  - Python
---
<p style="text-align: justify;">
  <a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/11/bart-simpson-utf8.gif"><img class="aligncenter size-full wp-image-1763" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/11/bart-simpson-utf8.gif" alt="bart-simpson-utf8" width="657" height="352" /></a>
</p>

<p style="text-align: justify;">
  Cuando mis alumnos se enfrentan a realizar su proyecto de fin de curso creando una aplicación web en python casi siempre se encuentran con la problemática de las diferentes codificaciones con las que trabaja python. Normalmente trabajan con variables locales de tipo cadena que están codificada en <strong>utf-8</strong>, sin embargo cuando leen datos que provienen de una API web se puede dar el caso que la codificación sea <strong>unicode</strong>. En estos casos siempre les cuesta mucho trabajo tratar con los caracteres no ingleses codificados de diferente forma.
</p>

<p style="text-align: justify;">
  En estos días estoy desarrollando una aplicación web y me estoy encontrado con el mismo problema. Por lo tanto el objetivo de escribir esta entrada en el blog es hacer un resumen de cómo python gestiona las diferentes codificaciones y que sirva como material de apoyo para la realización de los proyectos de mis alumnos.
</p>

## Codificaciones de caracteres

<p style="text-align: justify;">
  Entendemos un carácter como el componente más pequeño que puede formar un texto. Aunque muchos caracteres son iguales en los distintos idiomas, hay caracteres específicos para cada alfabeto, que tienen grafías diferentes. Evidentemente para guardar en un ordenador cada uno de los caracteres es necesario asignar a cada uno un número que lo identifique, y dependiendo del sistema que utilicemos para asignar estos &#8220;códigos&#8221; nacen las distintas codificaciones de caracteres.
</p>

<p style="text-align: justify;">
  En los principios de la informática los ordenadores se diseñaron para utilizar sólo caracteres ingleses, por lo tanto se creó una codificación de caracteres, llamada <strong>ascii</strong> (<em>American Standard Code for Information Interchange</em>) que utiliza 7 bits para codificar los 128 caracteres necesarios en el alfabeto inglés. Por lo tanto con esta codificación, es imposible representar caracteres específicos de otros alfabetos, como por ejemplo, los caracteres acentuados.
</p>

<p style="text-align: justify;">
  Posteriormente se extendió esta codificación para incluir caracteres no ingleses. Al utilizar 8 bits se pueden representar 256 caracteres. De esta forma para codificar el alfabeto latino aparece la codificación ISO-8859-1 o Latín 1. Puedes ver las tablas de estos códigos en la siguiente <a href="http://cs.stanford.edu/people/miles/iso8859.html">tabla</a>.<!--more-->
</p>

### Unicode

<p style="text-align: justify;">
  En el momento en que la informática evolucionó y los ordenadores se interconectaron, se demostró que los códigos anteriores son insuficientes, al existir en el mundo muchos idiomas con alfabetos y grafías diferentes. Por lo tanto se crea la codificación <strong>unicode</strong> que nos permite representar todos los caracteres de todos los alfabetos del mundo, en realidad permite representar más de un millón de caracteres, ya que utiliza 32 bits para su representación, pero en la realidad sólo se definen unos 110.000 caracteres.
</p>

Por lo tanto esa es una de sus limitaciones, que utiliza muchos bytes para la representación, cuando normalmente vamos a utilizar un conjunto pequeños de caracteres. De este modo, aunque existen códigos que utilizan 32 bits (utf-32) y que utilizan 16 bits (utf-16) el sistema de codificación que más se utiliza es el

**utf-8**. Aquí tienes un enlace a la tabla de [códigos unicode](http://unicode-table.com/es/).

### utf-8

**UTF-8** es un sistema de codificación de longitud variable para **Unicode**. Esto significa que los caracteres pueden utilizar diferente número de bytes. Para los caracteres ASCII utiliza un único byte por carácter. De hecho, utiliza exactamente los mismos bytes que ASCII por lo que los 128 primeros caracteres son indistinguibles. Los caracteres &#8220;latinos extendidos&#8221; como la ñ o la ö utilizan dos bytes. Los caracteres chinos utilizan tres bytes, y los caracteres más &#8220;raros&#8221; utilizan cuatro. Por lo tanto la representación de los caracteres españoles que no son ASCII:

<table id="id1" class="docutils" border="1">
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
  
  <tr class="row-even">
    <td>
      ¡
    </td>
    
    <td>
      161
    </td>
    
    <td>
      u’\xa1’
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
      ¿
    </td>
    
    <td>
      191
    </td>
    
    <td>
      u’\xbf’
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
      Á
    </td>
    
    <td>
      193
    </td>
    
    <td>
      u’\xc1’
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
      É
    </td>
    
    <td>
      201
    </td>
    
    <td>
      u’\xc9’
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
      Í
    </td>
    
    <td>
      205
    </td>
    
    <td>
      u’\xcd’
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
      Ñ
    </td>
    
    <td>
      209
    </td>
    
    <td>
      u’\xd1’
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
      Ó
    </td>
    
    <td>
      191
    </td>
    
    <td>
      u’\xbf’
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
      Ú
    </td>
    
    <td>
      218
    </td>
    
    <td>
      u’\xda’
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
      Ü
    </td>
    
    <td>
      220
    </td>
    
    <td>
      u’\xdc’
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
      á
    </td>
    
    <td>
      225
    </td>
    
    <td>
      u’\xe1’
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
      é
    </td>
    
    <td>
      233
    </td>
    
    <td>
      u’\xe9’
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
      í
    </td>
    
    <td>
      237
    </td>
    
    <td>
      u’\xed’
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
      ñ
    </td>
    
    <td>
      241
    </td>
    
    <td>
      u’\xf1’
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
      ó
    </td>
    
    <td>
      243
    </td>
    
    <td>
      u’\xf3’
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
      ú
    </td>
    
    <td>
      250
    </td>
    
    <td>
      u’\xfa’
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
      ü
    </td>
    
    <td>
      252
    </td>
    
    <td>
      u’\xfc’
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
</table>

## ¿Cómo trabaja python 2 con los distintos sistemas de codificación? Vamos a entrar en materia: aunque podemos trabajar con distintas codificaciones, Python hace un procesamiento interno de los caracteres codificándolo con

**Unicode** y luego convierte la salida a otros formatos, lo más habitual a **utf-8**. Por lo tanto el flujo de trabajo que realiza python en el tratamiento de caracteres es el siguiente:  ![](http://www.nltk.org/images/unicode.png)Es decir, la cadena se decodifica a **Unicode**, se hace el tratamiento interno necesario, y posterior se codifica a la codificación que necesitemos. Veamos algunos ejemplos: **1) Cuando creamos una cadena de caracteres (type str) por defecto la codificación es utf-8.**

<pre>&gt;&gt;&gt; cad="josé"
&gt;&gt;&gt; type (cad)
&lt;type 'str'&gt;
</pre>

Si comprobamos lo que se ha guardado realmente:

<pre>&gt;&gt;&gt; cad
'jos\xc3\xa9'
</pre>

Por lo tanto si vemos que longitud tiene la cadena:

<pre>&gt;&gt;&gt; print len(cad)
5
</pre>

Como veíamos en la tabla anterior el carácter

**é** se representa en\*\* utf-8\*\* con dos caracteres: **\xc3\xa9**. Si enviamos la cadena a la salida estándar, python es capaz de mostrarla de forma adecuada:

<pre>&gt;&gt;&gt; print cad
josé
</pre>

Y podemos, de esta manera imprimir el carácter

**é**, de la siguiente forma:

<pre>&gt;&gt;&gt; print '\xc3\xa9'
é
</pre>

**2) Vamos a crear una cadena codificada con Unicode:**

<pre>&gt;&gt;&gt; cad_uni = u'josé'
&gt;&gt;&gt; type (cad_uni)
&lt;type 'unicode'&gt;
</pre>

Hemos utilizado el carácter

**u** delante de la cadena para indicar la codificación **unicode**. Además la variable creada no es de tipo **str**, es de tipo **unicode**. Vemos realmente lo que tiene guardada la cadena:

<pre>&gt;&gt;&gt; cad_uni
u'jos\xe9'
</pre>

En este caso, el carácter

**é** se codifica con un sólo carácter **/xe9**. Podemos comprobar que en este caso la función `len` funciona de forma adecuada y que python también es capaz de representar de forma adecuada la cadena con `print`:

<pre>&gt;&gt;&gt; len (cad_uni)
4
&gt;&gt;&gt; print cad_uni
josé
</pre>

Y por último si queremos imprimir el carácter

**é** en **unicode**:

<pre>&gt;&gt;&gt; print u'\xe9'
é
</pre>

**3) Comparación de cadenas de caracteres con distintas codificaciones:** Si tenemos dos cadenas con codificación distintas, aunque hayamos guardado el mismo valor, no son iguales:

<pre>&gt;&gt;&gt; cad == cad_uni
__main__:1: UnicodeWarning: Unicode equal comparison failed to convert both arguments to Unicode - interpreting them as being unequal
False
</pre>

Por lo tanto tenemos que convertir una de las cadenas al otro código.

  * O convertimos de **unicode** a **utf8** (**codificamos**):

<pre>&gt;&gt;&gt; cad==cad_uni.encode("utf8")
True
</pre>

  * O convertimos de **utf8** a **unicode** (**descodificamos**):

<pre>&gt;&gt;&gt; cad.decode("utf8")==cad_uni
True
</pre>

Otra forma de descodificar es utilizar la función

`unicode()`:

<pre>&gt;&gt;&gt; unicode(cad,"utf8")==cad_uni
True
</pre>

**4) Podemos intentar codificar una cadena unicode a un código ascii.** En este caso si tenemos algún carácter que no esté codificado en la tabla **ascii** (128 caracteres), nos dará un error:

<pre>&gt;&gt;&gt; cad_uni.encode("ascii")
Traceback (most recent call last):
File "&lt;stdin&gt;", line 1, in &lt;module&gt;
UnicodeEncodeError: 'ascii' codec can't encode character u'\xe9' in position 3: ordinal not in range(128)
</pre>

Podemos usar otras dos modalidades, ignorar el error:

<pre>&gt;&gt;&gt; cad_uni.encode("ascii",errors='ignore')
'jos'
</pre>

O reemplazar el carácter que no corresponde al código

\*\* ascii\*\* con el carácter &#8220;_reemplazo_&#8221; de **unicode** (U+FFFFD).

<pre>&gt;&gt;&gt; cad_uni.encode("ascii",errors='replace')
'jos?'
</pre>

**5) ¿Qué métodos tiene la clase unicode?** Tiene los mismos que la clase **str**, más dos nuvos métodos: `isdecimal()` y `isnumeric()`.

<pre>cad_uni.capitalize  cad_uni.islower     cad_uni.rpartition
cad_uni.center      cad_uni.isnumeric   cad_uni.rsplit
cad_uni.count       cad_uni.isspace     cad_uni.rstrip
cad_uni.decode      cad_uni.istitle     cad_uni.split
cad_uni.encode      cad_uni.isupper     cad_uni.splitlines
cad_uni.endswith    cad_uni.join        cad_uni.startswith
cad_uni.expandtabs  cad_uni.ljust       cad_uni.strip
cad_uni.find        cad_uni.lower       cad_uni.swapcase
cad_uni.format      cad_uni.lstrip      cad_uni.title
cad_uni.index       cad_uni.partition   cad_uni.translate
cad_uni.isalnum     cad_uni.replace     cad_uni.upper
cad_uni.isalpha     cad_uni.rfind       cad_uni.zfill
cad_uni.isdecimal   cad_uni.rindex
cad_uni.isdigit     cad_uni.rjust
</pre>

Veamos que ocurre con el método

`isnumeric()`:

<pre>&gt;&gt;&gt; cad.isnumeric()
Traceback (most recent call last):
File "&lt;stdin&gt;", line 1, in &lt;module&gt;
AttributeError: 'str' object has no attribute 'isnumeric'

&gt;&gt;&gt; cad_uni.isnumeric()
False
</pre>

Las cadenas de tipo

**str** no tienen dicho método, mientras las **unicode** si. **6) Las funciones ord() y unichar()** Al igual que podemos utilizar la función `chr()` para obtener el caracter correspondiente a un código ascii.

<pre>&gt;&gt;&gt; print chr(97)
a
</pre>

Podemos usar la función

`unichar()` para mostrar un carácter a partir de un código **unicode**. La función `ord()` nos devuelve el código **unicode** a partir de un caracter.

<pre>&gt;&gt;&gt; cad_uni=u'ñ'
&gt;&gt;&gt; ord(cad_uni)
241

&gt;&gt;&gt; unichr(241)
u'\xf1'
&gt;&gt;&gt; print unichr(241)
ñ
</pre>

## Conclusión En esta entrada hemos abordado cómo trabaja python2 con las distintas codificaciones de caracteres. Lo he escrito pensando en mis alumnos del módulo de &#8220;Lenguaje de marcas&#8221;. Si hay que recordar que en python3 la clase string está codificada con Unicode por lo que el tratamiento de la codificación cambia radicalmente. Por lo tanto en una próxima entrada tratare la codificación de caracteres en python3.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->