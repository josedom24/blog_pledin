---
id: 1162
title: Migrando Pledin. Migrando el correo electrónico con Mailgun
date: 2014-12-17T21:05:57+00:00


guid: http://www.josedomingo.org/pledin/?p=1162
permalink: /2014/12/migrando-pledin-migrando-el-correo-electronico-con-mailgun/


tags:
  - email
  - mailgun
  - Pledin
---
[<img class="aligncenter size-medium wp-image-1165" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mailgun_logo-300x78.png" alt="mailgun_logo" width="300" height="78" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mailgun_logo-300x78.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mailgun_logo.png 740w" sizes="(max-width: 300px) 100vw, 300px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mailgun_logo.png){.thumbnail}El hosting que tenía contratado para hospedar la plataforma Pledin me ofrecía el servicio de correo electrónico, de tal manera que podía crear un número determinado de buzones de correo (con una capacidad limitada) y hacer uso del servidor SMTP para envío de correos y los servidores IMAP o POP para recibir correos. Concretamente tenía creado dos buzones de correos que usaba habitualmente, y las páginas moodle y wordpress hacían uso del servidor SMTP para el envío de correos.

Trás la migración a openshift he elegido el servicio [Mailgun](http://www.mailgun.com/) como servidor de correo. **Mailgun** en un servicio web que nos proporciona una API con la que podemos enviar, recibir y gestionar correos electrónicos. Los 10.000 primeros correos enviados son gratuitos, creo que suficientes para mis necesidades.<!--more-->

## Configuración de Mailgun para el dominio josedomingo.org

Lo primero que hay que hacer es crearnos una cuenta en la página de [Mailgun.](http://www.mailgun.com/) Mailgun nos ofrece un subdminio para hacer pruebas, con el que podemos mandar sólo 300 correos diarios, este subdominio es del tipo:

[<img class="aligncenter wp-image-1184 size-full" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg11.png" alt="" width="549" height="227" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg11.png 549w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg11-300x124.png 300w" sizes="(max-width: 549px) 100vw, 549px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg11.png){.thumbnail}Evidentemente tenemos que añadir un nuevo dominio, en nuestro caso _josedomingo.org_, y modificar nuestro servidor DNS con los siguiente registros:

  * Un registro TXT para especificar el registro SPF para el dominio _josedomingo.org_, este registro nos va a permitir indicar el servidor SMTP autorizado para nuestro dominio, y prevenir la falsificación de direcciones. [SPF en la Wikipedia](http://es.wikipedia.org/wiki/Sender_Policy_Framework).
  * Un registro TXT para el nombre de host _smtp._domainkey.josedomingo.org,_ DKIM es un mecanismo de autenticación de correos electrónicos, en este registro se guarda la clave rsa pública que va a permitir la firma electrónica de los correos. [DKIM en la wikipedia](http://es.wikipedia.org/wiki/DomainKeys_Identified_Mail).
  * Un registro CNAME _email.josedomingo.org_ que apunta a la dirección de _mailgun.com_ y que va a permitir el rastreo de los correos para hacer estadísticas de enviado, recibidos, &#8230;
  * Los registros MX necesarios para que los correos enviados a _josedomingo.org_ lo reciban los servidores de mailgun.[<img class="aligncenter wp-image-1169 size-full" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg2.png" alt="mg2" width="622" height="474" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg2.png 622w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg2-300x228.png 300w" sizes="(max-width: 622px) 100vw, 622px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg2.png){.thumbnail} [<img class="aligncenter wp-image-1170 size-full" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg3.png" alt="mg3" width="628" height="534" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg3.png 628w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg3-300x255.png 300w" sizes="(max-width: 628px) 100vw, 628px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg3.png){.thumbnail}

Finalmente el sistema hace una comprobación de que los registros están configurados de forma adecuada y el dominio es considerado activo y ya podemos empezar a trabajar con él.

## Envío de correos con Mailgun

Mailgun nos ofrece dos posibilidades para enviar correos:

### Envío de correos usando la API

Esta es la característica más destacable de este servicio, ya que la utilización de una API para el envío de correos nos da la posibilidad de automatizar el proceso de una manera más eficiente.

En la configuración de nuestro dominio tenemos los datos necesarios para el envío de correos (la URL base, la KEY API, el usuario de envío,&#8230;):

[<img class="aligncenter size-full wp-image-1174" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg4.png" alt="mg4" width="599" height="429" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg4.png 599w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg4-300x214.png 300w" sizes="(max-width: 599px) 100vw, 599px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg4.png){.thumbnail}

Como vemos en la imagen podemos gestionar las credenciales para  crear nuevos usuarios SMTP. Siguiendo la documentación podemos usar el siguiente script de ejemplo para mandar correos:

<pre>curl -s --user <span class="s1">'api:key-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'</span> <span class="se">\</span>
    https://api.mailgun.net/v2/josedom.org/messages <span class="se">\</span>
    -F <span class="nv">from</span><span class="o">=</span><span class="s1">'José Domingo &lt;postmaster@josedomingo.org&gt;'</span> <span class="se">\</span>
    -F <span class="nv">to</span><span class="o">=</span>correo1@example.com <span class="se">\</span>
    -F <span class="nv">to</span><span class="o">=</span>correo1@example.com <span class="se">\</span>
    -F <span class="nv">subject</span><span class="o">=</span><span class="s1">'Hola'</span> <span class="se">\</span>
    -F <span class="nv">text</span><span class="o">=</span><span class="s1">'Probando Maigun!'
</span></pre>

### Envío de correos usando SMTP

Mialgun ofrece también la posibilidad de usar un servidor SMTP para el envío de correos. El servidor SMTP que nos ofrece el servicio soporta el envío de correos por el puerto 25, 465 (SSL/TLS), 587 (STARTTLS), y 2525. Esta la opción que más se adapta a mis necesidades y la configuración de cualquier cliente de correos es trivial.

## Recepción de correos con Mailgun

Aunque el servicio Mailgun [ha dejado de ofrecer](http://documentation.mailgun.com/faq-mailbox-eol.html) un servidor IMAP/POP para recoger nuestro correo, tenemos la posibilidad de gestionar el correo recibido de varias maneras: la primera y cómo explican en esta [entrada](http://blog.mailgun.com/store-a-temporary-mailbox-for-all-your-incoming-email/) del blog de Mailgun utilizando la API, la segunda y más sencilla para mis necesidades, redirigiendo el correo a otra cuenta de correos, por ejemplo a una cuenta de gmail.

Para realizar una redirección de nuestro correo tenemos que declarar una ruta (route), una ruta define una acción que vamos a realizar sobre un determinado correo que nos llegue a nuestro dominio. Al definir una ruta tenemos que indicar cuatro datos:

  * Una prioridad, número entero que indica la prioridad de ejecución de una determinada ruta.
  * Un filtro, que nos permite seleccionar un conjunto de correos: 
      * match_recipient(pattern): Nos permite elegir los correos que llegan a una determinada dirección usando una expresión regular. Por ejemplo, con este filtro seleccionamos todos los correos que lleguen a la dirección _ejemplo@josedomingo.org_. 
        <pre>match_recipient("ejemplo@josedomingo.org")</pre>
    
      * match_header(header, pattern): Nos permite elegir los correos dependiendo del valor de una cabecera del correo. Por ejemplo, con este filtro seleccionamos los correos cuyo asunto contiene una determinada palabra. 
        <pre>match_header("subject", ".*support")</pre>
    
      * catch_all(): Selecciona todos los correos.
  * Una acción, indicamos lo que vamos a hacer con los correos seleccionados por el filtro, tenemos tres opciones: 
      * forward(destination): Reenvía el correo electrónico.
      * store(): almacena el correo temporalmente (unos tres días), lo podemos obtener a través de la API.
      * stop(): Indica que no se van a evaluar más filtros con menor prioridad.
  * Una descripción que me permite definir la ruta.

Teniendo en cuenta cómo funcionan las rutas, voy a crear dos rutas, cada una de ellas me filtran los correos enviados a las direcciones de correo que yo usaba habitualmente, y voy a redirigir todos los correos a una cuenta de gmail. Puedo dar de alta las rutas usando la API o desde la página web de Mailgun, quedando las rutas de las siguiente manera:

## [<img class="aligncenter size-full wp-image-1179" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg5.png" alt="mg5" width="865" height="157" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg5.png 865w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg5-300x54.png 300w" sizes="(max-width: 865px) 100vw, 865px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg5.png){.thumbnail}Configurando Moodle para usar Mailgun

Lo único que nos queda es configurar nuestras páginas web para que usen el nuevo servidor SMTP y puedan enviar correos. En el caso de moodle nos vamos a la Administración del Sitio, extensiones, mensajes de salidas, email y lo configuramos de la siguiente manera:

## [<img class="aligncenter size-full wp-image-1181" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg6.png" alt="mg6" width="995" height="549" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg6.png 995w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg6-300x165.png 300w" sizes="(max-width: 995px) 100vw, 995px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg6.png){.thumbnail}

## Configurando WordPress para usar Mailgun

En el caso de WordPress tenemos a nuestra disposición un plugin, llamado &#8220;Mailgun&#8221; que nos facilita la configuración con el servicio, después de instalar el plgin, la configuración quedaría de la siguiente forma:

[<img class="aligncenter size-full wp-image-1182" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg7.png" alt="mg7" width="1266" height="409" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg7.png 1266w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg7-300x96.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg7-1024x330.png 1024w" sizes="(max-width: 1266px) 100vw, 1266px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg7.png){.thumbnail}

## Conclusiones

Mailgun es un servicio de correo enfocado para los desarrolladores, que mediante el uso de la API que nos ofrece pueden desarrollar aplicaciones que gestionen correo electrónico. Además desde [su compra por parte de Rackspace](http://interneteng1.blogspot.com.es/2012/08/techcrunch-rackspace-acquires-mailgun-y.html) está teniendo mucho protagonismo en las infraestructuras de cloud computing. En este artículo he presentado las características que yo he usado para mis necesidades, pero evidentemente el servicio nos ofrece muchas más funcionalidades que puedes aprender en su [documentación oficial](http://documentation.mailgun.com/).

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->