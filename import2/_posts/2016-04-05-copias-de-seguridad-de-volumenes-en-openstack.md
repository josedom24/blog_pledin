---
layout: post
status: publish
published: true
title: Copias de seguridad de vol&uacute;menes en OpenStack
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 1707
wordpress_url: http://www.josedomingo.org/pledin/?p=1707
date: '2016-04-05 20:49:43 +0000'
date_gmt: '2016-04-05 18:49:43 +0000'
categories:
- General
tags:
- OpenStack
- devstack
comments: []
---
<p style="text-align: justify;">En esta entrada voy a explicar una caracter&iacute;stica muy espec&iacute;fica que nos proporciona el componente Cinder de OpenStack, que es el encargado de gestionar el almacenamiento persistente con el concepto de volumen. La caracter&iacute;stica a la que me refiero es la posibilidad de hacer <strong>copias de seguridad del contenido de nuestro vol&uacute;menes</strong>. El estudio de esta opci&oacute;n la hemos llevado a cabo durante la realizaci&oacute;n del <a href="http://iesgn.github.io/emergya">&uacute;ltimo curso sobre OpenStack</a> que he impartido con <a href="http://albertomolina.wordpress.com/">Alberto Molina</a>. Adem&aacute;s si buscas informaci&oacute;n de este tema, hay muy poco en espa&ntilde;ol, as&iacute; que puede ser de utilidad.</p>
<p style="text-align: justify;">El cliente cinder proporciona las herramientas necesarias para crear una copia de seguridad de un volumen. Las copias de seguridad se guardar como objetos en el contenedor de objetos swift. Por defecto se utiliza swift como almac&eacute;n de copias de seguridad, aunque se puede configurar otros backend para realizar las copias de seguridad, por ejemplo una carpeta compartida por NFS.</p>
<h2>Configurando devstack de forma adecuada</h2>
<p style="text-align: justify;">Podemos configurar nuestra instalaci&oacute;n de OpenStack con <a href="http://docs.openstack.org/developer/devstack/">devstack</a> para habilitar la caracter&iacute;stica de copia de seguridad de vol&uacute;menes. En art&iacute;culo anteriores he hecho una introducci&oacute;n al uso de devstack para realizar una instalaci&oacute;n de OpenStack en un entorno de pruebas: <a href="http://www.josedomingo.org/pledin/2014/11/instalar-open-stack-juno-con-devstack/">Instalar Open Stack Juno con devstack</a>.</p>
<p>Al crear nuestro fichero local.conf, tenemos que tener en cuenta dos cosas:</p>
<ul>
<li>Habilitar el componente de swift (almacenamiento de objetos) donde vamos a realizar las copias de seguridad.</li>
</ul>
<pre> enable_service s-proxy s-object s-container s-account
 SWIFT_REPLICAS=1
 SWIFT_HASH=password</pre>
<ul>
<li>Habilitar la caracter&iacute;stica de copia de seguridad de los vol&uacute;menes.</li>
</ul>
<pre>enable_service c-bak
</pre>
<p><!--more-->Un ejemplo de fichero local.conf podr&iacute;a ser:</p>
<pre>###IP Configuration
HOST_IP=IP_ADDRESS

#Credentials
ADMIN_PASSWORD=password
DATABASE_PASSWORD=password
RABBIT_PASSWORD=password
SERVICE_PASSWORD=password
SERVICE_TOKEN=password

####Tempest
enable_service tempest

#Swift Requirements
enable_service s-proxy s-object s-container s-account
SWIFT_REPLICAS=1
SWIFT_HASH=password

##Enable Cinder-Backup
enable_service c-bak

#Log Output
LOGFILE=/opt/stack/logs/stack.sh.log
VERBOSE=True
LOG_COLOR=False
SCREEN_LOGDIR=/opt/stack/logs

</pre>
<h2 id="crear-una-copia-de-seguridad">Crear una copia de seguridad</h2>
<p>Para realizar una copia de seguridad de un volumen debe estar en estado <em>Disponible</em>, es decir, no debe estar asociada a ninguna instancia.</p>
<p>Partimos del siguiente volumen, que hemos formateado y creado un fichero desde una instancia:</p>
<pre>$ cinder list
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
|                  ID                  |   Status  |  Name  | Size | Volume Type | Bootable | Attached to |
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
| 917ef4cc-784d-4803-a19a-984b847b9f1e | available | disco1 |  1   | lvmdriver-1 |  false   |             |
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
</pre>
<p>Vamos a hacer una copia de seguridad:</p>
<pre>$ cinder backup-create 917ef4cc-784d-4803-a19a-984b847b9f1e
+-----------+--------------------------------------+
|  Property |                Value                 |
+-----------+--------------------------------------+
|     id    | 77e2430d-afda-4733-bf55-6d150555b75f |
|    name   |                 None                 |
| volume_id | 917ef4cc-784d-4803-a19a-984b847b9f1e |
+-----------+--------------------------------------+
</pre>
<p>Vemos la lista de copias de seguridad con:</p>
<pre>$ cinder backup-list
+--------------------------------------+--------------------------------------+-----------+------+------+--------------+---------------+
|                  ID                  |              Volume ID               |   Status  | Name | Size | Object Count |   Container   |
+--------------------------------------+--------------------------------------+-----------+------+------+--------------+---------------+
| 77e2430d-afda-4733-bf55-6d150555b75f | 917ef4cc-784d-4803-a19a-984b847b9f1e | available | None |  1   |      22      | volumebackups |
+--------------------------------------+--------------------------------------+-----------+------+------+--------------+---------------+
</pre>
<p>Y finalmente podemos pedir informaci&oacute;n sobre la copia de seguridad:</p>
<pre>$ cinder backup-show 77e2430d-afda-4733-bf55-6d150555b75f
+-------------------+--------------------------------------+
|      Property     |                Value                 |
+-------------------+--------------------------------------+
| availability_zone |                 nova                 |
|     container     |            volumebackups             |
|     created_at    |      2016-01-08T16:39:47.000000      |
|    description    |                 None                 |
|    fail_reason    |                 None                 |
|         id        | 77e2430d-afda-4733-bf55-6d150555b75f |
|        name       |                 None                 |
|    object_count   |                  22                  |
|        size       |                  1                   |
|       status      |              available               |
|     volume_id     | 917ef4cc-784d-4803-a19a-984b847b9f1e |
+-------------------+--------------------------------------+
</pre>
<p>Para comprobar que la copia de seguridad se ha guardado en swifit ejecutamos la siguientes instrucciones:</p>
<pre>$ swift list
volumebackups

$ swift list volumebackups
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00001
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00002
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00003
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00004
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00005
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00006
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00007
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00008
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00009
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00010
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00011
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00012
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00013
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00014
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00015
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00016
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00017
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00018
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00019
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00020
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f-00021
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f_metadata
volume_917ef4cc-784d-4803-a19a-984b847b9f1e/20160108163947/az_nova_backup_77e2430d-afda-4733-bf55-6d150555b75f_sha256file
</pre>
<h2 id="restaurar-una-copia-de-seguridad">Restaurar una copia de seguridad</h2>
<p>Para restaurar una nueva copia de seguridad a un nuevo volumen, ejecutamos la siguiente instrucci&oacute;n:</p>
<pre>$ cinder backup-restore  77e2430d-afda-4733-bf55-6d150555b75f
</pre>
<p>Podemos ver el proceso de restauraci&oacute;n con la siguiente instrucci&oacute;n:</p>
<pre>$ cinder list
+--------------------------------------+------------------+-----------------------------------------------------+------+-------------+----------+-------------+
|                  ID                  |      Status      |                         Name                        | Size | Volume Type | Bootable | Attached to |
+--------------------------------------+------------------+-----------------------------------------------------+------+-------------+----------+-------------+
| 917ef4cc-784d-4803-a19a-984b847b9f1e |    available     |                        disco1                       |  1   | lvmdriver-1 |  false   |             |
| ebff83f2-cec8-429d-af8a-67e9d012ef5e | restoring-backup | restore_backup_77e2430d-afda-4733-bf55-6d150555b75f |  1   | lvmdriver-1 |  false   |             |
+--------------------------------------+------------------+-----------------------------------------------------+------+-------------+----------+-------------+	
</pre>
<p>Y finalmente vemos que se ha creado un nuevo volumen restaurado desde la copia de seguridad:</p>
<pre>$ cinder list
+--------------------------------------+-----------+-----------------------------------------------------+------+-------------+----------+-------------+
|                  ID                  |   Status  |                         Name                        | Size | Volume Type | Bootable | Attached to |
+--------------------------------------+-----------+-----------------------------------------------------+------+-------------+----------+-------------+
| 917ef4cc-784d-4803-a19a-984b847b9f1e | available |                        disco1                       |  1   | lvmdriver-1 |  false   |             |
| ebff83f2-cec8-429d-af8a-67e9d012ef5e | available | restore_backup_77e2430d-afda-4733-bf55-6d150555b75f |  1   | lvmdriver-1 |  false   |             |
+--------------------------------------+-----------+-----------------------------------------------------+------+-------------+----------+-------------+
</pre>
<p style="text-align: justify;">Por &uacute;ltimo indicar que en la &uacute;ltima versi&oacute;n de Openstack (Liberty) se ha introducido la posibilidad de hacer copias de seguridad incrementales y la posibilidad de hacer copias de seguridad aunque el volumen este asociado a una instancia.</p>
