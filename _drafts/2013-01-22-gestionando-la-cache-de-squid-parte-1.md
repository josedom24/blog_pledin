---
id: 693
title: Gestionando la caché de Squid (parte 1)
date: 2013-01-22T12:28:32+00:00


guid: http://www.josedomingo.org/pledin/?p=693
permalink: /2013/01/gestionando-la-cache-de-squid-parte-1/


tags:
  - Caché
  - html
  - Proxy
  - Squid
---

Squid es un popular programa de software libre que implementa un servidor proxy y una caché de páginas web, publicado bajo licencia GPL. En este artículo nos vamos a centrar en el estudio de la funcionalidad de caché de la aplicación.

## Cómo funciona la caché de Squid

Partimos de la siguiente situación: tenemos instalado squid3 en una máquina virtual con el sistema operativo Debian Wheezy y un navegador en la máquina anfitriona está configurado para usar el proxy (además en este navegador hemos desactivado la función de caché local, que provoca algunos problemas con al caché de squid y que estudiaremos en la siguiente entrega de este documento) y vamos acceder desde este navegador a una página html almacenada en un servidor web apache2 instalado en otra máquina virtual.

### Gestión de la cache por mecanismos de validación

En este mecanismo el servidor comprueba si la respuesta que mantiene cacheada el navegador sigue siendo válida. Para ello se suele usar la cabecera `Last-Modified`, aunque también podemos usar la `ETag`. En este primer punto vamos a acceder a la página html, y sólo va a entrar en juego el parámetro de cabecera `Last-Modified`. Una vez cacheada la página, si volvemos acceder a ella se preguntará al servidor si se ha modificado, el servidor responderá con la cabecera HTTP, y si la copia que tenemos es valida (no se ha modificado recientemente) se servirá directamente.

En este caso al refrescar la página con F5 nos vamos encontrando en el fichero `access.log` (este fichero se encuentra en `/var/log/squid3/access.log`)  de squid con información del tipo `TCP_MEM_HIT` o `TCP_HIT`, es decir acierto en la cache. Para más información sobre la información que se guarda en el fichero access.log puedes mirar la siguiente <a href="http://www.linofee.org/~jel/proxy/Squid/accesslog.shtml">página</a>.

Si modificamos la página, el servidor cambiará el parámetro `Last-Modified` y por tanto la copia que tenemos almacenada ya no será válida, por lo que nos bajaremos del servidor la página modificada y la volveremos almacenar. En este caso nos encontraremos en el fichero `access.log` una línea del tipo `TCP_REFRESH_MODIFIED`, indicando que la página accedida ha sido modificada.

Si simulamos que se ha perdido la conexión con el servidor, parando el servicio apache2 en el segundo servidor, aunque se intenta verificar con el servidor si la página ha sido modificada (`TCP_REFRESH_FAIL`), se seguirá sirviendo la copia que tenemos en la cache.

### Gestión de la cache por mecanismos de frescura

Tanto el método `Last-Modified` como `ETag`requieren que el navegador se comunique con el servidor para comprobar la versión del fichero. En los mecanismos por **frescura** en cambio cada repuesta lleva asociada una fecha de caducidad (como un yogurt) y puede ser utilizada sin necesidad de que el servidor compruebe su validez. Existen dos formas de implementar este mecanismo, con el parámetro `Expires` (se asigna una fecha de caducidad al fichero) o el `max-age`(la fecha de caducidad se expresa de manera relativa en segundos). Para nuestro ejemplo vamos a usar la cabecera `expires`.

Como hemos indicado, el parámetro `Expires` de la cabecera de un mensaje HTTP indica cuando o cada cuanto tiempo la página guardada en caché no es válida y por lo tanto hay que bajarse otra del servidor. Para cambiar este parámetro de la cabecera vamos a usar el módulo `mod_expire` de Apache2. Para ello nos aseguramos que está activo:

    a2enmod expires

Y modificamos el fichero de configuración `default` de la siguiente manera:

    <Directory /var/www/>
      ExpiresActive On
      ExpiresDefault "access plus 3 seconds"
    ...

En este caso estamos diciendo que todos los ficheros alojados en `/var/www` tienen una caducidad de 3 segundos. Cada tres segundos se va a obligar a descargarse la nueva copia del servidor.

Puedes comprobar el valor del parámetro usando el comando `HEAD`.

    $ HEAD http://172.22.200.46/index.html

    200 OK
    Cache-Control: max-age=3
    Connection: close
    Date: Tue, 22 Jan 2013 10:16:12 GMT
    Accept-Ranges: bytes
    ETag: "6780-b1-4d3ddd070b75a"
    Server: Apache/2.2.16 (Debian)
    Vary: Accept-Encoding
    Content-Length: 177
    Content-Type: text/html
    Expires: Tue, 22 Jan 2013 10:16:15 GMT
    Last-Modified: Tue, 22 Jan 2013 10:12:25 GMT
    Client-Date: Tue, 22 Jan 2013 10:13:35 GMT</pre>

Si vamos recargando la página con F5 nos daremos cuenta que cada 3 segundos se produce un `TCP_REFRESH_UNMODIFIED`, es decir se obliga a la descarga de la página, durante el tiempo intermedio se supone que la página es válida.

### Como evitar el cacheo de nuestro contenido

En ocasiones el cacheo de contenidos puede interferir con el correcto funcionamiento de la web y por tanto debemos evitarlo. El funcionamiento de la cache se puede controlar con las siguientes directivas:

* **Cache-control: max-age –** Especifica el número máximos de segundos en los que el contenido sera considerado como fresco
* **Cache-control:** **s-maxage** &#8211; Similar a la directiva `max-age`, pero aplicable solo para caches compartidas (por ejemplo squid).
* **Cache-control: public** – indica que la versión cacheada puede ser guardada por proxies y otros servidores intermedios para que todo el mundo tenga acceso a ella..
* **Cache-control: private** – indica que el archivo no es el mismo para usuarios diferentes. De esta manera el archivo puede ser cacheado por el navegador del usuario pero no debe ser cacheado por proxies intermedios.
* **Cache-control: no-cache** – Significa que el archivo no debe ser cacheado, esto puede ser necesario en casos en los que una misma url pueda devolver diferentes contenidos.
* **Cache-control: no-store –** Indica al navegador que sólo guarde el documento el tiempo necesario para mostrarlo.
* **Cache-control: must-revalidate**– Indica a la cache que deben hacer caso a cualquier directiva de cacheo que le indiquemos. Tenga en cuenta que la especificación HTTP permite a las caches atender de manera automática a las peticiones bajo determinadas circunstancias. La directiva `must-revalidete` obliga a la cache a seguir nuestras directivas de manera estricta. La forma de utilizarla es la siguiente: `<meta http-equiv="Cache-Control" content="max-age=3600, must-revalidate`
* **Cache-control: proxy-revalidate –** Similar a _must-revalidate_ pero sólo aplicable a proxy caches.

La directiva `Pragma` tiene el mismo significado que `Cache-control: no-cache` y se suele incluir para asegurarnos la compatibilidad con versiones anteriores a HTTP/1.0.

Para poder modificar este parámetro vamos a usar el `mod_headers` de apache2, para ello nos aseguramos que este activo:

    a2enmod headers

A continuación podemos modificar el fichero de configuración `default` y añadir las siguiente líneas para evitar que se pueda cachear nuestro documento html:

    <Directory /var/www/>
      Header set Cache-Control "private, no-cache, no-store"
      Header set Pragma "no-cache"
    ...

Comprobamos las cabeceras con el comando HEAD:

    HEAD http://172.22.200.46/index.html

    200 OK
    Cache-Control: private, no-cache, no-store
    Connection: close
    Date: Tue, 22 Jan 2013 10:49:07 GMT
    Pragma: no-cache
    Accept-Ranges: bytes
    ETag: &#8220;6780-b1-4d3ddd070b75a&#8221;
    Server: Apache/2.2.16 (Debian)
    Vary: Accept-Encoding
    Content-Length: 177
    Content-Type: text/html
    Last-Modified: Tue, 22 Jan 2013 10:12:25 GMT
    Client-Date: Tue, 22 Jan 2013 10:46:30 GMT
    Client-Peer: 172.22.200.46:80
    Client-Response-Num: 1

En este caso cuando vamos refrescando nuestra página en el navegador obtenemos un mensaje `TCP_MISS` en el fichero access.log indicando que nuestro documento no ha sido almacenado.

En la <a href="http://www.josedomingo.org/pledin/2013/02/gestionando-la-cache-de-squid-parte-2/">próxima entrega</a> de este documento veremos como ignorar estos parámetros de control de la caché y forzar el cacheo de determinados objetos, además estudiaremos la problemática de la caché de los navegadores cuando estamos usando Squid.

He cogido mucha información de la página: <a href="http://www.hellogoogle.com/tutorial-cache-web/">http://www.hellogoogle.com/tutorial-cache-web/</a>

