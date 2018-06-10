---
id: 560
title: Configuración de un servidor DNS esclavo
date: 2011-11-23T19:23:06+00:00
author: admin

guid: http://www.josedomingo.org/pledin/?p=560
permalink: /2011/11/configuracion-de-un-servidor-dns-esclavo/

  
tags:
  - dns
  - Manuales
  - Redes
---
<p style="text-align: justify;">
  Siguiendo con los manuales sobre el servidor DNS Bind9, vamos a realizar la práctica de instalar un servidor esclavo, que contenga la réplica de las configuraciones de zonas que están definidas en el servidor maestro.
</p>

<p style="text-align: justify;">
  Los equipos que van a ser configurados como servidor maestro y esclavo son los siguientes:
</p>

  * bobesponja: Dirección ip 10.0.0.1 -> Servidor dns primario o maestro
  * patricio: Dirección ip 10.0.0.2 -> Servidor dns secundario o esclavo

<p style="text-align: justify;">
  Los servidores DNS que vamos a configurar van a tener autoridad para la zona example.com.
</p>

<p style="text-align: justify;">
  <!--more-->Antes de empezar vamos a estudiar algunos parámetros en la configuración global del servidor DNS que nos pueden hacer falta a la hora de realizar nuestra configuración. En primer lugar, por defecto, bind9 permite las consultas desde equipos de la misma red, si nuestro servidor secundario está en una red distinta habría que indicarlo explícitamente con la directiva 
  
  <em>allow-query. </em> También vamos a indicar que por defecto no este permitido la transferencia completa de zonas, para ello utilizamos la directiva <em>allow-transfer. </em>Por último, aunque no es necesario, podemos crear una ACL para identificar las ip de los servidores esclavos, de esta forma posteriormente podemos utilizar el nombre de la ACL para identificar los dns secundarios. Para ello en el archivo /etc/bind/named.conf.options hago las siguientes modificaciones:
</p>

<pre class="brush: bash; gutter: true; first-line: 1">options {
directory “/var/cache/bind”;
<strong>allow-query { 10.0.0.0/24; } ;
allow-transfer { none; };
</strong>
...

auth-nxdomain no;    # conform to RFC1035
recursion no;
};

<strong>acl slaves {
10.0.0.2/24;           // patricio
};</strong></pre>

Vamos a explicar cada una de las directivas:

<li style="text-align: justify;">
  <strong>allow-query { 10.0.0.0/24; } ;</strong> : Red desde donde podemos realizar consultas al DNS.
</li>
<li style="text-align: justify;">
  <strong>allow-transfer { none; };</strong> : Con este parámetro restringimos la transferencia de zonas a Servidores DNS esclavos que no estén autorizados. Esta es una buena medida de seguridad, ya que evitamos que personas ajenas se enteren de las direcciones IP que están dentro de la zona de DNS de un dominio.
</li>
<li style="text-align: justify;">
  <strong>acl slaves { 10.0.0.2/24; };</strong> : Listado de acceso (access list) de los servidores de DNS esclavos.
</li>

<p style="text-align: justify;">
  A continuación vamos a configurar la zona de resolución directa para nuestra zona en el servidor maestro, para ello creamos un archivo db.example.com para configurar la zona example.com, en /var/cache/bind:
</p>

<pre class="brush: applescript; gutter: true; first-line: 1">@ IN SOA bobesponja.example.com. root.example.com. (
    1 ; Serial
    604800 ; Refresh
    86400 ; Retry
    2419200 ; Expire
    604800 ) ; Default TTL

@   IN NS bobesponja.example.com.
@   IN NS patricio.example.com.

$ORIGIN example.org.
bobesponja       IN A 10.0.0.1
patricio	 IN A 10.0.0.2
www              IN A 10.0.0.3</pre>

<p style="text-align: justify;">
  Suponemos que en la dirección 10.0.0.3 vamos a tener un servidor web. Del mismo modo configuramos la zona de resolución inversa, creando el fichero db.0.0.10 en el mismo directorio:
</p>

<pre class="brush: applescript; gutter: true; first-line: 1">@ IN SOA bobesponja.example.com. root.example.com. (
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

<p style="text-align: justify;">
  A continuación en el fichero /etc/bind/named.conf.local definimos las zonas indicando quien puede hacer una petición de resolución de nombre al dominio y a quien le damos permiso para que pueda copiar las zonas, que en este caso solo seria a los servidores de DNS esclavos.
</p>

<p style="text-align: justify;">
  De esta manera en el fichero /etc/bind/named.conf.local del servidor maestro:
</p>

<pre class="brush: applescript; gutter: true; first-line: 1">zone "example.com" {
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
};</pre>

<li style="text-align: justify;">
  <strong>allow-transfer { slaves; };</strong> Con este parámetro le damos permiso a los servidores esclavos de DNS que puedan hacer una copia de la zona de DNS
</li>
<li style="text-align: justify;">
  <strong>notify yes;</strong> El maestro notifica a los secundarios cuando se realicen cambios en sus registros.
</li>

<p style="text-align: justify;">
  En el caso del DNS esclavo tendremos que definir las zonas indicando donde se encuentra en DNS maestro, el fichero /etc/bind/named.conf.local del servidor esclavo quedaría de la siguiente forma:
</p>

<pre class="brush: applescript; gutter: true; first-line: 1">zone "example.com" {
    type slave;
    masters { 10.0.0.1; };
    file "db.example.com";
};

// Archivo para búsquedas inversas
zone "0.0.10.in-addr.arpa" {
    type slave;
    masters { 10.0.0.1; }
    file "db.0.0.10";
};</pre>

<li style="text-align: justify;">
  <strong>masters {  10.0.0.1;  };</strong> Definimos a quien le debe pedir una copia de la zona de DNS para el dominio example.com que en nuestro caso seria el servidor de DNS primario.
</li>

<p style="text-align: justify;">
  Por último reiniciaremos el servicio de BIND en el servidor primario de DNS antes que los secundarios. Esto lo hacemos con el siguiente comando:
</p>

<pre class="brush: applescript; gutter: false; first-line: 1">/etc/init.d/bind9 restart</pre>

<p style="text-align: justify;">
  Después de reiniciar el servicio, verificamos en el el “syslog” que nuestros servidores de DNS secundarios estén copiando la zona de DNS para example.com. Encontraremos un registro similar a este:
</p>

<pre class="brush: applescript; gutter: true; first-line: 1">Nov 21 21:46:37 dns named[893]: client 10.0.0.2#39128: transfer of 'example.com/IN': IXFR started
Nov 21 21:46:37 dns named[893]: client 10.0.0.2#39128: transfer of 'example.com/IN': IXFR ended</pre>

<p style="text-align: justify;">
  Y ya podemos hacer la prueba de configurar un cliente para que use como servidores DNS nuestras máquinas bobesponja y patricio, y comprobar que si alguna de las dos están apagadas, la otra es la que resuelve.
</p>

Un saludo a todos.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->