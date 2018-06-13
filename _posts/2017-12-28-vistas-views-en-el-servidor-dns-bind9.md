---
id: 1885
title: Vistas (views) en el servidor DNS Bind9
date: 2017-12-28T14:02:13+00:00


guid: https://www.josedomingo.org/pledin/?p=1885
permalink: /2017/12/vistas-views-en-el-servidor-dns-bind9/


tags:
  - bind9
  - dns
---
[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/12/bind9.png" alt="" width="350" height="200" class="aligncenter size-full wp-image-1891" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/12/bind9.png){.thumbnail}
  
En alguna circunstancia nos puede interesar que un mismo nombre que resuelve nuestro DNS devuelva direcciones IP distintas según en que red este conectada el cliente que realiza la consulta. Por ejemplo:

  * Si tenemos un servidor DNS que da servicio a internet y a intranet. Si se realiza la consulta desde internet, por ejemplo al nombre `www.example.org` debe devolver a la IP pública, sin embargo si se hace la misma consulta desde la intranet la resolución deberá ser a una IP privada.
  * Otro ejemplo es en la resolución de nombres de instancias de OpenStack. En este caso una instancia tiene asignada una IP privada en el rango en el que hemos configurado la red interna, además puede tener asignada una IP flotante en el rango de la configuración que hayamos hecho de la red externa. En este caso sería deseable que cuando hago una consulta desde el exterior me resuelva con la IP flotante, y cuando haga una consulta desde otra instancia conecta da a la red interna me devuelva la dirección fija asignada a la instancia.

Vamos a ver un ejemplo del uso de vistas (views) en bind9 para configurar dos zonas diferenciadas para el mismo nombre de dominio y que se utilicen según desde donde se solicite la resolución.

## Escenario de nuestro ejemplo

Hemos creado una instancia en OpenStack con el siguiente esquema de red:

[<img src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/12/os.png" alt="" width="363" height="80" class="alignnone size-full wp-image-1888" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2017/12/os.png){.thumbnail}

La red interna tiene como direccionamiento 10.0.0.0/24 y la red externa 172.22.0.0/16. Vamos a configurar bind9 para que cuando se consulte el nombre del servidor desde la red externa devuelva la ip flotante (172.22.0.129) y cuando la consulta se realice desde la red interna se devuelva la ip fija (10.0.0.13).

## Uso de vistas en bind9

Al utilizar &#8220;views&#8221; en bind9 vamos a tener zonas diferencias según el origen de la consulta. Por lo tanto vamos a crear dos &#8220;acl&#8221; par filtrar las redes desde las que se hacen las consultas y posteriormente dentro de cada vista definiremos las zonas con autoridad del servidor. De esta manera el fichero `/etc/bind/named.conf.local` quedaría de la siguiente manera:

<!--more-->

    acl interna { 10.0.0.0/24; localhost; };
    acl externa { 172.22.0.0/16; };
    view todas {
        match-clients { interna; externa;}; 
    
    
    };  
    
    view interna {
        match-clients { interna; };
        allow-recursion { any; };   
    
            zone "example.org"
            {
                    type master;
                    file "db.interna.example.org";
            };
            zone "0.0.10.in-addr.arpa"
            {
                    type master;
                    file "db.0.0.10";
            };
            include "/etc/bind/zones.rfc1918";
            include "/etc/bind/named.conf.default-zones";
    };  
    
    view externa {
        match-clients { externa; };
        allow-recursion { any; };   
    
            zone "example.org"
            {
                    type master;
                    file "db.externa.example.org";
            };
            zone "22.172.in-addr.arpa"
            {
                    type master;
                    file "db.22.172";
            };  
            include "/etc/bind/zones.rfc1918";
            include "/etc/bind/named.conf.default-zones";
    };
    

Hemos creado las dos &#8220;acl&#8221; para diferenciar las redes por las que vamos a consultar:

    acl interna { 10.0.0.0/24; localhost; };
    acl externa { 172.22.0.0/16; };
    

La zona que se va a utilizar será la definida en la vista donde hayamos definidos las IP desde las que se hace las consultas:

    match-clients { interna; };
    

Otro detalle que tenemos que tener en cuanta al utilizar vistas, es que todas las zonas definidas deben estar dentro de una zona, por lo tanto las zonas de resolución inversa definidas en el RFC1918 y las zonas por defecto, la hemos incluido en cada una de las vistas:

Y no se nos puede olvidar eliminar las zonas por defecto del fichero `named.conf`:

    include "/etc/bind/named.conf.options";
    include "/etc/bind/named.conf.local";
    //include "/etc/bind/named.conf.default-zones";
    

La configuración de la zona directa para la vista interna quedaría el fichero `/var/cache/bind/db.interna.example.org`:

    $TTL    86400
    @   IN  SOA instancia1.example.org. root.example.org. (
                      1     ; Serial
                 604800     ; Refresh
                  86400     ; Retry
                2419200     ; Expire
                  86400 )   ; Negative Cache TTL
    ;
    @   IN  NS  instancia1.example.org.
    instancia1.example.org. IN  A   10.0.0.13
    

De forma similar la vista externa de la zona de resolución directa en el fichero `/var/cache/bind/db.externa.example.org`:

    $TTL    86400
    @   IN  SOA instancia1.example.org. root.example.org. (
                      1     ; Serial
                 604800     ; Refresh
                  86400     ; Retry
                2419200     ; Expire
                  86400 )   ; Negative Cache TTL
    ;
    @   IN  NS  instancia1.example.org.
    instancia1.example.org. IN  A   172.22.200.129
    

Y las zonas de resolución inversa para las dos vistas serían:

En le fichero `/var/cache/bind/db.0.0.10`:

    $TTL    86400
    @   IN  SOA instancia1.example.org. root.example.org. (
                      1     ; Serial
                 604800     ; Refresh
                  86400     ; Retry
                2419200     ; Expire
                  86400 )   ; Negative Cache TTL
    ;
    @   IN  NS  instancia1.example.org. 
    
    13.0.0.10.in-addr.arpa. IN  PTR instancia1.example.org.
    

Y en el fichero `/var/cache/bind/db.22.172`:

    $TTL    86400
    @   IN  SOA instancia1.example.org. root.example.org. (
                      1     ; Serial
                 604800     ; Refresh
                  86400     ; Retry
                2419200     ; Expire
                  86400 )   ; Negative Cache TTL
    ;
    @   IN  NS  instancia1.example.org. 
    
    129.200.22.172.in-addr.arpa.    IN  PTR instancia1.example.org.
    

## Pruebas de funcionamiento

Si hacemos una consulta a nuestro servidor desde la red 10.0.0.0/24:

    dig @10.0.0.13 instancia1.example.org   
    
    ; <<>> DiG 9.10.3-P4-Debian <<>> @10.0.0.13 instancia1.example.org
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 30042
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1 
    
    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ;; QUESTION SECTION:
    ;instancia1.example.org.        IN  A   
    
    ;; ANSWER SECTION:
    instancia1.example.org. 86400   IN  A   10.0.0.13   
    
    ;; Query time: 0 msec
    ;; SERVER: 10.0.0.13#53(10.0.0.13)
    ;; WHEN: Thu Dec 28 12:45:48 UTC 2017
    ;; MSG SIZE  rcvd: 67
    

Si por el contrario hacemos la consulta desde la red 172.22.0.0/16:

    dig @172.22.200.129 instancia1.example.org  
    
    ; <<>> DiG 9.10.3-P4-Debian <<>> @172.22.200.129 instancia1.example.org
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 42980
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1 
    
    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ;; QUESTION SECTION:
    ;instancia1.example.org.        IN  A   
    
    ;; ANSWER SECTION:
    instancia1.example.org. 86400   IN  A   172.22.200.129  
    
    ;; Query time: 1 msec
    ;; SERVER: 172.22.200.129#53(172.22.200.129)
    ;; WHEN: Thu Dec 28 12:44:52 UTC 2017
    ;; MSG SIZE  rcvd: 67
    

Y las consultas inversa de la misma manera, desde la red interna:

    dig @10.0.0.13 -x 10.0.0.13 
    
    ; <<>> DiG 9.10.3-P4-Debian <<>> @10.0.0.13 -x 10.0.0.13
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 19579
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1 
    
    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ;; QUESTION SECTION:
    ;13.0.0.10.in-addr.arpa.        IN  PTR 
    
    ;; ANSWER SECTION:
    13.0.0.10.in-addr.arpa. 86400   IN  PTR instancia1.example.org. 
    
    ;; Query time: 0 msec
    ;; SERVER: 10.0.0.13#53(10.0.0.13)
    ;; WHEN: Thu Dec 28 12:48:21 UTC 2017
    ;; MSG SIZE  rcvd: 87
    

Y desde la red externa:

    dig @172.22.200.129 -x 172.22.200.129   
    
    ; <<>> DiG 9.10.3-P4-Debian <<>> @172.22.200.129 -x 172.22.200.129
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 52169
    ;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1 
    
    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ;; QUESTION SECTION:
    ;129.200.22.172.in-addr.arpa.   IN  PTR 
    
    ;; ANSWER SECTION:
    129.200.22.172.in-addr.arpa. 86400 IN   PTR instancia1.example.org. 
    
    ;; Query time: 1 msec
    ;; SERVER: 172.22.200.129#53(172.22.200.129)
    ;; WHEN: Thu Dec 28 12:46:55 UTC 2017
    ;; MSG SIZE  rcvd: 92
    

## Conclusiones

Si ofrecemos servicios a distintas redes (distinto direccionamiento), usar las vistas en el servidor DN bind9 nos puede ayudar a utilizar un mismo nombre para cada servicio independientemente desde donde se haga la consulta. La resolución de cada nombre dependerá del origen de la consulta.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->