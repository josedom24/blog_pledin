---
id: 482
title: Configurar wireless en Dell Vostro 3350 con Debian Squeeze
date: 2011-06-14T20:52:09+00:00
author: admin

guid: http://www.josedomingo.org/pledin/?p=482
permalink: /2011/06/configurar-wireless-en-dell-vostro-3350-con-debian-squeeze/

  
tags:
  - Linux
  - Manuales
  - Redes
---
<p style="text-align: justify;">
  ¿Cómo configurar la tarjeta wifi de mi nuevo Dell Vostro 3350 con Debian Squezze?
</p>

Lo primero que tenemos que hacer es determinar que tarjeta wirelless trae l ordenador, para ello ejecutamos la siguiente instrucción:

<pre class="brush: bash; gutter: false; first-line: 1">lspci | grep Network</pre>

El dispositivo que tenemos instalado viene nombrado como:

<pre class="brush: bash; gutter: false; first-line: 1">09:00.0 Network controller: Intel Corporation Device 008a (rev 34)</pre>

<p style="text-align: justify;">
  <a href="http://wiki.debianchile.org/IntelWirelessAGN?action=fullsearch&context=180&value=linkto%3A%22IntelWirelessAGN%22">Buscando un poco por internet</a> podemos determinar que el modelo de la tarjaeta Wirelees es Centrino Wireless-N 1030, para que funcione esta tarjeta necesitamos instalar el módulo iwlagn que viene en el paquete firmware-iwlwifi, este paquete no es libre, por lo que tenemos que modificar nuestros repositorios y poner las secciones contrib y non-free.
</p>

Edita /etc/apt/sources.list y agrega la sección non-free:

<pre class="brush: bash; gutter: false; first-line: 1">deb http://ftp.cl.debian.org/debian squeeze main contrib non-free</pre>

<p style="text-align: justify;">
  luego actualiza con la lista de paquetes:
</p>

<p style="text-align: justify;">
  <pre class="brush: bash; gutter: false; first-line: 1">aptitude update</pre>
  
  <p>
    Instala el paquete firmware-iwlwifi con:
  </p>
  
  <pre class="brush: bash; gutter: false; first-line: 1">aptitude install firmware-iwlwifi</pre>
  
  <p>
    antes de cargar el módulo:
  </p>
  
  <pre class="brush: bash; gutter: false; first-line: 1">modprobe iwlagn</pre>
  
  <p style="text-align: justify;">
    Después de esto debería funcionar, pero no es así. <a href="http://intellinuxwireless.org/">Seguimos investigando</a> y nos damos cuenta que nuestro dispositivo necesita como mínimo para funcionar el kernel 2.6.37, actualmente en Debian Squeeze tenemos instalado el 2.6.32. ¿Cuál es la solución? La solución es tener un sistema híbrido para poder instalar un núcleo superior que esta en la rama inestable sid.
  </p>
  
  <p>
    Para ello sigo estos pasos:
  </p>
  
  <p>
    En /aetc/apt/apt.conf.d creo un fichero (lo puedeo llamar 00apt) y pongo la siguiente linea:
  </p>
  
  <pre class="brush: bash; gutter: false; first-line: 1">APT::Default-Release "stable";</pre>
  
  <p>
    Indicando que para las actualizaciones y las instalaciones que no se indique lo contrario la rama por defecto es la estable.
  </p>
  
  <p>
    A continuación pongo el repositorio de la rama inestable en /etc/apt/source.list
  </p>
  
  <pre class="brush: bash; gutter: false; first-line: 1">deb http://ftp.es.debian.org/debian/ sid main contrib non-free</pre>
  
  <p>
    Actualizo los repositorios
  </p>
  
  <pre class="brush: bash; gutter: false; first-line: 1">aptitude update</pre>
  
  <p>
    Y a continuación busco los núcleos que puedo instalar:
  </p>
  
  <pre class="brush: bash; gutter: false; first-line: 1">aptitude serach linux-image</pre>
  
  <p>
    Ahora aparece el 2.6.39-2, elegimos el de nuestra arquitectura (en mi caso amd64) y lo instalamos. Reinicimos y debe aparecer una interfaz inalámbrica.
  </p>
  
  <p>
    Quiero dar las gracias a mi compañero <a href="http://albertomolina.wordpress.com/">Alberto</a> que me ha ayudado en la parte final.
  </p>
  
  <p>
    Espero que os sirva.
  </p>
  
  <!-- AddThis Advanced Settings generic via filter on the_content -->
  
  <!-- AddThis Share Buttons generic via filter on the_content -->