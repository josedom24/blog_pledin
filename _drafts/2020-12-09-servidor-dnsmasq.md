---
title: 'Configurando un servidor DNS con dnsmasq'
permalink: /2020/12/servidor-dns-dnsmasq/
tags:
  - dns
  - dnsmasq
---

![dnsmasq]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/12/dnsmasq.png){: .align-center }

[dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) es un servicio que nos ofrece varias funcionalidades, entre las más destacadas podemos indicar: servidor DNS, servidor DHCP (con soporte para DHCPv6), servidor PXE y servidor TFTP. Este servidor es muy apropiado para redes pequeñas donde necesitamos que nuestros clientes puedan resolver nombres, recibir automáticamente la configuración de red o crear un sistema para arrancar por red. En este artículo nos vamos a centrar en las posibilidades que nos ofrece dnsmasq como servidor DNS.

## dnsmasq como servidor DNS

dnsmasq nos ofrece un servidor DNS forward y caché. Es decir cuando preguntamos a un servidor DNS dnsmasq y no tiene definida la resolución del nombre, preguntará a los servidores DNS que tenga definido en su sistema (en el archivo `/etc/resolv.conf`) y a continuación guardará la resolución en caché, para que si hay una futura petición al mismo nombre se responda desde la caché. 

Es muy conveniente tener un servidor DNS en nuestra red local, ya que al usar una caché para guardar las resoluciones, las consultas de los clientes se aceleran, al no tener que preguntar a un servidor DNS externo. Además, si definimos nombres en el servidor dnsmasq, todos los clientes de las red podrán consultar dichos nombres.

Tenemos tres maneras para definir nombres (y distintos tipos de registros DNS) en dnsmasq:

1. Escribiendo los registros directamente en el fichero de configuración.
2. Todos los nombres que estén definidos en el fichero `/etc/hosts` del servidor podrán ser también consultados desde los clientes. Es decir, todos los nombres definidos en `/etc/hosts` serán entendido como un registro A / AAAA / PTR. Por lo tanto se podrá hacer la resolución directa e inversa.
3. Si se ha habilitado el servicio DHCP y se han declarado reservas de máquinas indicando su nombre, se asignará dinámicamente este nombre en el servicio DNS.

<!--more-->

## Instalación y configuración inicial de dnsmasq

Vamos a instalar y configurar el servidor dnsmasq en un sistema operativo Linux, usando la distribución Debian Buster. Para la instalación ejecutamos como superusuario:

    # apt install dnsmasq

El fichero de configuración lo encontramos en `/etc/dnsmasq.conf`. Es un fichero con muchos comentarios que explican todos los parámetros de configuración. En un primer momento podemos configurar los siguientes parámetros:

* `strict-order`: Podemos descomentar está línea para que las consultas que haga el servidor DNS a los servidores definidos en `/etc/resolv.conf` la haga en el orden que están definidos en ese fichero. El comportamiento por defecto de dnsmasq es hacer preguntas a los servidor DNS definidos en el sistema de una forma aleatoria.
* `intereface`: Otro parámetro que nos puede interesar determinar es la interfaz de red por la que vamos a permitir consultas a nuestros servidor DNS. En mi caso, puedo configurar este parámetro de esta manera: `interface=eth0`.

A continuación reinicio el servicio:

    # systemctl restart dnsmasq.service

Y ya puedo configurar el servidor DNS del cliente indicando nuestro servidor (en mi caso tiene la IP 172.22.200.203) en el fichero `/etc/resolv.conf`:

    nameserver 172.22.200.203

A continuación podemos empezar a hacer consultas desde el cliente.

## El servidor dnsmasq es un servidor DNS forward caché

Desde el cliente podemos preguntar por la dirección de un nombre y comprobamos que dnsmasq es capaz de resolverlo, para ello preguntará a los servidores DNS recursivos que tiene definido en su sistema. Desde el cliente hacemos una consulta:

    $ dig www.josedomingo.org
    ...
    ; ANSWER SECTION:
    www.josedomingo.org.	891	IN	CNAME	playerone.josedomingo.org.
    playerone.josedomingo.org. 891	IN	A	137.74.161.90

    ;; Query time: 371 msec
    ;; SERVER: 172.22.200.203#53(172.22.200.203)
    ...

Además podemos comprobar la caché, si volvemos hacer la consulta la resolución se hará más rápida (anteriormente fue de 371 ms):

    $ dig www.josedomingo.org
    ...
    ; ANSWER SECTION:
    www.josedomingo.org.	891	IN	CNAME	playerone.josedomingo.org.
    playerone.josedomingo.org. 891	IN	A	137.74.161.90

    ;; Query time: 2 msec
    ;; SERVER: 172.22.200.203#53(172.22.200.203)
    ...   

  Esta segunda consulta se ha resuelto en 2 ms ya que la resolución se guardó en la caché de dnsmasq.

## Definiendo nombres en el fichero /etc/hosts

Ya hemos comprobado que nuestro servidor dnsmasq es capaz de resolver nombres que no tiene definido, preguntando a los servidores DNS definidos en su sistema y posteriormente guardando la resolución en caché. Además vamos a ver la primera forma que tenemos de definir nombres que puedan ser resueltos por los clientes. Este primer método nos permite que todos los nombres definidos en el fichero `/etc/hosts` del servidor puedan ser consultados por el cliente (son entendido como registros A / AAAA para la resolución directa y como registros PTR para la resolución inversa). Si añadimos en el fichero `/etc/hosts` del servidor los siguientes nombres:

    172.22.200.203 www.example.org
    172.22.200.204 www.example.com

Reiniciamos el servidor dnsmasq, y podemos comprobar que desde el cliente podemos consultarlos (resolución directa y resolución inversa):

    $ dig +short www.example.org
    172.22.200.203
    $ dig +short www.example.com
    172.22.200.205
    
    $ dig +short -x 172.22.200.203
    www.example.org.
    $ dig +short -x 172.22.200.204
    www.example.com.

Podemos comprobar que estamos trabajando con nombres en distintos dominios, no estamos usando el concepto de zona DNS. Todos los nombres que pongamos en el fichero `/etc/hosts` del servidor podrán ser consultados por los clientes independientemente del dominio que tengan.

## Definiendo registros DNS en la configuración de dnsmasq

Para definir registros A (resolución directa) y PTR (resolución inversa), además de declararlos en el fichero `/etc/hosts`, podemos declararlos en la configuración de dnsmasq con el parámetro `host-record`, en este caso en el fichero de configuración `/etc/dnsmasq.conf` añadimos estás dos lineas, para declarar dos nombres:

    host-record=foo.example.org,172.22.200.205
    host-record=foo.example.com,172.22.200.206

Y desde el cliente comprobamos las resoluciones:

    $ dig +short foo.example.org
    172.22.200.205
    $ dig +short foo.example.com
    172.22.200.206
    
    $ dig +short -x 172.22.200.205
    foo.example.org.
    $ dig +short -x 172.22.200.206
    foo.example.com.

También podemos declarar un registro CNAME, para ello usamos la directiva `cname`, por ejemplo podemos definir un alias con la siguiente directiva:

    cname=ftp.example.org,www.example.org

Y podemos hacer la consulta desde el cliente:

    $ dig +short ftp.example.org
    www.example.org.
    172.22.200.203

Para declarar un registro MX, para indicar el servidor de correo de un dominio, usamos la directiva `mx-host`, donde indicamos el nombre de dominio, el nombre del servidor y la prioridad del servidor de correos. Por ejemplo, podemos declara un registro A para el servidor de correos y el registro MX de la siguiente manera:

    host-record=mail.example.org,172.22.200.207
    mx-host=example.org,mail.example.org,10

Y realizar una consulta desde el cliente:

    $ dig mx example.org
    ...
    ;; ANSWER SECTION:
    example.org.		0	IN	MX	10 mail.example.org.

    ;; ADDITIONAL SECTION:
    mail.example.org.	0	IN	A	172.22.200.207
    ...

Podemos declarar más tipos de registros DNS (SRV, TXT ,...), puedes ver los comentarios del fichero de configuración para aprender a declararlos.

## Definición de zonas en dnsmasq

Hasta el momento hemos estado resolviendo nombres en distintos dominios. Sin embargo, dnsmasq nos da la posibilidad de crear zonas DNS relacionadas a un nombre de dominio donde vamos a definir el servidor con autoridad sobre la zona (registro NS).

Para ello vamos a crear un fichero con la configuración general relativa al servicio DNS, esto es, configuración común a todas las zonas que pretendiéramos definiremos. Sería el fichero `/etc/dnsmasq.d/dns.conf`, con el siguiente contenido:

    #log-queries 
    no-hosts  
    expand-hosts 

Los parámetros indicados son los siguientes:

* `log-queries`: Puede descomentarse para depuración.
* `no-hosts`: Si no queremos consultar `/etc/hosts`
* `expand-hosts`: Nos permite asignar nuevos ficheros `hosts` en las distintas zonas.

Y podemos definir una zona en el fichero `/etc/dnsmasq.d/example.conf`:

    auth-zone=example.net
    auth-soa=1,root.example.net,604800,86400,2419200
    auth-server=ns.example.net
    addn-hosts=/etc/hosts.d/hosts_example_net

    #Registros A/AAAA/PTR
    host-record=ns.example.net,10.0.0.1
    host-record=mail.example.net,10.0.0.2

    # Registro MX
    mx-host=example.net,mail.example.net,10

    # CNAMEs
    cname=smtp.example.net,mail
    cname=imap.example.net,mail

En el fichero `/etc/hosts.d/hosts_example_net` hemos añadido un nombre, para comprobar que también se puede resolver:

    10.0.0.3 www.example.net

Veamos los distintos parámetros que hemos definido:

* `auth-zone`: Se define el nombre de dominio correspondiente a la zona que estamos definiendo.
* `auth-soa`: Definimos el registro SOA, donde indicamos el número de serie, el correo de contacto y los tiempos (Refresh, Retry y Expire)
* `auth-server`: Se declara el registros NS, es decir el nombre del servidor DNS sobre la zona.
* `addn-hosts`: Indicamos un fichero de hosts donde podemos añadir resoluciones que serán añadidas como registros (A/AAAA/PTR).
* La definición de los distintos tipos de registros.

Y ya podemos realizar las pruebas de resolución:

    $ dig ns example.net
    ...
    ;; ANSWER SECTION:
    example.net.		600	IN	NS	ns.example.net.
    ...

    $ dig mx example.net
    ...
    ;; ANSWER SECTION:
    example.net.		600	IN	MX	10 mail.example.net.
    ...

    $ dig ns.example.net
    ...
    ;; ANSWER SECTION:
    ns.example.net.		600	IN	A	10.0.0.1
    ...

    $ dig smtp.example.net
    ...
    ;; ANSWER SECTION:
    smtp.example.net.	600	IN	CNAME	mail.example.net.
    mail.example.net.	600	IN	A	10.0.0.2
    ...

    $ dig www.example.net
    ...
    ;; ANSWER SECTION:
    www.example.net.	600	IN	A	10.0.0.3
    ...

    $ dig -x 10.0.0.2
    ...
    ;; ANSWER SECTION:
    2.0.0.10.in-addr.arpa.	0	IN	PTR	mail.example.net.
    ...

## Conclusiones

Hemos visto una introducción al uso de dnsmasq como servidor DNS. El uso de este servicio puede ser muy adecuado para la resolución de nombres en una red local, ya que como hemos visto además de poder crear una zona con la definición de los distintos tipos de registros DNS, podemos simplemente definir los nombres que queremos que nuestros clientes puedan resolver introduciéndolos en el fichero `/etc/hosts` del servidor. Además al ser un servidor DNS caché las resoluciones que van haciendo los clientes se quedan guardadas en el servidor, con lo que se acelerará la resolución de nombres. Como siempre para más información estudiar la documentación del servicio.











