---
id: 1896
title: Configuración de un proxy inverso con Apache 2.4
date: 2018-02-21T19:45:07+00:00
author: admin
layout: post
guid: https://www.josedomingo.org/pledin/?p=1896
permalink: /2018/02/configuracion-de-un-proxy-inverso-con-apache-2-4/
categories:
  - General
tags:
  - Apache
  - Proxy
---
Un proxy inverso es un tipo de servidor proxy que recupera recursos en nombre de un cliente desde uno o más servidores. Por lo tanto el cliente hace la petición al puerto 80 del proxy, y éste es el que hace la petición al servidor web que normalmente está en una red interna no accesible desde el cliente.

[<img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy.png" alt="" width="280" height="105" class="aligncenter size-full wp-image-1898" />](https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy.png){.thumbnail}

## Apache como proxy inverso

Apache2.4 puede funcionar como proxy inverso usando el módulo `proxy` junto a otros módulos, por ejemplo:

  * proxy_http: Para trabajar con el protocolo HTTP.
  * proxy_ftp: Para trabajar con el protocolo FTP.
  * proxy_html: Permite reescribir los enlaces HTML en el espacio de direcciones de un proxy.
  * proxy_ajp: Para trabajar con el protocolo AJP para Tomcat.
  * &#8230;

Por lo tanto, para empezar, vamos activar los módulos que necesitamos:

    # a2enmod proxy proxy_http
    

<!--more-->

## Ejemplo de utilización de proxy inverso

Tenemos a nuestra disposición un servidor interno (no accesible desde el cliente) en la dirección privada, con el nombre de `interno.example.org`. Tenemos un servidor que va a funcionar de proxy, llamado `proxy.example.org` con dos interfaces de red: una pública conectada a la red donde se encuentra el cliente, y otra interna conectada a la red donde se encuentra el servidor interno.

### Sirviendo una página estática

En nuestro servidor interno hemos creado un virtual host para servir una página estática, `index.html`, con este contenido:

    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Probando proxy inverso con Apache2</title>
    </head>
    <body>
            <h1>Probando proxy inverso con Apache2</h1>
            <img src="img.jpg"/>
            <img src="/img.jpg"/>
            <br/>
            <a href="http://10.0.0.6/carpeta/index.html">Enlace tipo 1</a><br/>
            <a href="/carpeta/index.html">Enlace tipo 2</a><br/>
            <a href="carpeta/index.html">Enlace tipo 3</a>
    </body>
    

Vamos a utilizar la directiva [`ProvyPass`](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html#proxypass) en el fichero de configuración del virtual host, de la siguiente forma:

    ProxyPass "/web/" "http://interno.example.org/"
    

También lo podemos configurar de forma similar con:

    <Location "/web/">
        ProxyPass "http://interno.example.org/"
    </Location>
    

Evidentemente debe funcionar la resolución de nombre para que el proxy pueda acceder al servidor interno.

De esta manera al acceder desde el cliente la URL `http://proxy.example.org/web/` se mostraría la página que se encuentra en el servidor interno.

[<img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy1.png" alt="" width="701" height="273" class="aligncenter size-full wp-image-1900" />](https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy1.png){.thumbnail}

Como vemos una imagen no se ha cargado, además no todos los enlaces funcionan, pero antés vamos a solucionar el problema de las redirecciones.

### El probelma de las redirecciones

Cuando creamos una redirección en un servidor web y el cliente intenta acceder al recurso, el servidor manda una respuesta con código de estado `301` o `302`, e indica la URL de la nueva ubicación del recurso en una cabecera HTTP llamada `Location`.

Si hemos configurado una redirección en el servidor interno, cuando se accede al recurso a través del proxy, la redirección se realiza pero la cabecera `Location` viene referencia la dirección del servidor interno, por lo que el cliente es incapaz de acceder a la nueva ubicación. Al acceder a ´http://proxy.example.org/web/directorio´ se produce una redirección pero como vemos la nueva url hace referencia al servidor interno por lo que no funciona:

[<img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy2.png" alt="" width="734" height="402" class="aligncenter size-full wp-image-1902" />](https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy2.png){.thumbnail}

Para solucionarlo utilizamos la directiva [`ProxyPassReverse`](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html#proxypassreverse) que se encarga de reescribir la URL de la cabecera `Location`.

La configuración quedaría:

    ProxyPass "/web/" "http://interno.example.org/"
    ProxyPassReverse "/web/" "http://interno.example.org/"
    

O de esta otra forma:

    <Location "/web/">
        ProxyPass "http://interno.example.org/"
        ProxyPassReverse "http://interno.example.org/"
    </Location>
    

Por lo que ya podemos hacer la redirección de forma correcta:

[<img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy3.png" alt="" width="433" height="155" class="aligncenter size-full wp-image-1903" />](https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy3.png){.thumbnail}

### El problema de las rutas HTML

La página que servimos a través del proxy que se guarda en el servidor interno puede tener declarada rutas, por ejemplo en imágenes o enlaces. Nos podemos encontrar con diferentes tipos de rutas:

  * `http://10.0.0.6/carpeta/index.html`: Una ruta absoluta donde aparece la dirección del servidor interno y que evidentemente el cliente no va a poder seguir.
  * `/carpeta/index.html`: Una ruta absoluta, referenciada a la raíz del `DocumentRoot`.
  * `carpeta/index.html`: Una ruta relativa.

Si tenemos una ruta relativa, el cliente la va a poder seguir sin problema cuando accede a través del proxy, pero si tenemos una ruta como la segunda no lo va a poder hacer, porque en el `DocumentRoot` del proxy no existe este recurso. Al acceder al segundo enlace:

[<img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy4.png" alt="" width="746" height="372" class="aligncenter size-full wp-image-1904" />](https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy4.png){.thumbnail}

Para solucionar este problema debemos reescribir el HTML para cambiar la referencia del enlace. Para ello necesitamos activar un nuevo módulo:

    # a2enmod proxy_html
    

Y realizar la siguiente configuración:

    ProxyPass "/web/"  "http://interno.example.org/"
    ProxyPassReverse "/web/"  "http://interno.example.org/"
    ProxyHTMLURLMap http://interno.example.org /web
    <Location /web/>
        ProxyPassReverse /
        ProxyHTMLEnable On
        ProxyHTMLURLMap / /web/
    </Location>
    

Como vemos hemos configurado un proxy para HTML, que será responsable de reescribir todos las rutas que contiene el HYML, utilizando la directiva [`ProxyHTMLURLMap`](https://httpd.apache.org/docs/2.4/mod/mod_proxy_html.html#proxyhtmlurlmap):

    ProxyHTMLURLMap http://interno.example.org /web
    

Es importante no poner la barra final, cuando se encuentra una ruta que coincide con el primer patrón se reescribe con el segundo, esta regla reescribe las ruta del tipo de la primera opción que hemos visto anteriormente. Para arreglar la rutas de la segunda opción, utilizamos dentro de la sección `Location`:

    ProxyHTMLURLMap / /web/
    

Después de iniciar comprobamos que al intentar acceder al proxy obtenemos un error en el navegador del cliente &#8220;Error de codificación de contenido&#8221;.

[<img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy5.png" alt="" width="724" height="342" class="aligncenter size-full wp-image-1905" />](https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy5.png){.thumbnail}

### Sirviendo contenido multimedia

Acabamos de configurar un proxy que examina y reescribe el HTML de nuestro sitio web, pero evidentemente existe más contenido en nuestro sitio que no es HTML y no debería ser procesado por `proxy_html`. Esto se soluciona verificando la cabecera del contenido y rechazando todos los contenidos que no tengan el tipo MIME adecuado.

Pero tenemos un problema: normalmente se comprime el contenido HTML, y encontramos cabeceras de este tipo:

    Content-Type: text/html
    Content-Encoding: gzip
    

Este contenido no debería pasar por el analizador de `proxy_html`. Para solucionar esto podemos negarnos a admitir la compresión. La eliminación de cualquier cabecera de petición `Accept-Encoding` hace el trabajo. Para ello podemos utilizar la directiva [`RequestHeader`](http://httpd.apache.org/docs/current/mod/mod_headers.html#requestheader) del módulos `headers`, por lo tanto activamos el módulo:

    # a2enmod headers
    

Y usamos la directiva `RequestHeader` dentro del la sección `Location`:

    ProxyPass "/web/"  "http://interno.example.org/"
    ProxyPassReverse "/web/"  "http://interno.example.org/"
    ProxyHTMLURLMap http://interno.example.org /web
    <Location /web/>
        ProxyPassReverse /
        ProxyHTMLEnable On
        ProxyHTMLURLMap / /web/
        RequestHeader unset Accept-Encoding
    </Location>
    

Ahora si podemos acceder a la página completa a través del proxy.

[<img src="https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy6.png" alt="" width="696" height="275" class="aligncenter size-full wp-image-1906" />](https://www.josedomingo.org/pledin/wp-content/uploads/2018/02/proxy6.png){.thumbnail}

### Sirviendo contenido con HTTPS

Una situación similar surge en el caso del contenido encriptado (https). En este caso, usando el módulo `ssl` y un certificado en el proxy, de modo que la sesión segura real se encuentre entre el navegador y el proxy, no al servidor interno.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->