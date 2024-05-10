---
id: 864
title: Configurar subdominios en bind9
date: 2013-11-21T17:24:45+00:00


guid: http://www.josedomingo.org/pledin/?p=864
permalink: /2013/11/configurar-subdominios-en-bind9/


tags:
  - dns
  - Manuales
---

El objetivo de este artículo es estudiar las distintas formas que tenemos en el servidor dns bind9 para gestionar la creación de un subdominio de nuestro dominio principal.

Por ejemplo, tenemos el dominio `example.org` y queremos crear un subdomio `es.example.org`, por lo que podríamos tener los siguientes nombres:

* Nombre de dominio principal: **example.org**
* Nombre de un host en el dominio principal: **www.example.org**
* Nombre del subdominio: **es.example.org**
* Nombre de un host en el subdominio: **www.es.example.org**

Para conseguir configurar subdominios tenemos dos alternativas:

* **Crear un subdominio virtual**, en este caso es un sólo servidor DNS el que va a tener autoridad sobre el dominio y sobre el subdomio.
* **Delegar el subdomio**, es decir el servidor DNS autorizado para el dominio va a delegar la gestión y autorización del subdominio a otro servidor DNS.

## Crear un subdominio virtual

En este caso suponemos de tenemos configurado un servidor DNS donde hemos configurado la zona `example.org` en el fichero `/var/cache/bind/db.example.org`. La configuración del subdominio virtual se ha indicado en negrita, y quedaría de la siguiente manera:

    $TTL    86400
    @       IN      SOA     ns1.example.org. mail.example.org. (
                                  4         
                             604800         
                              86400         
                            2419200       
                              86400 )       

    $ORIGIN example.org.
    @       IN      NS      ns1

    ns1     IN      A       10.0.10.2
    www     IN      A       10.0.10.1

    $ORIGIN es.example.org.
    www     IN      A      10.10.0.3


Después de reiniciar el servidor podemos hacer una consulta con la utilidad `dig`, de la siguiente manera:

    $ dig @10.0.10.2 www.es.example.org

    ; <<<<>>>> DiG 9.8.4-rpz2+rl005.12-P1 <<<<>>>> @10.0.10.2 www.es.example.org
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>>>HEADER<<<<- opcode: QUERY, status: NOERROR, id: 61235
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

    ;; QUESTION SECTION:
    ;www.es.example.org.		IN	A

    ;; ANSWER SECTION:
    www.es.example.org.	86400	IN	A	10.10.0.3

    ;; AUTHORITY SECTION:
    example.org.		86400	IN	NS	ns1.example.org.

    ;; ADDITIONAL SECTION:
    ns1.example.org.	86400	IN	A	10.0.10.2

    ;; Query time: 0 msec
    ;; SERVER: 10.0.10.2#53(10.0.10.2)
    ;; WHEN: Thu Nov 21 15:27:26 2013
    ;; MSG SIZE  rcvd: 86


Donde podemos observar que la resolución se hace correctamente, y como señalamos anteriormente el servidor con autoridad (registro NS) es el servidor `ns1.example.org` que, en realidad, es el servidor con autoridad del dominio `example.org`.

## Delegación de subdominios

En esta ocasión partimos de un servidor DNS con autoridad sobre el dominio `example.org` (`ns1.example.org`), que va a delegar la gestión del subdominio `es.example.org` a otro servidor DNS (`nssub.es.example.org`). Veamos la configuración de los servidores:

### Configuración del servidor DNS del dominio principal (example.org)

La zona está definida en el fichero `/var/cache/bind/db.example.org`, donde tendremos que indicar cual es el servidor DNS con autoridad para el subdominio, es decir indicaremos el servidor DNS al que vamos a delegar la gestión del subdominio `es.example.org`, que en nuestro caso será `nssub.es.example.org`. Indicamos en negrita la configuración necesaria:

    $TTL    86400
    @       IN      SOA     ns1.example.org. mail.example.org. (
                                  4         
                             604800    
                              86400     
                            2419200   
                              86400 )   

    $ORIGIN example.org.
    @       IN      NS      ns1

    ns1     IN      A       10.0.10.2
    www     IN      A       10.0.10.1

    $ORIGIN es.example.org.
    @       IN      NS      nssub
    nssub   IN      A       10.0.10.6


Como podemos observar el servidor DNS con autoridad sobre la zona `es.example.org`, será `nssub.es.example.org` que se encuentra en la dirección 10.0.10.6.

### Configuración del servidor DNS del subdominio (es.example.org)

Ahora configuramos el segundo servidor DNS (`nssub.es.example.org`), al que vamos a delegar la gestión del dominio `es.example.org`. Lo primero que tenemos que hacer es definir la zona que corresponde con el subdominio en el fichero `/etc/bind/named.conf.local`:

    zone "es.example.org" {
      type master;
      file "db.es.example.org";
    };

Y el fichero `/var/cache/bind/db.es.example.org`, quedaría:

    $TTL    86400
    @       IN      SOA     nssub.es.example.org. mail.es.example.org. (
                                  4         
                             604800    
                              86400     
                            2419200   
                              86400 )   
    $ORIGIN es.example.org.
    @         IN      NS      nssub
    nssub     IN      A       10.0.10.6
    www       IN      A       10.0.10.3

Ya estamos en disposición de consultar nombres de nuestro subdominio:

    $ dig @10.0.10.2 www.es.example.org

    ; <<<<>>>> DiG 9.8.4-rpz2+rl005.12-P1 <<<<>>>> @10.0.10.2 www.es.example.org
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>>>HEADER<<<<- opcode: QUERY, status: NOERROR, id: 16747
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;www.es.example.org.		IN	A

    ;; ANSWER SECTION:
    www.es.example.org.	86400	IN	A	10.0.10.3

    ;; AUTHORITY SECTION:
    es.example.org.		86400	IN	NS	nssub.es.example.org.

    ;; Query time: 704 msec
    ;; SERVER: 10.0.10.2#53(10.0.10.2)
    ;; WHEN: Thu Nov 21 16:09:58 2013
    ;; MSG SIZE  rcvd: 72

Donde de nuevo comprobamos que la resolución se hace de forma adecuada, pero en esta ocasión la está haciendo el servidor con autoridad sobre el subdominio, en este caso `nssub.es.example.org`.

* * *

**Actualización (19/11/2015)**

Durante la realización de esta práctica en este curso, hemos experimentado que siguiendo este manual, en la infraestructura que tenemos en nuestro instituto la delegación de subdominios no funcionaba.

Por seguridad, en nuestro cortafuego tenemos configurado que el único servidor DNS que puede hacer consultas al exterior (puerto 25 UTP) es nuestro servidor DNS principal. Por lo tanto los servidores DNS que instalan los alumnos se tienen que configurar como _forwarders_ (si tienen que resolver una consulta de una zona de la que no tienen autoridad preguntan al servidor DNS principal del instituto), para ello en el fichero `/etc/bind/named.conf.options`, descomentamos y configuramos de forma adecuada la sección de `forwarders`.

Con esta configuración cuando consultamos un nombre de subdominio, nuestro servidor DNS detecta que no tiene autoridad sobre él, y pregunta al servidor DNS que hemos indicado en el forwarders, no hace la delegación.

Para solucionar este problema tendríamos que anular la función de forwarders para la zona example.org, para ello en el fichero `/etc/bind/named.conf.local`, donde definimos las zonas DNS, configuramos el siguiente parámetro:

    zone "example.org" {
        type master;
        file "db.example.org";
        forwarders { };
    };

