---
layout: post
status: publish
published: true
title: Transferencias de vol&uacute;menes en OpenStack
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1714
wordpress_url: http://www.josedomingo.org/pledin/?p=1714
date: '2016-04-12 09:41:31 +0000'
date_gmt: '2016-04-12 07:41:31 +0000'
categories:
- General
tags:
- OpenStack
comments: []
---
<p style="text-align: justify;">Al igual que en la entrada anterior, sobre <a href="http://www.josedomingo.org/pledin/2016/04/copias-de-seguridad-de-volumenes-en-openstack/">copias de seguridad de vol&uacute;menes en OpenStack</a>, en esta entrada vamos a mostrar otra funcionalidad que nos ofrece OpenStack cuando trabajamos con vol&uacute;menes con su componente Cinder.</p>
<h3 style="text-align: justify;">Transferencia de vol&uacute;menes</h3>
<p>Esta operaci&oacute;n nos permite transferir un volumen de un proyecto a otro.</p>
<h3 id="crear-una-transferencia">Crear una transferencia</h3>
<p>Vamos a trabajar con el usuario demo, que tiene creado un volumen.</p>
<pre>$ source demo-openrc.sh	

$ cinder list
+--------------------------------------+-------------------+--------+------+-------------+----------+-------------+
|                  ID                  |       Status      |  Name  | Size | Volume Type | Bootable | Attached to |
+--------------------------------------+-------------------+--------+------+-------------+----------+-------------+
| 917ef4cc-784d-4803-a19a-984b847b9f1e | awaiting-transfer | disco1 |  1   | lvmdriver-1 |  false   |             |
+--------------------------------------+-------------------+--------+------+-------------+----------+-------------+
</pre>
<p>Vamos a crear una transferencia, con las siguientes instrucciones:</p>
<pre>$ cinder transfer-create 917ef4cc-784d-4803-a19a-984b847b9f1e
+------------+--------------------------------------+
|  Property  |                Value                 |
+------------+--------------------------------------+
|  auth_key  |           408af7d4a1441587           |
| created_at |      2016-01-08T17:07:03.412265      |
|     id     | d24d5659-40e9-446c-9437-238fc8868571 |
|    name    |                 None                 |
| volume_id  | 917ef4cc-784d-4803-a19a-984b847b9f1e |
+------------+--------------------------------------+

$ cinder transfer-list
+--------------------------------------+--------------------------------------+------+
|                  ID                  |              Volume ID               | Name |
+--------------------------------------+--------------------------------------+------+
| d24d5659-40e9-446c-9437-238fc8868571 | 917ef4cc-784d-4803-a19a-984b847b9f1e | None |
+--------------------------------------+--------------------------------------+------+
</pre>
<p><!--more--></p>
<h3 id="realizar-una-transferencia">Realizar una transferencia</h3>
<p style="text-align: justify;">A continuaci&oacute;n vamos a trabajar con otro usuario y otro proyecto, a donde vamos a realizar la transferencia del volumen.</p>
<pre>$ source admin-openrc.sh
</pre>
<p>Comprobamos que en este proyecto no hay ning&uacute;n volumen:</p>
<pre>$ cinder list
+----+--------+------+------+-------------+----------+-------------+
| ID | Status | Name | Size | Volume Type | Bootable | Attached to |
+----+--------+------+------+-------------+----------+-------------+
+----+--------+------+------+-------------+----------+-------------+
</pre>
<p style="text-align: justify;">A continuaci&oacute;n vamos a transferir el volumen a este proyecto, para ello tenemos que indicar el <em>ID</em> de la transferencia creada por el usuario <em>demo</em> indicando el par&aacute;metro <em>auth_key</em>.</p>
<pre>$ cinder transfer-accept d24d5659-40e9-446c-9437-238fc8868571 408af7d4a1441587
+-----------+--------------------------------------+
|  Property |                Value                 |
+-----------+--------------------------------------+
|     id    | d24d5659-40e9-446c-9437-238fc8868571 |
|    name   |                 None                 |
| volume_id | 917ef4cc-784d-4803-a19a-984b847b9f1e |
+-----------+--------------------------------------+
</pre>
<p>Y confirmamos que hemos hecho la transferencia de forma correcta:</p>
<pre>$ cinder list
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
|                  ID                  |   Status  |  Name  | Size | Volume Type | Bootable | Attached to |
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
| 917ef4cc-784d-4803-a19a-984b847b9f1e | available | disco1 |  1   | lvmdriver-1 |  false   |             |
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
</pre>
<p style="text-align: justify;">Si volvemos a entrar con el usuario <em>demo</em>, podemos comprobar que ya no tenemos ninguna transferencia pendiente y que ya no es propietario del volumen:</p>
<pre>$ source demo-openrc.sh

$ cinder transfer-list
+----+-----------+------+
| ID | Volume ID | Name |
+----+-----------+------+
+----+-----------+------+	

$ cinder list
+----+--------+------+------+-------------+----------+-------------+
| ID | Status | Name | Size | Volume Type | Bootable | Attached to |
+----+--------+------+------+-------------+----------+-------------+
+----+--------+------+------+-------------+----------+-------------+
</pre>
