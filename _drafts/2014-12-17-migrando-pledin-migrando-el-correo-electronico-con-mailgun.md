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
![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mailgun_logo.png)

El hosting que tenía contratado para hospedar la plataforma Pledin me ofrecía el servicio de correo electrónico, de tal manera que podía crear un número determinado de buzones de correo (con una capacidad limitada) y hacer uso del servidor SMTP para envío de correos y los servidores IMAP o POP para recibir correos. Concretamente tenía creado dos buzones de correos que usaba habitualmente, y las páginas moodle y wordpress hacían uso del servidor SMTP para el envío de correos.

Trás la migración a openshift he elegido el servicio [Mailgun](http://www.mailgun.com/) como servidor de correo. **Mailgun** en un servicio web que nos proporciona una API con la que podemos enviar, recibir y gestionar correos electrónicos. Los 10.000 primeros correos enviados son gratuitos, creo que suficientes para mis necesidades.

## Configuración de Mailgun para el dominio josedomingo.org

Lo primero que hay que hacer es crearnos una cuenta en la página de [Mailgun](http://www.mailgun.com/). Mailgun nos ofrece un subdminio para hacer pruebas, con el que podemos mandar sólo 300 correos diarios, este subdominio es del tipo:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg11.png)

Evidentemente tenemos que añadir un nuevo dominio, en nuestro caso `josedomingo.org`, y modificar nuestro servidor DNS con los siguiente registros:

  Un registro TXT para especificar el registro SPF para el dominio `josedomingo.org`, este registro nos va a permitir indicar el servidor SMTP autorizado para nuestro dominio, y prevenir la falsificación de direcciones. [SPF en la Wikipedia](http://es.wikipedia.org/wiki/Sender_Policy_Framework).
* Un registro TXT para el nombre de host `smtp._domainkey.josedomingo.org`, DKIM es un mecanismo de autenticación de correos electrónicos, en este registro se guarda la clave rsa pública que va a permitir la firma electrónica de los correos. [DKIM en la wikipedia](http://es.wikipedia.org/wiki/DomainKeys_Identified_Mail).
* Un registro CNAME `email.josedomingo.org que apunta a la dirección de `mailgun.com` y que va a permitir el rastreo de los correos para hacer estadísticas de enviado, recibidos, ...
* Los registros MX necesarios para que los correos enviados a `josedomingo.org` lo reciban los servidores de mailgun.

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg2.png) 
![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg3.png)

Finalmente el sistema hace una comprobación de que los registros están configurados de forma adecuada y el dominio es considerado activo y ya podemos empezar a trabajar con él.

## Envío de correos con Mailgun

Mailgun nos ofrece dos posibilidades para enviar correos:

### Envío de correos usando la API

Esta es la característica más destacable de este servicio, ya que la utilización de una API para el envío de correos nos da la posibilidad de automatizar el proceso de una manera más eficiente.

En la configuración de nuestro dominio tenemos los datos necesarios para el envío de correos (la URL base, la KEY API, el usuario de envío,&#8230;):

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg4.png)

Como vemos en la imagen podemos gestionar las credenciales para  crear nuevos usuarios SMTP. Siguiendo la documentación podemos usar el siguiente script de ejemplo para mandar correos:

    curl -s --user 'api:key-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' \
        https://api.mailgun.net/v2/josedom.org/messages \
        -F from='José Domingo <postmaster@josedomingo.org>' \
        -F to=correo1@example.com \
        -F to=correo1@example.com \
        -F subject='Hola' \
        -F text='Probando Maigun!'


### Envío de correos usando SMTP

Mialgun ofrece también la posibilidad de usar un servidor SMTP para el envío de correos. El servidor SMTP que nos ofrece el servicio soporta el envío de correos por el puerto 25, 465 (SSL/TLS), 587 (STARTTLS), y 2525. Esta la opción que más se adapta a mis necesidades y la configuración de cualquier cliente de correos es trivial.

## Recepción de correos con Mailgun

Aunque el servicio Mailgun [ha dejado de ofrecer](http://documentation.mailgun.com/faq-mailbox-eol.html) un servidor IMAP/POP para recoger nuestro correo, tenemos la posibilidad de gestionar el correo recibido de varias maneras: la primera y cómo explican en esta [entrada](http://blog.mailgun.com/store-a-temporary-mailbox-for-all-your-incoming-email/) del blog de Mailgun utilizando la API, la segunda y más sencilla para mis necesidades, redirigiendo el correo a otra cuenta de correos, por ejemplo a una cuenta de gmail.

Para realizar una redirección de nuestro correo tenemos que declarar una ruta (route), una ruta define una acción que vamos a realizar sobre un determinado correo que nos llegue a nuestro dominio. Al definir una ruta tenemos que indicar cuatro datos:

* Una prioridad, número entero que indica la prioridad de ejecución de una determinada ruta.
* Un filtro, que nos permite seleccionar un conjunto de correos: 
  * `match_recipient(pattern)`: Nos permite elegir los correos que llegan a una determinada dirección usando una expresión regular. Por ejemplo, con este filtro seleccionamos todos los correos que lleguen a la dirección `ejemplo@josedomingo.org`. 

        match_recipient("ejemplo@josedomingo.org")
    
  * `match_header(header, pattern)`: Nos permite elegir los correos dependiendo del valor de una cabecera del correo. Por ejemplo, con este filtro seleccionamos los correos cuyo asunto contiene una determinada palabra. 

        match_header("subject", ".*support")</pre>
    
  * `catch_all()`: Selecciona todos los correos.
* Una acción, indicamos lo que vamos a hacer con los correos seleccionados por el filtro, tenemos tres opciones: 
  * `forward(destination)`: Reenvía el correo electrónico.
  * `store()`: almacena el correo temporalmente (unos tres días), lo podemos obtener a través de la API.
  * `stop()`: Indica que no se van a evaluar más filtros con menor prioridad.
* Una descripción que me permite definir la ruta.

Teniendo en cuenta cómo funcionan las rutas, voy a crear dos rutas, cada una de ellas me filtran los correos enviados a las direcciones de correo que yo usaba habitualmente, y voy a redirigir todos los correos a una cuenta de gmail. Puedo dar de alta las rutas usando la API o desde la página web de Mailgun, quedando las rutas de las siguiente manera:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg5.png)

## Configurando Moodle para usar Mailgun

Lo único que nos queda es configurar nuestras páginas web para que usen el nuevo servidor SMTP y puedan enviar correos. En el caso de moodle nos vamos a la Administración del Sitio, extensiones, mensajes de salidas, email y lo configuramos de la siguiente manera:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg6.png)

## Configurando WordPress para usar Mailgun

En el caso de WordPress tenemos a nuestra disposición un plugin, llamado &#8220;Mailgun&#8221; que nos facilita la configuración con el servicio, después de instalar el plugin, la configuración quedaría de la siguiente forma:

![]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2014/12/mg7.png)

## Conclusiones

Mailgun es un servicio de correo enfocado para los desarrolladores, que mediante el uso de la API que nos ofrece pueden desarrollar aplicaciones que gestionen correo electrónico. Además desde [su compra por parte de Rackspace](http://interneteng1.blogspot.com.es/2012/08/techcrunch-rackspace-acquires-mailgun-y.html) está teniendo mucho protagonismo en las infraestructuras de cloud computing. En este artículo he presentado las características que yo he usado para mis necesidades, pero evidentemente el servicio nos ofrece muchas más funcionalidades que puedes aprender en su [documentación oficial](http://documentation.mailgun.com/).

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->