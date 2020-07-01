---
title: 'Hacer streaming de vídeo usando software libre'
permalink: /2020/07/streaming-video-software-libre/
tags:
  - rtmp
  - obs
  - vídeo
---

![nginx](({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/07/nginx.jpg){: .align-center })

En este artículo voy a documentar mi experiencia montando un sistema para poder realizar un streaming de vídeo usando software libre. En mi [instituto](https://dit.gonzalonazareno.org) hemos usado en estos meses [jitsi](https://meet.jit.si/) para realizar videoconferencias entre los profesores y para impartir las clases a los alumnos. Al final de curso teníamos que celebrar el claustro final y montamos un sistema de streaming para emitir la videconferencia jitsi donde se encontraban los compañeros que iban a intervenir. Evidentemente con los medios que tenemos no era posible tener una videoconferencia para unas 60 personas, pero queríamos que todos los profesores pudieran seguir el claustro en directo. Por lo que días antes nos pusimos a estudiar alternativas (por supuesto, usando **software libre**) y os cuento los pasos que fuimos dando:

## El protocolo RTMP

El primer artículo que encontramos fue: [Create your own video streaming server with Linux](https://opensource.com/article/19/1/basic-live-video-streaming-server) y nos encontramos la definición del protocolo que íbamos a usar para realizar el streaming: **el protocolo RTMP**.

> El protocolo RTMP (Real-Time Messaging Protocol) se usa para los servicios streaming, trabaja sobre TCP (Transmission Control Protocol) y usa por defecto el puerto 1935. Permite al cliente controlar la calidad de distribución de la transmisión y seguridad.

Para más información sobre este protocolo puedes leer el siguiente [documento](http://profesores.elo.utfsm.cl/~agv/elo322/1s19/projects/reports/Protocolo_RTMP.pdf).

Además aprendimos que podíamos implementarlo usando un módulo del servidor web nginx.

<!--more-->

### Configurando un servidor RTMP con nginx

Vamos a explicar los pasos para configurar nginx para que funcione como un servidor RTMP. Para ello vamos a usar el sistema operativo Debian Buster donde tenemos instalado un servidor nginx. Al ordenador en el que tenemos el servidor instalado vamos a acceder con el nombre `video.josedomingo.org`.

Lo primero que vamos a hacer es instalar el módulo `rtmp` de nginx:

    apt install libnginx-mod-rtmp

A continuación vamos a hacer una configuración mínima del servidor rtmp, para ello en el fichero `/etc/nginx/nginx.conf` añadimos lo siguiente:

    rtmp {
            server {
                    listen 1935;
                    chunk_size 4096;

                    application live {
                            live on;
                            record off;
                    }
            }
    }

Reiniciamos el servidor:

    systemctl restart nginx

Y ya podemos probarlo.

## Transmitiendo vídeo con OBS

[OBS, Open Broadcast Software](https://obsproject.com/es) es una aplicación libre y de código abierto para la grabación y transmisión de vídeo por internet (streaming), mantenida por *OBS Project*. 

Para configurar OBS para transmitir vídeo a nuestro servidor rtmp, vamos a la opción **Configuración** -> **Emisión**, en **Tipo de Emisión** elegimos la opción *Personalizar el servicio de retransmisión* e indicamos los siguientes datos:

* URL: La URL de nuestro servidor rtmp, en nuestro caso sería `rtmp://video.josedomingo.org/live`
* Clave de retransmisión: Es una cadena de caracteres qe identifica la retransmisión y que posteriormente usaremos para ver el streaming, en nuestro caso vamos a poner `test`.

![obs](({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/07/obs.png){: .align-center })

Después de que [configuremos el vídeo](https://www.popcornstudio.es/open-broadcaster-software) que queremos transmitir, ya podemos elegir la opción **Iniciar Transmisión** en la pantalla principal.

Para comprobar que la transmisión se está haciendo de manera adecuada nos debe aparecer una barra de estado, con un cuadro verde (recuerda: verde bueno, rojo malo):

![obs](({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/07/obs2.png){: .align-center })

## Usando VLC para ver el streaming

[VLC](https://www.videolan.org/vlc/index.es.html) es un reproductor multimedia libre y de código abierto multiplataforma y un "framework" que reproduce la mayoría de archivos multimedia, muchos medios de almacenamiento y diversos protocolos de transmisión.

Podemos configurar VLC para visualizar el streaming que estamos haciendo, para ello nos vamos a la opción **Medio** -> **Abrir ubicación de red...** e indicamos la URL de la retransmisión que estaría formada por la URL de nuestro servidor rtmp más la clave de retransmisión que indicamos en OBS: `rtmp://video.josedomingo.org/live/test`:

![vlc](({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/07/vlc.png){: .align-center })

Y en pocos segundos estaríamos viendo la retransmisión en directo:

![vlc](({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/07/vlc2.png){: .align-center })

## Añadiendo más funcionalidad a nuestro servidor de streaming

Parece que nuestro servidor está funcionando de manera adecuada, pero nos encontramos dos limitaciones:

1. Hemos hecho una configuración muy simple. Te puedo asegurar que podemos tener muchas más funcionalidades en nuestro servidor rtmp. Efectivamente buscando por internet llegué a la [documentación oficial del módulo rtmp](https://docs.nginx.com/nginx/admin-guide/dynamic-modules/rtmp/) de nginx y te aseguro que hay que echarle un buen rato. Nos vamos a quedar (nos hará falta posteriormente) con que este módulo nos ofrece tres formatos para acceder al streaming: *Stream Real-Time Messaging Protocol* (**RTMP**), *Apple HTTP Live Streaming* (**HLS**), y *Dynamic Adaptive Streaming over HTTP* (**DASH**).

2. Hemos visualizado el streaming con VLC pero, ¿puedo tener un reproductor de vídeo en una página web que me permita verlo?. He encontrado muchas librerías javascript (luego hablaremos de ellas) que me permiten tener en mi página web un reproductor de vídeo, pero los reproductores que eran capaz de ver vídeos desde rtmp (como hemos hecho con VLC) necesitaban tener instalado en el navegador el plugin flash, no funcionaban con HTML5.

Llegados a este punto y para solucionar estas dos limitaciones (tampoco he tenido mucho tiempo para profundizar en la documentación de rtmp en nginx), me hice la siguiente pregunta: ¿Existirá alguna imagen en docker hub que me ofrezca un servidor rtmp configurado de forma adecuada?

Evidentemente la respuesta es que existen varios, finalmente elegí la imagen `alqutami/rtmp-hls` ([imagen en docker hub](https://hub.docker.com/r/alqutami/rtmp-hls)) que además de ofrecer un servidor completamente configurado, nos ofrece un conjunto de páginas web con distintos reproductores de vídeo que utilizan diferentes tecnologías para funcionar. Lo veremos en el siguiente apartado:

## Instalación de un servidor rtmp usando docker

En nuestro servidor hemos desinstalado el servidor nginx, hemos instalado docker y creamos un contenedor como nos indica la documentación de la imagen:

    docker run -d -p 1935:1935 -p 8080:8080 --name rtmp alqutami/rtmp-hls

Como vemos el puerto 1935 para acceder al servidor rtmp y el puerto 8080 para acceder a las páginas web que nos ofrece el servidor.

    docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                            NAMES
    112f5df28a19        alqutami/rtmp-hls   "nginx -g 'daemon of…"   5 seconds ago       Up 4 seconds        0.0.0.0:1935->1935/tcp, 0.0.0.0:8080->8080/tcp   rtmp

Si queremos profundizar en los parámetros de configuración podemos ejecutar el siguiente comando para visualizar el fichero de configuración:

    docker exec rtmp cat /etc/nginx/nginx.conf

Para emitir con OBS y visualizar con VLC lo haríamos exactamente como lo hemos estudiado anteriormente. Veamos lo nuevo que nos ofrece esta imagen:

## Nuevos protocolos de streaming

Para solucionar la segunda limitación que indicamos anteriormente, este servidor esta configurado para acceder al streaming usando dos nuevos protocolos: 

* HTTP Live Streaming ([HLS](https://en.wikipedia.org/wiki/HTTP_Live_Streaming)): 
* Dynamic Adaptive Streaming over HTTP ([DASH](https://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP)).

Estos protocolos de streaming están basados en HTTP y nos van a permitir tener reproductores de vídeos basados en HTML5.

* Para acceder al streaming usando HLS tendríamos que acceder a la siguiente URL: `http://<server ip>:8080/hls/<stream-key>.m3u8`, donde indicaremos la ip o el nombre del servidor y la clave de retransmisión.
* Para acceder al streaming usando DASH tendríamos que acceder a la siguiente URL: `http://<server ip>:8080/dash/<stream-key>_src.mpd`, donde, de la misma forma,  indicaremos la ip o el nombre del servidor y la clave de retransmisión.

Puedes probar desde VLC a reproducir desde una ubicación de red indicando estas URLs:

* `http://video.josedomingo.org:8080/hls/test.m3u8`
* `http://video.josedomingo.org:8080/dash/test_src.mpd`

## Reproductores de vídeos disponibles

La imagen docker que estamos usando nos ofrece varias páginas web de demostración con distintos reproductores de vídeo que funcionan con los distintos protocolos. Estás páginas de demostración están configuradas para reproducir vídeos desde `localhost` y usando la clave de reproducción `test`. Por lo tanto lo que vamos a hacer es copiarnos los ficheros html a nuestro ordenador, modificar las páginas html a nuestra conveniencia (usando nuestra URL y nuestra clave de reproducción) y volver a crear el contenedor con un volumen para que tenga nuestras versiones de estos ficheros. Vamos a ello:

Lo primero que vamos a hacer es copiarnos en una carpeta que vamos a llamar `players` los ficheros html a nuestro ordenador:

    # docker cp rtmp:/usr/local/nginx/html/players players
    # ls players
    dash.html  hls_hlsjs.html  hls.html  rtmp_hls.html  rtmp.html

Tenemos 5 páginas de ejemplo, por lo tanto:

* Si queremos ver contenido RTMP (requiere flash) accederemos a `http://video.josedomingo.org:8080/players/rtmp.html`
* Si queremos ver contenido HLS accederemos a `http://video.josedomingo.org:8080/players/hls.html`
* Si queremos ver contenido HLS usando la librería hls.js accederemos a `http://video.josedomingo.org:8080/players/hls_hlsjs.html`
* Si queremos ver contenido DASH accederemos a `http://video.josedomingo.org:8080/players/dash.html`
* Si queremos ver contenido rtmp y HLS en la misma página accederemos a `http://video.josedomingo.org:8080/players/rtmp_hls.html`

Para que estas páginas funcionen de manera adecuada debemos modificarlas para indicar nuestra URL y nuestra clave de retransmisión.

A continuación borramos el contenedor y lo volvemos a crear con un volumen para que tenga nuestras versiones de estos ficheros:

    # docker rm -f rtmp
    # docker run -d -p 1935:1935 -p 8080:8080 -v /root/players:/usr/local/nginx/html/players --name rtmp alqutami/rtmp-hls

Y podemos probar por ejemplo con la retransmisión hls:

![rtmp](({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/07/rtmp.png){: .align-center })

Para terminar algunas indicaciones:

* Evidentemente las páginas webs proporcionadas son de demostración y nos pueden servir de guías para añadir a nuestras páginas web los reproductores de vídeo de nuestras retransmisiones.
* Sería muy recomendable la configuración de un proxy inverso para no utilizar el puerto 8080 y configurar el acceso HTTPS.

## Conclusiones

Sin haber profundizando mucho en el tema, la utilización de esta imagen docker nos proporcionó la infraestructura necesaria para retransmitir el claustro final de mi instituto. 

Para el próximo curso y basándonos en esta experiencia, queremos desarrollar un sistema que permita de forma automática retransmitir las videoconferencias en jitsi de los profesores para que los alumnos puedan acceder de forma más cómoda a las clases.

Ya os contaré la experiencia!!!



