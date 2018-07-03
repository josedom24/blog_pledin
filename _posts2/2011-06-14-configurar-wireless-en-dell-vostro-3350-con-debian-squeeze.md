---
id: 482
title: Configurar wireless en Dell Vostro 3350 con Debian Squeeze
date: 2011-06-14T20:52:09+00:00


guid: http://www.josedomingo.org/pledin/?p=482
permalink: /2011/06/configurar-wireless-en-dell-vostro-3350-con-debian-squeeze/

  
tags:
  - Linux
  - Manuales
  - Redes
---
¿Cómo configurar la tarjeta wifi de mi nuevo Dell Vostro 3350 con Debian Squezze?

Lo primero que tenemos que hacer es determinar que tarjeta wirelless trae l ordenador, para ello ejecutamos la siguiente instrucción:

    lspci | grep Network

El dispositivo que tenemos instalado viene nombrado como:

    09:00.0 Network controller: Intel Corporation Device 008a (rev 34)

<a href="http://wiki.debianchile.org/IntelWirelessAGN?action=fullsearch&context=180&value=linkto%3A%22IntelWirelessAGN%22">Buscando un poco por internet</a> podemos determinar que el modelo de la tarjaeta Wirelees es Centrino Wireless-N 1030, para que funcione esta tarjeta necesitamos instalar el módulo iwlagn que viene en el paquete `firmware-iwlwifi`, este paquete no es libre, por lo que tenemos que modificar nuestros repositorios y poner las secciones `contrib` y `non-free`.

Edita `/etc/apt/sources.list` y agrega la sección `non-free`:

    deb http://ftp.cl.debian.org/debian squeeze main contrib non-free

luego actualiza con la lista de paquetes:

    aptitude update
  
Instala el paquete `firmware-iwlwifi` con:
  
    aptitude install firmware-iwlwifi
  
antes de cargar el módulo:
  
    modprobe iwlagn
  
Después de esto debería funcionar, pero no es así. <a href="http://intellinuxwireless.org/">Seguimos investigando</a> y nos damos cuenta que nuestro dispositivo necesita como mínimo para funcionar el kernel 2.6.37, actualmente en Debian Squeeze tenemos instalado el 2.6.32. ¿Cuál es la solución? La solución es tener un sistema híbrido para poder instalar un núcleo superior que esta en la rama inestable sid.
  
Para ello sigo estos pasos:
  
En `/etc/apt/apt.conf.d` creo un fichero (lo puedes llamar `00apt`) y pongo la siguiente linea:
  
    APT::Default-Release "stable";
  
Indicando que para las actualizaciones y las instalaciones que no se indique lo contrario la rama por defecto es la estable. A continuación pongo el repositorio de la rama inestable en `/etc/apt/source.list`:
  
    deb http://ftp.es.debian.org/debian/sid main contrib non-free
  
Actualizo los repositorios
  
    aptitude update
  
Y a continuación busco los núcleos que puedo instalar:
  
    aptitude serach linux-image
  
Ahora aparece el 2.6.39-2, elegimos el de nuestra arquitectura (en mi caso amd64) y lo instalamos. Reiniciamos y debe aparecer una interfaz inalámbrica.
  
Quiero dar las gracias a mi compañero <a href="http://albertomolina.wordpress.com/">Alberto</a> que me ha ayudado en la parte final.
  
Espero que os sirva.
