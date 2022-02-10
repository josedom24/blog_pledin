---
title: 'Construyendo un cluster de bases de datos con Galera MariaDB'
permalink: /2022/02/galera-mariadb/
tags:
  - Base de datos
  - Alta Disponibilidad
---

![galera]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/02/galera_cluster.png){: .align-center }

Este año estamos profundizando en clase en el desarrollo de clusters de alta disponibilidad, y en estos escenarios es necesario tener una infraestructura de cluster de base de datos para que los cambios que se realicen en un nodo se vean reflejado en los demás nodos y el acceso a los datos este sincronizado, de tal forma que podamos leer o escribir en la base de dato de cualquier nodo del cluster sin ningún problema.

Galera MariaDB nos permite crear un cluster activo-activo de bases de datos MariaDB, es decir, todos los nodos funcionan como primarios, pudiendo escribir o leer en la base de datos de cada nodo y sincronizando los contenidos entre ellos.

## Escenario que vamos a montar

Vamos a usar dos nodos para crear un cluster con Galera MariaDB. Las direcciones de estos dos nodos van a ser las siguientes:

* nodo1: `10.1.1.101`
* nodo2: `10.1.1.102`

Los dos nodos tendrán instalado el sistema operativo GNU/Linux Debian 11.

## Instalación y configuración inicial del cluster

Vamos a empezar instalando el paquete `mariadb-server` en los dos nodos:

```
apt install mariadb-server
```

Aunque no es necesario para la construcción del cluster, es recomendable asegurar la instalación ejecutando el comando [`mysql_secure_installation`](https://mariadb.com/kb/en/mysql_secure_installation/), que nos permite realizar las siguientes tareas:

* Establecer una contraseña para la cuenta root.
* Permitir el acceso solo desde localhost para la cuenta root.
* Eliminar el acceso anónimo.
* Eliminar la base de datos de test, accesible por todos los usuarios, incluidos los anónimos, y eliminar los privilegios que permiten a cualquier usuario acceder a las bases de datos con nombres que empiezan por test_.

<!--more-->

### Creación del cluster

A continuación vamos a escoger un nodo, que va a ser desde el que creemos el cluster, para posteriormente ir añadiendo los nuevos nodos al cluster creado. En nuestro caso, vamos a escoger el **nodo1**, por lo que las siguientes instrucciones la vamos a ejecutar en este nodo:

Paramos el servicio:

```
root@nodo1:~# systemctl stop mariadb.service
```

A continuación vamos a configurar el cluster, modificamos el fichero `/etc/mysql/mariadb.conf.d/60-galera.cnf`, para que tenga la siguiente configuración:

```
#
# * Galera-related settings
#
# See the examples of server wsrep.cnf files in /usr/share/mysql
# and read more at https://mariadb.com/kb/en/galera-cluster/

[galera]
wsrep_on                 = 1
wsrep_cluster_name       = "MariaDB Galera Cluster"
wsrep_provider           = /usr/lib/galera/libgalera_smm.so
wsrep_cluster_address    = gcomm://10.1.1.101,10.1.1.102
binlog_format            = row
default_storage_engine   = InnoDB
innodb_autoinc_lock_mode = 2

# Allow server to accept connections on all interfaces.
bind-address = 0.0.0.0
wsrep_node_address=10.1.1.101
```

Podemos señalar algunos parámetros importantes:

* `wsrep_on = 1`: Activa el cluster.
* `wsrep_cluster_address`: Indicamos las IP de los nodos que van a formar parte del cluster.
* `bind-address = 0.0.0.0`: Permitimos las conexiones a la base de datos  desde todas las interfaces de red.
* `wsrep_node_address`: Dirección IP del nodo que estamos configurando.

A continuación vamos a crear el cluster e iniciar el servicio:

```
root@nodo1:~# galera_new_cluster 
root@nodo1:~# systemctl start mariadb.service 
```

Podemos comprobar que el cluster se ha creado obteniendo información del servidor. Todas las variables que comienzan por el nombre `wsrep_` nos dan información del cluster y podríamos ejecutar en nuestra base de datos la instrucción `SHOW STATUS LIKE 'wsrep_%';`, pero en nuestro caso sólo vamos a obtener el valor de la variable que nos indica el número de nodos que tiene el cluster:

```
root@nodo1:~# mysql -u root -p
Enter password: 
...

MariaDB [(none)]> SHOW STATUS LIKE 'wsrep_cluster_size';
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| wsrep_cluster_size | 1     |
+--------------------+-------+
1 row in set (0.002 sec)
```

### Añadir nodos al cluster

A continuación vamos a incluir el **nodo2** al cluster, para ello vamos a configurar el fichero `/etc/mysql/mariadb.conf.d/60-galera.cnf` del nodo2 con el mismo contenido que añadimos al nodo1, a excepción del parámetro `wsrep_node_address` donde indicaremos la IP del nodo2:

```
...
wsrep_node_address=10.1.1.102
...
```

Y reiniciamos el servicio:

```
root@nodo2:~# systemctl restart mariadb-server
```

Y podemos volver a comprobar el número de nodos del cluster ejecutando la instrucción anterior en cualquiera de los dos nodos:

```
root@nodo2:~# mysql -u root -p
Enter password: 
...

MariaDB [(none)]> SHOW STATUS LIKE 'wsrep_cluster_size';
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| wsrep_cluster_size | 2     |
+--------------------+-------+
1 row in set (0.002 sec)
```

## Pruebas de funcionamiento

Para comprobar que funciona el cluster vamos a crear una base de datos en el nodo1, y posteriormente comprobaremos que también es accesible desde el nodo2:

```
root@nodo1:~# mysql -u root -p
Enter password: 
...

MariaDB [(none)]> create database prueba;
Query OK, 1 row affected (0.014 sec)
```

Y hacemos la comprobación en el nodo2:

```
root@nodo2:~# mysql -u root -p
Enter password: 
...

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| prueba             |
+--------------------+
4 rows in set (0.001 sec)
```

## Conclusiones

El uso de un cluster Galera MariaDB puede se muy beneficioso en escenario de cluster de alta disponibilidad donde tenemos varios nodos ofreciendo un servicio y necesitan guardar y acceder a información guardada en una base de datos centralizada. Como siempre, esta entrada es sólo una introducción a la creación y configuración de Galera MariaDB sobre un GNU/Linux Debian 11. Si quieres obtener más información para otros sistemas operativos y profundizar en la configuración de un cluster de mariadb, puedes obtener más información en la [documentación oficial](https://mariadb.com/kb/en/getting-started-with-mariadb-galera-cluster/).