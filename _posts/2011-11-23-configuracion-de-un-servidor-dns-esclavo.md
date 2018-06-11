---
id: 560
title: Configuración de un servidor DNS esclavo
date: 2011-11-23T19:23:06+00:00


guid: http://www.josedomingo.org/pledin/?p=560
permalink: /2011/11/configuracion-de-un-servidor-dns-esclavo/

  
tags:
  - dns
  - Manuales
  - Redes
---
Siguiendo con los manuales sobre el servidor DNS Bind9, vamos a realizar la práctica de instalar un servidor esclavo, que contenga la réplica de las configuraciones de zonas que están definidas en el servidor maestro.

Los equipos que van a ser configurados como servidor maestro y esclavo son los siguientes:

* `bobesponja`: Dirección ip 10.0.0.1 -> Servidor dns primario o maestro
* `patricio`: Dirección ip 10.0.0.2 -> Servidor dns secundario o esclavo

Los servidores DNS que vamos a configurar van a tener autoridad para la zona `example.com`.

Antes de empezar vamos a estudiar algunos parámetros en la configuración global del servidor DNS que nos pueden hacer falta a la hora de realizar nuestra configuración. En primer lugar, por defecto, bind9 permite las consultas desde equipos de la misma red, si nuestro servidor secundario está en una red distinta habría que indicarlo explícitamente con la directiva `allow-query`. También vamos a indicar que por defecto no este permitido la transferencia completa de zonas, para ello utilizamos la directiva `allow-transfer`. Por último, aunque no es necesario, podemos crear una ACL para identificar las ip de los servidores esclavos, de esta forma posteriormente podemos utilizar el nombre de la ACL para identificar los dns secundarios. Para ello en el archivo `/etc/bind/named.conf.options` hago las siguientes modificaciones:

    options {
      directory "/var/cache/bind";
      allow-query { 10.0.0.0/24; };
      allow-transfer { none; };
      ...
      auth-nxdomain no;    # conform to RFC1035
      recursion no;
    };

    acl slaves {
      10.0.0.2/24;           // patricio
    };

Vamos a explicar cada una de las directivas:

* `allow-query { 10.0.0.0/24; };`: Red desde donde podemos realizar consultas al DNS.
* `allow-transfer { none; };`: Con este parámetro restringimos la transferencia de zonas a Servidores DNS esclavos que no estén autorizados. Esta es una buena medida de seguridad, ya que evitamos que personas ajenas se enteren de las direcciones IP que están dentro de la zona de DNS de un dominio.
* `acl slaves { 10.0.0.2/24; };`: Listado de acceso (access list) de los servidores de DNS esclavos.

A continuación vamos a configurar la zona de resolución directa para nuestra zona en el servidor maestro, para ello creamos un archivo `db.example.com` para configurar la zona `example.com`, en `/var/cache/bind`:

    @ IN SOA bobesponja.example.com. root.example.com. (
          1 ; Serial
          604800 ; Refresh
          86400 ; Retry
          2419200 ; Expire
          604800 ) ; Default TTL

    @   IN NS bobesponja.example.com.
    @   IN NS patricio.example.com.

    $ORIGIN example.org.
    bobesponja       IN A 10.0.0.1
    patricio	       IN A 10.0.0.2
    www              IN A 10.0.0.3

Suponemos que en la dirección 10.0.0.3 vamos a tener un servidor web. Del mismo modo configuramos la zona de resolución inversa, creando el fichero `db.0.0.10` en el mismo directorio:

    @ IN SOA bobesponja.example.com. root.example.com. (
        1 ; Serial
        604800 ; Refresh
        86400 ; Retry
        2419200 ; Expire
        604800 ) ; Default TTL

    @    IN NS bobesponja.example.com.
    @    IN NS patricio.example.com.

    $ORIGIN 0.0.10.in-addr.arpa.
    1      IN PTR bobesponja.example.com.
    2      IN PTR patricio.example.com.
    3      IN PTR www.example.com.</pre>


A continuación en el fichero `/etc/bind/named.conf.local` definimos las zonas indicando quien puede hacer una petición de resolución de nombre al dominio y a quien le damos permiso para que pueda copiar las zonas, que en este caso solo seria a los servidores de DNS esclavos.

De esta manera en el fichero `/etc/bind/named.conf.local` del servidor maestro:

    zone "example.com" {
        type master;
        file "db.example.com";
        allow-transfer { slaves; };
        notify yes;
    };

    zone "0.0.10.in-addr.arpa" {
        type master;
        file "db.0.0.10";
        allow-transfer { slaves; };
        notify yes;
    };

* `allow-transfer { slaves; };`: Con este parámetro le damos permiso a los servidores esclavos de DNS que puedan hacer una copia de la zona de DNS
* `notify yes;`: El maestro notifica a los secundarios cuando se realicen cambios en sus registros.

En el caso del DNS esclavo tendremos que definir las zonas indicando donde se encuentra en DNS maestro, el fichero `/etc/bind/named.conf.local` del servidor esclavo quedaría de la siguiente forma:

    zone "example.com" {
        type slave;
        masters { 10.0.0.1; };
        file "db.example.com";
    };

    // Archivo para búsquedas inversas
    zone "0.0.10.in-addr.arpa" {
        type slave;
        masters { 10.0.0.1; }
        file "db.0.0.10";
    };

* `masters {  10.0.0.1;  };`: Definimos a quien le debe pedir una copia de la zona de DNS para el dominio example.com que en nuestro caso seria el servidor de DNS primario.

Por último reiniciaremos el servicio de BIND en el servidor primario de DNS antes que los secundarios. Esto lo hacemos con el siguiente comando:

    /etc/init.d/bind9 restart

Después de reiniciar el servicio, verificamos en el el “syslog” que nuestros servidores de DNS secundarios estén copiando la zona de DNS para `example.com`. Encontraremos un registro similar a este:


    Nov 21 21:46:37 dns named[893]: client 10.0.0.2#39128: transfer of 'example.com/IN': IXFR started
    Nov 21 21:46:37 dns named[893]: client 10.0.0.2#39128: transfer of 'example.com/IN': IXFR ended</pre>


  Y ya podemos hacer la prueba de configurar un cliente para que use como servidores DNS nuestras máquinas bobesponja y patricio, y comprobar que si alguna de las dos están apagadas, la otra es la que resuelve.


Un saludo a todos.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->