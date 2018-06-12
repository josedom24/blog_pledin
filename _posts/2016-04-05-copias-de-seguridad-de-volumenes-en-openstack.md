---
id: 1707
title: Copias de seguridad de volúmenes en OpenStack
date: 2016-04-05T20:49:43+00:00


guid: http://www.josedomingo.org/pledin/?p=1707
permalink: /2016/04/copias-de-seguridad-de-volumenes-en-openstack/


tags:
  - devstack
  - OpenStack
---
<p style="text-align: justify;">
  En esta entrada voy a explicar una característica muy específica que nos proporciona el componente Cinder de OpenStack, que es el encargado de gestionar el almacenamiento persistente con el concepto de volumen. La característica a la que me refiero es la posibilidad de hacer <strong>copias de seguridad del contenido de nuestro volúmenes</strong>. El estudio de esta opción la hemos llevado a cabo durante la realización del <a href="http://iesgn.github.io/emergya">último curso sobre OpenStack</a> que he impartido con <a href="http://albertomolina.wordpress.com/">Alberto Molina</a>. Además si buscas información de este tema, hay muy poco en español, así que puede ser de utilidad.
</p>

<p style="text-align: justify;">
  El cliente cinder proporciona las herramientas necesarias para crear una copia de seguridad de un volumen. Las copias de seguridad se guardar como objetos en el contenedor de objetos swift. Por defecto se utiliza swift como almacén de copias de seguridad, aunque se puede configurar otros backend para realizar las copias de seguridad, por ejemplo una carpeta compartida por NFS.
</p>

## Configurando devstack de forma adecuada

<p style="text-align: justify;">
  Podemos configurar nuestra instalación de OpenStack con <a href="http://docs.openstack.org/developer/devstack/">devstack</a> para habilitar la característica de copia de seguridad de volúmenes. En artículo anteriores he hecho una introducción al uso de devstack para realizar una instalación de OpenStack en un entorno de pruebas: <a href="http://www.josedomingo.org/pledin/2014/11/instalar-open-stack-juno-con-devstack/">Instalar Open Stack Juno con devstack</a>.
</p>

Al crear nuestro fichero local.conf, tenemos que tener en cuenta dos cosas:

  * Habilitar el componente de swift (almacenamiento de objetos) donde vamos a realizar las copias de seguridad.

<pre>enable_service s-proxy s-object s-container s-account
 SWIFT_REPLICAS=1
 SWIFT_HASH=password</pre>

  * Habilitar la característica de copia de seguridad de los volúmenes.

<pre>enable_service c-bak
</pre>

<!--more-->Un ejemplo de fichero local.conf podría ser:

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

## Crear una copia de seguridad {#crear-una-copia-de-seguridad}

Para realizar una copia de seguridad de un volumen debe estar en estado _Disponible_, es decir, no debe estar asociada a ninguna instancia.

Partimos del siguiente volumen, que hemos formateado y creado un fichero desde una instancia:

<pre>$ cinder list
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
|                  ID                  |   Status  |  Name  | Size | Volume Type | Bootable | Attached to |
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
| 917ef4cc-784d-4803-a19a-984b847b9f1e | available | disco1 |  1   | lvmdriver-1 |  false   |             |
+--------------------------------------+-----------+--------+------+-------------+----------+-------------+
</pre>

Vamos a hacer una copia de seguridad:

<pre>$ cinder backup-create 917ef4cc-784d-4803-a19a-984b847b9f1e
+-----------+--------------------------------------+
|  Property |                Value                 |
+-----------+--------------------------------------+
|     id    | 77e2430d-afda-4733-bf55-6d150555b75f |
|    name   |                 None                 |
| volume_id | 917ef4cc-784d-4803-a19a-984b847b9f1e |
+-----------+--------------------------------------+
</pre>

Vemos la lista de copias de seguridad con:

<pre>$ cinder backup-list
+--------------------------------------+--------------------------------------+-----------+------+------+--------------+---------------+
|                  ID                  |              Volume ID               |   Status  | Name | Size | Object Count |   Container   |
+--------------------------------------+--------------------------------------+-----------+------+------+--------------+---------------+
| 77e2430d-afda-4733-bf55-6d150555b75f | 917ef4cc-784d-4803-a19a-984b847b9f1e | available | None |  1   |      22      | volumebackups |
+--------------------------------------+--------------------------------------+-----------+------+------+--------------+---------------+
</pre>

Y finalmente podemos pedir información sobre la copia de seguridad:

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

Para comprobar que la copia de seguridad se ha guardado en swifit ejecutamos la siguientes instrucciones:

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

## Restaurar una copia de seguridad {#restaurar-una-copia-de-seguridad}

Para restaurar una nueva copia de seguridad a un nuevo volumen, ejecutamos la siguiente instrucción:

<pre>$ cinder backup-restore  77e2430d-afda-4733-bf55-6d150555b75f
</pre>

Podemos ver el proceso de restauración con la siguiente instrucción:

<pre>$ cinder list
+--------------------------------------+------------------+-----------------------------------------------------+------+-------------+----------+-------------+
|                  ID                  |      Status      |                         Name                        | Size | Volume Type | Bootable | Attached to |
+--------------------------------------+------------------+-----------------------------------------------------+------+-------------+----------+-------------+
| 917ef4cc-784d-4803-a19a-984b847b9f1e |    available     |                        disco1                       |  1   | lvmdriver-1 |  false   |             |
| ebff83f2-cec8-429d-af8a-67e9d012ef5e | restoring-backup | restore_backup_77e2430d-afda-4733-bf55-6d150555b75f |  1   | lvmdriver-1 |  false   |             |
+--------------------------------------+------------------+-----------------------------------------------------+------+-------------+----------+-------------+	
</pre>

Y finalmente vemos que se ha creado un nuevo volumen restaurado desde la copia de seguridad:

<pre>$ cinder list
+--------------------------------------+-----------+-----------------------------------------------------+------+-------------+----------+-------------+
|                  ID                  |   Status  |                         Name                        | Size | Volume Type | Bootable | Attached to |
+--------------------------------------+-----------+-----------------------------------------------------+------+-------------+----------+-------------+
| 917ef4cc-784d-4803-a19a-984b847b9f1e | available |                        disco1                       |  1   | lvmdriver-1 |  false   |             |
| ebff83f2-cec8-429d-af8a-67e9d012ef5e | available | restore_backup_77e2430d-afda-4733-bf55-6d150555b75f |  1   | lvmdriver-1 |  false   |             |
+--------------------------------------+-----------+-----------------------------------------------------+------+-------------+----------+-------------+
</pre>

<p style="text-align: justify;">
  Por último indicar que en la última versión de Openstack (Liberty) se ha introducido la posibilidad de hacer copias de seguridad incrementales y la posibilidad de hacer copias de seguridad aunque el volumen este asociado a una instancia.
</p>

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->