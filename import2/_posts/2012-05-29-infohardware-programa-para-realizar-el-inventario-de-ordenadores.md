---
layout: post
status: publish
published: true
title: Infohardware, programa para realizar el inventario de ordenadores
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 668
wordpress_url: http://www.josedomingo.org/pledin/?p=668
date: '2012-05-29 01:22:05 +0000'
date_gmt: '2012-05-28 23:22:05 +0000'
categories:
- General
tags:
- Hardware
- Python
comments: []
---
<p style="text-align: justify;">Hola a todos,<br />
en la &uacute;ltimas semanas he estado trabajando, con otros compa&ntilde;eros del departamento de inform&aacute;tica del IES Gonzalo Nazareno, en desarrollar un programa para realizar el inventario de los ordenadores que tenemos en nuestras <a href="http://informatica.gonzalonazareno.org/plataforma">ciclos de Formaci&oacute;n de Profesional de inform&aacute;tica</a>. Estuvimos estudiando var&iacute;as opciones, pero quer&iacute;amos una soluci&oacute;n muy espec&iacute;fica, que nos diera la oportunidad de guardar en una base de datos la informaci&oacute;n b&aacute;sica de los componenetes de un ordenador, de tal forma que posteriormente la pudi&eacute;ramos usarlos en una aplicaci&oacute;n web.</p>
<p style="text-align: justify;">De esta forma hemos desarrollado Infohardware, programa escrito en python que nos permite leer la informaci&oacute;n de los componentes hardware de un ordenador. Los datos que vamos a leer, se guardar&aacute;n en una base de datos:</p>
<ul>
<li>CPU: Proveedor, producto y slot.</li>
<li>Placa Base: Proveedor y producto.</li>
<li>RAM: Para cada m&oacute;dulo de memoria, tama&ntilde;o y frecuencia.</li>
<li>Discos duros: Para cada disco, n&uacute;mero de serie, proveedor, producto, descripci&oacute;n y tama&ntilde;o.</li>
<li>CD / DVD: Para cada unidad, proveedor y producto.</li>
<li>Red: De cada tarjeta de red, MAC, proveedor y producto</li>
</ul>
<p style="text-align: justify;">Para m&aacute;s informaci&oacute;n del programa, m&oacute;delo entidad-relaci&oacute;n de la base de datos, instrucciones de instalaci&oacute;n y configuraci&oacute;n pod&eacute;is consultar el repositorio en <a href="https://github.com/josedom24/infohardware">https://github.com/josedom24/infohardware</a>.</p>
<p>Espero que sea de utilidad, y si tene&iacute;s alguna sugerencia o mejora, por favor, escribidme.</p>
<p>Un saludo</p>
