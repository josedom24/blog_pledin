---
id: 150
title: 'Nuevo curso: &#8220;Servicios en GNU/Linux: Puesta en marcha de un portal educativo&#8221;'
date: 2010-05-26T20:05:25+00:00


guid: http://www.josedomingo.org/pledin/?p=150
permalink: /2010/05/nuevo-curso_servicios_gnu_linux_portal_educativo/

  
tags:
  - Cursos
  - Educación
  - Linux
  - Pledin
---
![curso]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2010/05/titulo.jpg)

Os presento un nuevo curso on-line que hemos impartidos recientemente en el CEP de Lora del Río para profesores de Informática. Este curso ha sido realizado junto a [Alberto Molina](http://albertomolina.wordpress.com/), compañero del [IES Gonzalo Nazareno](http://informatica.gonzalonazareno.org) y José Luis Rodríguez, compañero del IES Jacaranda de Brenes. Accede al curso en el siguiente enlace:

<h3 style="text-align: center;">
  <a href="http://www.josedomingo.org/web/course/view.php?id=65">Servicios en GNU/Linux: Puesta en marcha de un portal educativo</a>
</h3>

El objetivo del curso se instalar y configurar servicios en GNU/Linux, pero para hacerlo más realista nos vamos a centrar en simular un caso real: Instalar desde cero un equipo que actúe como servidor web de un centro educativo y que a su vez sea el equipo que proporcione acceso a Internet a los equipos de las aulas.

La instalación y configuración de los diferentes servicios se hace en una serie de pasos que van incrementando las prestaciones del servidor y la red, los temas empiezan planteando un problema o una limitación y se trata la mejor forma de solucionarlo.

  * Unidad 0 y 1 Queremos alojar el sitio web de nuestro centro y dar acceso a Internet a todos los equipos de la red local ⇒ Instalamos un sistema LAMP y configuramos el equipo con dos interfaces de red para que haga NAT.

  * Unidad 2 Los equipos de la red local tienen direcciones IP estáticas⇒Instalamos un servidor que asigne direcciones IP de forma dinámica.

  * Unidad 3 Los equipos de la red local utilizan un DNS externo lo que provoca peticiones más lentas y consumo innecesario de ancho de banda ⇒ Instalamos un servidor DNS caché local.

  * Unidad 4 Tenemos muchos equipos en la red local que utilizan fundamentalmente la web y poco ancho de banda ⇒ Instalamos un servidor proxy-caché para www.

  * Unidad 5 Nuestro servidor está expuesto a ataques provenientes de Internet y nuestros usuarios de la red local acceden a servicios que no son muy educativos ⇒ Configuramos un cortafuegos.

  * Unidad 6 Nuestro CMS se puede comunicar con los usuarios a través de correo electrónico y el sistema nos puede comunicar mensajes de error o problemas al correo ⇒ Instalamos un servidor de correo electrónico.

  * Unidad 7 Los usuarios del CMS mandan su nombre de usuario y contraseña por Internet sin cifrar por lo que puede capturarse y realizar una suplantación ⇒ Ciframos la autenticación de usuarios.

  * Unidad 8 Es incómodo conectarse a otros equipos de la LAN utilizando dirección IP, ¿no sería mejor hacerlo por nombre? ¿cómo se hace esto si la dirección IP es dinámica?

  * Unidad 9 Las cuentas usuario son locales por lo que éstos no pueden cambiarse de equipo y se pierden datos cuando se estropean los equipos ⇒ Implantamos un sistema centralizado de cuentas.

  * Unidad 10 El servidor necesita que realicemos tareas de administración y mantenimiento.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->