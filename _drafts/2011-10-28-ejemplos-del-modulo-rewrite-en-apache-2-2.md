---
id: 512
title: Ejemplos del módulo rewrite en Apache 2.2
date: 2011-10-28T01:22:11+00:00


guid: http://www.josedomingo.org/pledin/?p=512
permalink: /2011/10/ejemplos-del-modulo-rewrite-en-apache-2-2/

  
tags:
  - Apache
  - Manuales
  - Web
---
Este artículo lo he escrito para explicar en [clase](http://informatica.gonzalonazareno.org/plataforma/course/view.php?id=40) a mis alumnos del ciclo formativo de grado superior de Administración de Sistemas Informáticos en Red, una introducción al módulo `rewrite` de Apache.

El módulo `rewrite` nos va a permitir acceder a una URL e internamente estar accediendo a otra. Ayudado por los ficheros `.htaccess`, el módulo `rewrite` nos va a ayudar a formar URL amigables que son más consideradas por los motores de búsquedas y mejor recordadas por los humanos. Por ejemplo estas URL:

**www.dominio.com/articulos/muestra.php?id=23**
  
**www.dominio.com/pueblos/pueblo.php?nombre=torrelodones**

Es mucho mejor escribirlas como:

**www.dominio.com/articulos/23.php** 
  
**www.dominio.com/pueblos/torrelodones.php**

## Ejemplo 1: Reescribir URL

Si tenemos el siguiente fichero php ([descargar](http://informatica.gonzalonazareno.org/plataforma/file.php/40/php.txt)) llamado `operacion.php`, podríamos usarlo de la siguiente manera:

    http://localhost/operacion.php?op=suma&op1=6&op2=8

Y si queremos reescribir la URL y que usemos en vez de php html, de esta forma:

    http://localhost/operacion.html?op=suma&op1=6&op2=8

Para ello activamos el `mod_rewite`, y escribimos un `.htaccess` de la siguiente manera:

    Options FollowSymLinks
    RewriteEngine On
    RewriteRule ^operacion\.html$ operacion.php

## Ejemplo 2: Cambiar la extensión de los ficheros

Si queremos usar la extensión do en vez de html podríamos usar este `.htacces`

    Options FollowSymLinks
    RewriteEngine On
    RewriteRule ^(.+)\.do$ $1.html [nc]

Esto puede ser penalizado por los motores de búsqueda ya que podemos acceder a la misma página con dos URL distintas, para solucionar esto podemos hacer una redirección:

    RewriteRule ^(.+)\.do$ $1.html [r,nc]

## Ejemplo 3: Crear URL amigables

Como habíamos visto anteriormente el fichero `operacion.php` se podía ejecutar de la siguiente manera:

    http://localhost/operacion.php?op=suma&op1=6&op2=8

Creando una URL amigable podríamos llamar a este fichero de la siguiente manera:

    http://localhost/suma/8/6

¿Cómo podemos conseguir esto?

Crea un `.htaccess` con el siguiente contenido:

    Options FollowSymLinks
    RewriteEngine On
    RewriteBase /
    RewriteRule ^([a-z]+)/([0-9]+)/([0-9]+)$ operacion.php?op=$1&op1=$2&op2=$3

## Ejemplo 4: Acortar URL

Supongamos que dentro de nuestro `DocumentRoot` tenemos una carpeta búsqueda con un fichero `buscar.php` ([descargar](http://informatica.gonzalonazareno.org/plataforma/file.php/40/buscar.txt)). Este fichero me permite obtener la página de búsqueda de google con el parámetro dado, de esta forma:

    http://localhost/busqueda/buscar.php?id=hola

Nos gustaría poder crear una URL más corta que haga lo mismo, escribiríamos en nuestro .htaccess un RewriteRule de la siguiente forma:

    RewriteRule ^buscar busqueda/buscar.php

De esta forma accederíamos por medio de la URL:

    http://localhost/buscar?id=hola

Ejercicio: Siguiendo las técnicas anteriormente vistas, realiza una reescritura de URL para que pudiéramos realizar búsquedas con URL de la siguiente manera:

    http://localhost/buscar/hola.html

## Ejemplo 5: Uso del RewriteCond

Ls directiva [`RewriteCond`](http://httpd.apache.org/docs/2.0/mod/mod_rewrite.html#rewritecond) nos permite especificar una condición que si se cumple se ejecuta la directiva `RewriteRule` posterior. Se pueden poner varias condiciones con `RewriteCond`, en este caso cuando se cumplen todas se ejecuta la directiva `RewriteRule` posterior.

Como vemos en la documentación podemos preguntar por varios parámetros , entre los que destacamos los siguientes:

* `%{HTTP\_USER\_AGENT}`: Información del cliente que accede.
  
  Por ejemplo, podemos mostrar una página distinta para cada navegador:

      RewriteCond %{HTTP\_USER\_AGENT} ^Mozilla
      RewriteRule ^/$ /index.max.html [L]
      RewriteCond %{HTTP\_USER\_AGENT} ^Lynx
      RewriteRule ^/$ /index.min.html [L]
      RewriteRule ^/$ /index.html [L]

* `%{QUERY_STRING}`: Guarda la cadena de parámetros de una URL dinámica.Por ejemplo:

  Teníamos un fichero index.php que recibía un parámetro lang, para traducir el mensaje de bienvenida.

      http://localhost/index.php?lang=es

  Actualmente hemos cambiado la forma de traducir, y se han creado distintos directorios para cada idioma y dentro un index.php con el mensaje traducido.

      http://localhost/es/index.php

  Sin embargo se quiere seguir utilizando la misma forma de traducir.

      RewriteCond %{QUERY_STRING} lang=(.*)
      RewriteRule ^index\.php$ /%1/$1

* `%{REMOTE_ADDR}`: Dirección de destino. Por ejemplo puedo denegar el acceso a una dirección:

        RewriteCond %{REMOTE_ADDR} 145.164.1.8
        RewriteRule ^(.*)$ / [R,NC,L]

También podemos controlar la reescritura de URL según la hora y la fecha, para saber más lee este [artículo](http://www.askapache.com/htaccess/time_hour-rewritecond-time.html).

* `%{HTTP_REFERER}:` Guarda la URL que accede a nuestra página y `%{REQUEST_URI}` guarda la URI, URL sin nombre de dominio. Podemos evitar el Hot_Linking, o uso de recursos de tu servidor desde otra web. Por ejemplo, un caso muy común es usar imágenes alojadas en tu servidor puestas en otras web. Para ello podemos escribir el siguiente `.htaccess`:

      RewriteCond %{HTTP_REFERER} !^$
      RewriteCond %{HTTP_REFERER} !^http://(www\.)?dominio\.com/ [NC]
      RewriteCond %{REQUEST_URI} !hotlink\.(gif|png) [NC]
      RewriteRule .*\.(gif|jpg|png)$ http://www.dominio.com/image/hotlink.png [NC]

  En el anterior ejemplo el primer RewriteCond permite la solicitud directa pero no desde otras páginas (referrer vacío). La siguiente línea indica que si el navegador ha enviado una cabecera `Referrer` y esta no contiene la palabra &"dominio.com" se ejecutará el RewriteRule. La ultima instrucción RewriteCond indica que si en la url solicitada se encuentra el nombre de la imagen "hotlink" no se realizará el `RewrtieRule`; esto se pone porque la imagen `hotlink.png` va a ser la que vamos a usar en RewriteRule y si no ponemos este RewriteCond también sería redirigida la solicitud a esta imagen. La última instrucción del ejemplo es el RewriteRule que indica que cualquier solicitud a una imagen desde otro referrer será reescrita en el servidor hacia la imagen `hotlink.png` y esta será la imagen que se vea en la web que te esté intentando robar la imagen.

Ejercicio: Realiza un `.htaccess` para evitar el hot-linking. Puedes usar esta esta [imagen](http://informatica.gonzalonazareno.org/plataforma/file.php/40/hotlink.gif) para realizar el ejercicio.

## Ejemplo 6: URL amigables con WordPress

Ejercicio: Instala wordpress en tu servidor con el módulo rewrite desactivado, comprueba que las URL no son amigables. Activa el módulo y a continuación configura el blog para que tenga URL amigables (Settings->Permalink).

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->