---
layout: post
status: publish
published: true
title: Migrando Pledin. Migrando el correo electr&oacute;nico con Mailgun
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1162
wordpress_url: http://www.josedomingo.org/pledin/?p=1162
date: '2014-12-17 21:05:57 +0000'
date_gmt: '2014-12-17 20:05:57 +0000'
categories:
- General
tags:
- Pledin
- email
- mailgun
comments: []
---
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mailgun_logo.png"><img class="aligncenter size-medium wp-image-1165" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mailgun_logo-300x78.png" alt="mailgun_logo" width="300" height="78" /></a>El hosting que ten&iacute;a contratado para hospedar la plataforma Pledin me ofrec&iacute;a el servicio de correo electr&oacute;nico, de tal manera que pod&iacute;a crear un n&uacute;mero determinado de buzones de correo (con una capacidad limitada) y hacer uso del servidor SMTP para env&iacute;o de correos y los servidores IMAP o POP para recibir correos. Concretamente ten&iacute;a creado dos buzones de correos que usaba habitualmente, y las p&aacute;ginas moodle y wordpress hac&iacute;an uso del servidor SMTP para el env&iacute;o de correos.</p>
<p>Tr&aacute;s la migraci&oacute;n a openshift he elegido el servicio <a href="http://www.mailgun.com/">Mailgun</a> como servidor de correo. <strong>Mailgun</strong> en un servicio web que nos proporciona una API con la que podemos enviar, recibir y gestionar correos electr&oacute;nicos. Los 10.000 primeros correos enviados son gratuitos, creo que suficientes para mis necesidades.<!--more--></p>
<h2>Configuraci&oacute;n de Mailgun para el dominio josedomingo.org</h2>
<p>Lo primero que hay que hacer es crearnos una cuenta en la p&aacute;gina de <a href="http://www.mailgun.com/">Mailgun. </a>Mailgun nos ofrece un subdminio para hacer pruebas, con el que podemos mandar s&oacute;lo 300 correos diarios, este subdominio es del tipo:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg11.png"><img class="aligncenter wp-image-1184 size-full" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg11.png" alt="" width="549" height="227" /></a>Evidentemente tenemos que a&ntilde;adir un nuevo dominio, en nuestro caso <em>josedomingo.org</em>, y modificar nuestro servidor DNS con los siguiente registros:</p>
<ul>
<li>Un registro TXT para especificar el registro SPF para el dominio<em> josedomingo.org</em>, este registro nos va a permitir indicar el servidor SMTP autorizado para nuestro dominio, y prevenir la falsificaci&oacute;n de direcciones. <a href="http://es.wikipedia.org/wiki/Sender_Policy_Framework">SPF en la Wikipedia</a>.</li>
<li>Un registro TXT para el nombre de host <em>smtp._domainkey.josedomingo.org, </em>DKIM es un mecanismo de autenticaci&oacute;n de correos electr&oacute;nicos, en este registro se guarda la clave rsa p&uacute;blica que va a permitir la firma electr&oacute;nica de los correos. <a href="http://es.wikipedia.org/wiki/DomainKeys_Identified_Mail">DKIM en la wikipedia</a>.</li>
<li>Un registro CNAME <em>email.josedomingo.org </em>que apunta a la direcci&oacute;n de <em>mailgun.com </em>y que va a permitir el rastreo de los correos para hacer estad&iacute;sticas de enviado, recibidos, ...</li>
<li>Los registros MX necesarios para que los correos enviados a <em>josedomingo.org</em> lo reciban los servidores de mailgun.<a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg2.png"><img class="aligncenter wp-image-1169 size-full" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg2.png" alt="mg2" width="622" height="474" /></a> <a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg3.png"><img class="aligncenter wp-image-1170 size-full" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg3.png" alt="mg3" width="628" height="534" /></a></li>
</ul>
<p>Finalmente el sistema hace una comprobaci&oacute;n de que los registros est&aacute;n configurados de forma adecuada y el dominio es considerado activo y ya podemos empezar a trabajar con &eacute;l.</p>
<h2>Env&iacute;o de correos con Mailgun</h2>
<p>Mailgun nos ofrece dos posibilidades para enviar correos:</p>
<h3>Env&iacute;o de correos usando la API</h3>
<p>Esta es la caracter&iacute;stica m&aacute;s destacable de este servicio, ya que la utilizaci&oacute;n de una API para el env&iacute;o de correos nos da la posibilidad de automatizar el proceso de una manera m&aacute;s eficiente.</p>
<p>En la configuraci&oacute;n de nuestro dominio tenemos los datos necesarios para el env&iacute;o de correos (la URL base, la KEY API, el usuario de env&iacute;o,...):</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg4.png"><img class="aligncenter size-full wp-image-1174" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg4.png" alt="mg4" width="599" height="429" /></a></p>
<p>Como vemos en la imagen podemos gestionar las credenciales para&nbsp; crear nuevos usuarios SMTP. Siguiendo la documentaci&oacute;n podemos usar el siguiente script de ejemplo para mandar correos:</p>
<pre>curl -s --user <span class="s1">'api:key-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'</span> <span class="se">\</span>
    https://api.mailgun.net/v2/josedom.org/messages <span class="se">\</span>
    -F <span class="nv">from</span><span class="o">=</span><span class="s1">'Jos&eacute; Domingo <postmaster@josedomingo.org>'</span> <span class="se">\</span>
    -F <span class="nv">to</span><span class="o">=</span>correo1@example.com <span class="se">\</span>
    -F <span class="nv">to</span><span class="o">=</span>correo1@example.com <span class="se">\</span>
    -F <span class="nv">subject</span><span class="o">=</span><span class="s1">'Hola'</span> <span class="se">\</span>
    -F <span class="nv">text</span><span class="o">=</span><span class="s1">'Probando Maigun!'
</span></pre>
<h3>Env&iacute;o de correos usando SMTP</h3>
<p>Mialgun ofrece tambi&eacute;n la posibilidad de usar un servidor SMTP para el env&iacute;o de correos. El servidor SMTP que nos ofrece el servicio soporta el env&iacute;o de correos por el puerto&nbsp;25, 465 (SSL/TLS), 587 (STARTTLS), y 2525. Esta la opci&oacute;n que m&aacute;s se adapta a mis necesidades y la configuraci&oacute;n de cualquier cliente de correos es trivial.</p>
<h2>Recepci&oacute;n de correos con Mailgun</h2>
<p>Aunque el servicio Mailgun <a href="http://documentation.mailgun.com/faq-mailbox-eol.html">ha dejado de ofrecer </a>un servidor IMAP/POP para recoger nuestro correo, tenemos la posibilidad de gestionar el correo recibido de varias maneras: la primera y c&oacute;mo explican en esta <a href="http://blog.mailgun.com/store-a-temporary-mailbox-for-all-your-incoming-email/">entrada </a>del blog de Mailgun utilizando la API, la segunda y m&aacute;s sencilla para mis necesidades, redirigiendo el correo a otra cuenta de correos, por ejemplo a una cuenta de gmail.</p>
<p>Para realizar una redirecci&oacute;n de nuestro correo tenemos que declarar una ruta (route), una ruta define una acci&oacute;n que vamos a realizar sobre un determinado correo que nos llegue a nuestro dominio. Al definir una ruta tenemos que indicar cuatro datos:</p>
<ul>
<li>Una prioridad, n&uacute;mero entero que indica la prioridad de ejecuci&oacute;n de una determinada ruta.</li>
<li>Un filtro, que nos permite seleccionar un conjunto de correos:
<ul>
<li>match_recipient(pattern): Nos permite elegir los correos que llegan a una determinada direcci&oacute;n usando una expresi&oacute;n regular. Por ejemplo, con este filtro seleccionamos todos los correos que lleguen a la direcci&oacute;n <em>ejemplo@josedomingo.org</em>.
<pre>match_recipient("ejemplo@josedomingo.org")</pre>
</li>
<li>match_header(header, pattern): Nos permite elegir los correos dependiendo del valor de una cabecera del correo. Por ejemplo, con este filtro seleccionamos los correos cuyo asunto contiene una determinada palabra.
<pre>match_header("subject", ".*support")</pre>
</li>
</ul>
<ul>
<li>catch_all(): Selecciona todos los correos.</li>
</ul>
</li>
<li>Una acci&oacute;n, indicamos lo que vamos a hacer con los correos seleccionados por el filtro, tenemos tres opciones:
<ul>
<li>forward(destination): Reenv&iacute;a el correo electr&oacute;nico.</li>
<li>store(): almacena el correo temporalmente (unos tres d&iacute;as), lo podemos obtener a trav&eacute;s de la API.</li>
<li>stop(): Indica que no se van a evaluar m&aacute;s filtros con menor prioridad.</li>
</ul>
</li>
<li>Una descripci&oacute;n que me permite definir la ruta.</li>
</ul>
<p>Teniendo en cuenta c&oacute;mo funcionan las rutas, voy a crear dos rutas, cada una de ellas me filtran los correos enviados a las direcciones de correo que yo usaba habitualmente, y voy a redirigir todos los correos a una cuenta de gmail. Puedo dar de alta las rutas usando la API o desde la p&aacute;gina web de Mailgun, quedando las rutas de las siguiente manera:</p>
<h2><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg5.png"><img class="aligncenter size-full wp-image-1179" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg5.png" alt="mg5" width="865" height="157" /></a>Configurando Moodle para usar Mailgun</h2>
<p>Lo &uacute;nico que nos queda es configurar nuestras p&aacute;ginas web para que usen el nuevo servidor SMTP y puedan enviar correos. En el caso de moodle nos vamos a la Administraci&oacute;n del Sitio, extensiones, mensajes de salidas, email y lo configuramos de la siguiente manera:</p>
<h2><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg6.png"><img class="aligncenter size-full wp-image-1181" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg6.png" alt="mg6" width="995" height="549" /></a></h2>
<h2>Configurando Wordpress para usar Mailgun</h2>
<p>En el caso de Wordpress tenemos a nuestra disposici&oacute;n un plugin, llamado "Mailgun" que nos facilita la configuraci&oacute;n con el servicio, despu&eacute;s de instalar el plgin, la configuraci&oacute;n quedar&iacute;a de la siguiente forma:</p>
<p><a class="thumbnail" href="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg7.png"><img class="aligncenter size-full wp-image-1182" src="http://www.josedomingo.org/pledin/wp-content/uploads/2014/12/mg7.png" alt="mg7" width="1266" height="409" /></a></p>
<h2>Conclusiones</h2>
<p>Mailgun es un servicio de correo enfocado para los desarrolladores, que mediante el uso de la API que nos ofrece pueden desarrollar aplicaciones que gestionen correo electr&oacute;nico. Adem&aacute;s desde <a href="http://interneteng1.blogspot.com.es/2012/08/techcrunch-rackspace-acquires-mailgun-y.html">su compra por parte de Rackspace</a> est&aacute; teniendo mucho protagonismo en las infraestructuras de cloud computing. En este art&iacute;culo he presentado las caracter&iacute;sticas que yo he usado para mis necesidades, pero evidentemente el servicio nos ofrece muchas m&aacute;s funcionalidades que puedes aprender en su <a href="http://documentation.mailgun.com/">documentaci&oacute;n oficial</a>.</p>
