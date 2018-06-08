---
layout: post
status: publish
published: true
title: Configurar wireless en Dell Vostro 3350 con Debian Squeeze
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 482
wordpress_url: http://www.josedomingo.org/pledin/?p=482
date: '2011-06-14 20:52:09 +0000'
date_gmt: '2011-06-14 18:52:09 +0000'
categories:
- General
tags:
- Redes
- Linux
- Manuales
comments:
- id: 54
  author: B&aacute;lint Kriv&aacute;n
  author_email: balint@krivan.hu
  author_url: ''
  date: '2011-07-09 12:41:24 +0000'
  date_gmt: '2011-07-09 10:41:24 +0000'
  content: "Hi!\r\n\r\nThanks for your post, I'm having a Dell 3350 also, and it helped
    me a lot!\r\nDo you have the Radeon version of Vostro? Because I do, and aticonfig
    didn't want to work, do you have any suggestion where should I keep digging?\r\n\r\nThanks!"
- id: 55
  author: admin
  author_email: clasinfo@gmail.com
  author_url: ''
  date: '2011-07-11 19:41:10 +0000'
  date_gmt: '2011-07-11 17:41:10 +0000'
  content: |-
    Hello, sorry but I have not had experience with this video card.
    Regards.
- id: 148
  author: Laptop Vostro 3350
  author_email: HoltsBartoletti9336@yahoomail.com
  author_url: http://www.sprzet.kotrak.pl/hardware/Serwery_i_komputery/Laptopy
  date: '2011-12-31 21:45:59 +0000'
  date_gmt: '2011-12-31 20:45:59 +0000'
  content: Pretty nice post. I just stumbled upon your weblog and wanted to mention
    that I have really loved browsing your blog posts. In any case I'll be subscribing
    on your feed and I hope you write once more soon!
- id: 187
  author: inavsan
  author_email: inavsan@gmail.com
  author_url: ''
  date: '2012-04-14 10:13:57 +0000'
  date_gmt: '2012-04-14 08:13:57 +0000'
  content: "Despues de reinstalar Debian 8 o 9 veces, eres el &uacute;nico que me
    lo ha solucionado. Tengo un Dell XPS 702x y la soluci&oacute;n estaba en ponerle
    el &uacute;ltimo kernel.\r\nUn mill&oacute;n de gracias a ti y a los que compart&iacute;s
    tan generosamente vuestro saber."
---
<p style="text-align: justify;">&iquest;C&oacute;mo configurar la tarjeta wifi de mi nuevo Dell Vostro 3350 con Debian Squezze?</p>
<p>Lo primero que tenemos que hacer es determinar que tarjeta wirelless trae l ordenador, para ello ejecutamos la siguiente instrucci&oacute;n:</p>
<pre class="brush: bash; gutter: false; first-line: 1">lspci | grep Network</pre>
<p>El dispositivo que tenemos instalado viene nombrado como:</p>
<pre class="brush: bash; gutter: false; first-line: 1">09:00.0 Network controller: Intel Corporation Device 008a (rev 34)</pre>
<p style="text-align: justify;"><a href="http://wiki.debianchile.org/IntelWirelessAGN?action=fullsearch&amp;context=180&amp;value=linkto%3A%22IntelWirelessAGN%22">Buscando un poco por internet</a> podemos determinar que el modelo de la tarjaeta Wirelees es Centrino Wireless-N 1030, para que funcione esta tarjeta necesitamos instalar el m&oacute;dulo iwlagn que viene en el paquete firmware-iwlwifi, este paquete no es libre, por lo que tenemos que modificar nuestros repositorios y poner las secciones contrib y non-free.</p>
<p>Edita /etc/apt/sources.list y agrega la secci&oacute;n non-free:</p>
<pre class="brush: bash; gutter: false; first-line: 1">deb http://ftp.cl.debian.org/debian squeeze main contrib non-free</pre>
<p style="text-align: justify;">luego actualiza con la lista de paquetes:</p>
<p style="text-align: justify;">
<pre class="brush: bash; gutter: false; first-line: 1">aptitude update</pre>
<p>Instala el paquete firmware-iwlwifi con:</p>
<pre class="brush: bash; gutter: false; first-line: 1">aptitude install firmware-iwlwifi</pre>
<p>antes de cargar el m&oacute;dulo:</p>
<pre class="brush: bash; gutter: false; first-line: 1">modprobe iwlagn</pre>
<p style="text-align: justify;">Despu&eacute;s de esto deber&iacute;a funcionar, pero no es as&iacute;. <a href="http://intellinuxwireless.org/">Seguimos investigando</a> y nos damos cuenta que nuestro dispositivo necesita como m&iacute;nimo para funcionar el kernel 2.6.37, actualmente en Debian Squeeze tenemos instalado el 2.6.32. &iquest;Cu&aacute;l es la soluci&oacute;n? La soluci&oacute;n es tener un sistema h&iacute;brido para poder instalar un n&uacute;cleo superior que esta en la rama inestable sid.</p>
<p>Para ello sigo estos pasos:</p>
<p>En /aetc/apt/apt.conf.d creo un fichero (lo puedeo llamar 00apt) y pongo la siguiente linea:</p>
<pre class="brush: bash; gutter: false; first-line: 1">APT::Default-Release "stable";</pre>
<p>Indicando que para las actualizaciones y las instalaciones que no se indique lo contrario la rama por defecto es la estable.</p>
<p>A continuaci&oacute;n pongo el repositorio de la rama inestable en /etc/apt/source.list</p>
<pre class="brush: bash; gutter: false; first-line: 1">deb http://ftp.es.debian.org/debian/ sid main contrib non-free</pre>
<p>Actualizo los repositorios</p>
<pre class="brush: bash; gutter: false; first-line: 1">aptitude update</pre>
<p>Y a continuaci&oacute;n busco los n&uacute;cleos que puedo instalar:</p>
<pre class="brush: bash; gutter: false; first-line: 1">aptitude serach linux-image</pre>
<p>Ahora aparece el 2.6.39-2, elegimos el de nuestra arquitectura (en mi caso amd64) y lo instalamos. Reinicimos y debe aparecer una interfaz inal&aacute;mbrica.</p>
<p>Quiero dar las gracias a mi compa&ntilde;ero <a href="http://albertomolina.wordpress.com/">Alberto</a> que me ha ayudado en la parte final.</p>
<p>Espero que os sirva.</p>
