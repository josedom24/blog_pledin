---
id: 838
title: Configuración de un servidor DNS esclavo (2ª parte)
date: 2013-11-18T16:47:36+00:00


guid: http://www.josedomingo.org/pledin/?p=838
permalink: /2013/11/configurar_servidor_dns_esclavo_2/


tags:
  - dns
  - Manuales
  - Redes
---

El objetivo de este artículo es hacer algunos comentarios sobre la configuración de un servidor DNS bind9 como esclavo, que ya vimos hace un tiempo en un post anterior: <a href="http://www.josedomingo.org/pledin/2011/11/configuracion-de-un-servidor-dns-esclavo/">Configuración de un servidor DNS esclavo</a>.

## Introducción

Para cada dominio, necesitamos más de un servidor autorizado para ofrecer la misma información (RFC 2182). Por lo tanto, los datos se introducen en un servidor (maestro) y se replican en otros (esclavos). Los clientes que consultan nuestro servidores no pueden ver quién es el maestro y cuáles son los esclavos, los registros NS se entregan al azar para distribuir la carga.

## ¿Cuándo se hacen las copias?

Los esclavos interrogan al maestro periódicamente, ésto es el "Intervalo de actualización" (`refresh interval`), para obtener actualizaciones. El maestro también puede notificar a los esclavos cuando hay cambios, pero como puede haber perdida de paquetes sigue siendo necesario interrogar periódicamente.

El esclavo sólo iniciará la copia cuando el número de serie, configurado en el registro SOA de la zona, **AUMENTE**. Es responsabilidad del administrador incrementar este número de serie cada vez que realice un cambio. De lo contrario habrá inconsistencia con los datos de los esclavos.

Para llevar el control del incremento del número de serie se puede usar el formato **YYMMDDNN**, siendo YY el año, MM el mes, DD el día y NN número de cambios den el día, por ejemplo: 13111401. Hay que tener en cuenta lo siguiente:

* Si se decrementa el número de serie, los esclavos nunca se actualizarán hasta que el número sea mayor que el valor anterior.
* El número de serie es un entero de 32 bits, si se incrementa el límite superior será truncado sin avisar por lo que el número de serie se habrá decrementado.

## Configuración del maestro

En al definición de la zona en el maestro se utiliza la directiva `allow_transfer{...}` donde indicamos los servidores que pueden transferir la zona desde el servidor maestro. Para nuestro ejemplo suponemos que el maestro tiene la dirección 10.0.0.1 y el esclavo la 10.0.0.2:

    zone "example.com" {
      type master;
      file "db.example.com";
      allow-transfer {10.0.0.2;};
    };

## Configuración del esclavo

Del esclavo no permitimos que se haga ninguna transferencia e indicamos quién es el servidor maestro de la zona.

    zone "example.com" {
      type slave;
      masters { 10.0.0.1; };
      file "db.example.com";
      allow-transfer { none; };
    };

## Formato del registro SOA

    $TTL 1d
    @    IN SOA ns1.example.net. mail.example.net. (
                13111801 ; Serial
                8h         ; Refresh
                1h         ; Retry
                4w         ; Expire
                1h )       ; Negative
      IN     NS     ns1.example.net.
      IN     NS     ns2.example.net.
      ...

Configuramos la siguiente información:

* Nombre del servidor maestro.
* El correo electrónico de la persona responsable, terminado en punto. También se puede poner la @.
* El número de serie.
* El intervalo de actualización (`refresh`): frecuencia con la que el esclavo debe revisar el número de serie del maestro para hacer una transferencia de zona.
* Intervalo de reintento (`retry`): frecuencia con la que reintenta si el servidor maestro no responde.
* Tiempo de caducidad (`expiry`): Si el esclavo no puede comunicarse con el maestro durante este intervalo, debe borrar su copia de la zona.
* TTL negativo (`negative`): Significa tiempo de vida negativo, el tiempo durante el cual se debe almacenar en la cache  de cualquier otro servidor DNS una respuesta negativa. Eso significa que si otro servidor DNS preguntas por `no-existe.example.net` y esa entrada no existe, ese servidor DNS considerara como valida esa respuesta (no existe) durante el tiempo indicado.

Podemos encontrar valores recomendados de estas variables en <a href="http://www.ripe.net/ripe/docs/ripe-203">http://www.ripe.net/ripe/docs/ripe-203</a>.

## Evitar y comprobar errores

* Cada vez que realice una modificación recuerda **incrementar** el número de serie.
* Para detectar errores de sintaxis puedes usar el siguiente comando: 

        named-checkzone example.net /var/cache/bind/db.example.net
        
* Para detectar errores de configuración en `named.conf`, podemos usar:

        named-checkconf

* Reinicia el servicio y comprueba los logs del sistema. Para reiniciar el servicio puedes usar la utilidad `rndc`, la cual nos permite la administración del demonio `named` desde la línea de comandos del mismo host o de un equipo remoto. Por ejemplo: 

        rndc reload
        rndc reload example.net
        tail /var/log/syslog

* Realiza una consulta al servidor maestro y los esclavos para comprobar que las respuestas son autorizadas (bit AA), además asegúrate que coinciden los número de serie, para ello puedes hacer la siguiente consulta: 

        dig +norec @x.x.x.x example.net. soa

* Solicita una copia completa de la zona y comprueba que sólo se puede hacer desde las direcciones ip que están en la sección `allow-transfer`, es decir, desde los esclavos, para ello: 

        dig @x.x.x.x example.net. axfr
  
Tienes que tener en cuenta que si tienes un error en `named.conf` o en un fichero de zona, named quizá continuará su ejecución pero no será autorizado para la zona, por lo que tendremos un servidor no autorizado, por lo que los esclavos no serán capaces de comunicarse con el maestro, con lo que en algún momento la zonas caducarán en los esclavos y el dominio dejará de ser visible.