---
id: 1714
title: Transferencias de volúmenes en OpenStack
date: 2016-04-12T09:41:31+00:00


guid: http://www.josedomingo.org/pledin/?p=1714
permalink: /2016/04/transferencias-de-volumenes-en-openstack/


tags:
  - OpenStack
---
<p style="text-align: justify;">
  Al igual que en la entrada anterior, sobre <a href="http://www.josedomingo.org/pledin/2016/04/copias-de-seguridad-de-volumenes-en-openstack/">copias de seguridad de volúmenes en OpenStack</a>, en esta entrada vamos a mostrar otra funcionalidad que nos ofrece OpenStack cuando trabajamos con volúmenes con su componente Cinder.
</p>

<h3 style="text-align: justify;">
  Transferencia de volúmenes
</h3>

Esta operación nos permite transferir un volumen de un proyecto a otro.

### Crear una transferencia {#crear-una-transferencia}

Vamos a trabajar con el usuario demo, que tiene creado un volumen.

<pre>$ source demo-openrc.sh	

$ cinder list
+--------------------------------------+-------------------+--------+------+-------------+----------+-------------+
|                  ID                  |       Status      |  Name  | Size | Volume Type | Bootable | Attached to |
+--------------------------------------+-------------------+--------+------+-------------+----------+-------------+
| 917ef4cc-784d-4803-a19a-984b847b9f1e | awaiting-transfer | disco1 |  1   | lvmdriver-1 |  false   |             |
+--------------------------------------+-------------------+--------+------+-------------+----------+-------------+
</pre>

Vamos a crear una transferencia, con las siguientes instrucciones:

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

<!--more-->

### Realizar una transferencia {#realizar-una-transferencia}

<p style="text-align: justify;">
  A continuación vamos a trabajar con otro usuario y otro proyecto, a donde vamos a realizar la transferencia del volumen.
</p>

<pre>$ source admin-openrc.sh
</pre>

Comprobamos que en este proyecto no hay ningún volumen:

<pre>$ cinder list
+----+--------+------+------+-------------+----------+-------------+
| ID | Status | Name | Size | Volume Type | Bootable | Attached to |
+----+--------+------+------+-------------+----------+-------------+
+----+--------+------+------+-------------+----------+-------------+
</pre>

<p style="text-align: justify;">
  A continuación vamos a transferir el volumen a este proyecto, para ello tenemos que indicar el <em>ID</em> de la transferencia creada por el usuario <em>demo</em> indicando el parámetro <em>auth_key</em>.
</p>

<pre>$ cinder transfer-accept d24d5659-40e9-446c-9437-238fc8868571 408af7d4a1441587
+-----------+--------------------------------------+
|  Property |                Value                 |
+-----------+--------------------------------------+
|     id    | d24d5659-40e9-446c-9437-238fc8868571 |
|    name   |                 None                 |
| volume_id | 917ef4cc-784d-4803-a19a-984b847b9f1e |
+-----------+--------------------------------------+
</pre>

Y confirmamos que hemos hecho la transferencia de forma correcta:

<pre>$ cinder list
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
|                  ID                  |   Status  |  Name  | Size | Volume Type | Bootable | Attached to |
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
| 917ef4cc-784d-4803-a19a-984b847b9f1e | available | disco1 |  1   | lvmdriver-1 |  false   |             |
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
</pre>

<p style="text-align: justify;">
  Si volvemos a entrar con el usuario <em>demo</em>, podemos comprobar que ya no tenemos ninguna transferencia pendiente y que ya no es propietario del volumen:
</p>

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

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->