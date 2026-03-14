---
id: 668
title: Infohardware, programa para realizar el inventario de ordenadores
date: 2012-05-29T01:22:05+00:00


guid: http://www.josedomingo.org/pledin/?p=668
permalink: /2012/05/infohardware-programa-para-realizar-el-inventario-de-ordenadores/


tags:
  - Hardware
  - Python
---
<p style="text-align: justify;">
  Hola a todos,<br /> en la últimas semanas he estado trabajando, con otros compañeros del departamento de informática del IES Gonzalo Nazareno, en desarrollar un programa para realizar el inventario de los ordenadores que tenemos en nuestras <a href="http://informatica.gonzalonazareno.org/plataforma">ciclos de Formación de Profesional de informática</a>. Estuvimos estudiando varías opciones, pero queríamos una solución muy específica, que nos diera la oportunidad de guardar en una base de datos la información básica de los componenetes de un ordenador, de tal forma que posteriormente la pudiéramos usarlos en una aplicación web.
</p>

<p style="text-align: justify;">
  De esta forma hemos desarrollado Infohardware, programa escrito en python que nos permite leer la información de los componentes hardware de un ordenador. Los datos que vamos a leer, se guardarán en una base de datos:
</p>

  * CPU: Proveedor, producto y slot.
  * Placa Base: Proveedor y producto.
  * RAM: Para cada módulo de memoria, tamaño y frecuencia.
  * Discos duros: Para cada disco, número de serie, proveedor, producto, descripción y tamaño.
  * CD / DVD: Para cada unidad, proveedor y producto.
  * Red: De cada tarjeta de red, MAC, proveedor y producto

<p style="text-align: justify;">
  Para más información del programa, módelo entidad-relación de la base de datos, instrucciones de instalación y configuración podéis consultar el repositorio en <a href="https://github.com/josedom24/infohardware">https://github.com/josedom24/infohardware</a>.
</p>

Espero que sea de utilidad, y si teneís alguna sugerencia o mejora, por favor, escribidme.

Un saludo

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->