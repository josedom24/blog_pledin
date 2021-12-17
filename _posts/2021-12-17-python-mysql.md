---
title: 'Gestión de base de datos mysql/mariadb con python3'
permalink: /2021/12/python3-mysql/
tags:
  - Python
  - Base de datos
---

![python]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2021/12/python_mysql.png){: .align-center }

Este año en el módulo de Lenguaje de Marcas, donde hacemos una introducción al lenguaje de programación Python, vamos a añadir una unidad para que los alumnos aprendan a gestionar información guardada en una base de datos con python3. En concreto, vamos a mostrar en esta entrada del blog cómo poder trabajar con bases de datos mysql/mariadb desde python3.

## ¿Cómo podemos trabajar con mysql/mariadb desde python3?

Tenemos varios paquetes que nos permiten gestionar una base de datos mysql/mariadb desde python3:

* [`mysqlclient`](https://github.com/PyMySQL/mysqlclient): Es un fork del proyecto [`MySQLdb1`](https://github.com/farcepest/MySQLdb1), basado en una librería escrita en C, que implementa la API de acceso a las base de datos mysql. Tiene soporte para python3 y arregla algunos errores del proyecto original. Podemos usar el módulo `MySQLdb` escrito en python que nos facilita su uso. [Documentación oficial](https://mysqlclient.readthedocs.io/).
* [`PyMySQL`](https://github.com/PyMySQL/PyMySQL): Librería escrita totalmente en Python que implementa la API de acceso a la base de datos. Desde el punto de vista del rendimiento, es peor que la anterior. [Documentación oficial](https://pymysql.readthedocs.io/en/latest/).
* [`mysql-connector-python`](https://github.com/mysql/mysql-connector-python): El driver (conector) ofrecido oficialmente por Oracle. [Documentación oficial](https://dev.mysql.com/doc/dev/connector-python/8.0/).

El uso de las tres librerías es muy similar, ya que todas implementan la API de acceso a las base de datos mysql que es un estándar especificado en [PEP 249: Python Database API Specification v2.0](https://www.python.org/dev/peps/pep-0249/).

## Introducción a mysqlclient/MySQLdb

En este documento vamos a usar la librería `mysqlclient`, más concretamente el módulo `MySQLdb` para conectar a una base de datos mysql/mariadb y gestionar la información guardada en ella. Vamos a trabajar en un un sistema GNU/Linux Debian Bullseye y una base de datos mariadb 1:10.5.

Vamos a partir del siguiente escenario: tenemos instalada la base de datos mariadb en el sistema, hemos creado un usuario para el acceso y una base de datos con una tabla que tiene el siguiente esquema:

```
$ mysql -u usuario -p
...
MariaDB [(none)]> use testdb;
...
MariaDB [testdb]> desc EMPLOYEE;
+------------+----------+------+-----+---------+-------+
| Field      | Type     | Null | Key | Default | Extra |
+------------+----------+------+-----+---------+-------+
| FIRST_NAME | char(20) | NO   |     | NULL    |       |
| LAST_NAME  | char(20) | YES  |     | NULL    |       |
| AGE        | int(11)  | YES  |     | NULL    |       |
| SEX        | char(1)  | YES  |     | NULL    |       |
| INCOME     | float    | YES  |     | NULL    |       |
+------------+----------+------+-----+---------+-------+
```

<!--more-->

## Instalación de MySQLdb

Podemos instalarlo desde los repositorios de Debian:

    # apt install python3-mysqldb

O en un entorno virtual, usando pip. Para ello antes de realizar la instalación tenemos que instalar las librerías necesarias:

    # apt install python3-dev default-libmysqlclient-dev build-essential

Y una vez que tenemos creado y activado el entorno virtual:

    (db)$ pip install mysqlclient


## Conexión a la base de datos

Para conectar a la base de datos vamos a usar el método `connect` de la librería `MySQLdb`. Como parámetros indicaremos: 

* La dirección del servidor de base de datos
* El usuario que vamos a usar para la conexión.
* La contraseña del usuario
* La base de datos a la que vamos a conectar. 

Nos devuelve un objeto que representa la conexión. Vamos a usar una excepción por si tenemos un error al conectar. Al terminar el programa debemos cerrar la conexión usando el método `close()` del objeto conexión.

```python
import sys
import MySQLdb
try:
	db = MySQLdb.connect("localhost","usuario","asdasd","testdb" )
except MySQLdb.Error as e:
	print("No puedo conectar a la base de datos:",e)
	sys.exit(1)
print("Conexión correcta.")
db.close()
```

## Ejecución de instrucciones sql

Para ejecutar instrucciones sql vamos a usar un objeto de la clase `cursor`. Por ejemplo vamos a insertar datos en la tabla:

```python
import sys
import MySQLdb
try:
	db = MySQLdb.connect("localhost","usuario","asdasd","testdb" )
except MySQLdb.Error as e:
	print("No puedo conectar a la base de datos:",e)
	sys.exit(1)

cursor = db.cursor()
sql="insert into EMPLOYEE values ('%s', '%s', '%d', '%c', '%d' )" % ('José', 'Domingo', 20, 'M', 2000)
try:
   cursor.execute(sql)
   db.commit()
except:
   db.rollback()
db.close()
```

Veamos detenidamente el código:

1. Una vez realizada la conexión hemos creado un obejo de tipo cursor que nos permitirá la ejecución de instrucciones sql (`cursor = db.cursor()`).
2. Hemos guardado en una variable (`sql`) la instrucción que vamos a ejecutar. Los datos que vamos a añadir podrían estar guardado en cualquier estructura de datos (variables, listas, diccionarios,...).
3. La ejecución de la instrucción la realizamos con el método `execute` del cursor (`cursor.execute(sql)`). Controlamos los fallos con una excepción.
4. Además de ejecutar la instrucción tenemos que confirmar el cambio en la base de datos para ello usamos el método `commit` de la conexión (`db.commit()`).
5. Si hay algún error (sección `except` de la excepción), volvemos al estado anterior de la base de datos con el método `rollback` de la conexión (`db.rollback()`).

Al ejecutar el programa podemos comprobar que se ha añadido un registro en la tabla:

```
MariaDB [testdb]> select * from EMPLOYEE;
+------------+-----------+------+------+--------+
| FIRST_NAME | LAST_NAME | AGE  | SEX  | INCOME |
+------------+-----------+------+------+--------+
| José       | Domingo   |   20 | M    |   2000 |
+------------+-----------+------+------+--------+
```

De esta manera podemos ejecutar cualquier tipo de instrucción sql: inserciones (insert), modificaciones (update), eliminaciones (delete), creación de tablas (create), modificaciones de una tabla (alter),...

## Lectura de información de la tabla

**Nota: Hemos añadido 3 registros en la tabla para realizar este apartado**.

En este apartado vamos a ver cómo obtener información de una base de datos ejecutando una instrucción select. Para realizar una consulta de una tabla ejecutaremos una instrucción select como hemos visto en el punto anterior. Una vez realizada la consulta podemos usar varios métodos y atributos del cursor:

* `rowcount`: Es un atributo que nos devuelve el número de registros seleccionados.
* `fetchone()`: Es un método que nos devuelve el siguiente registro seleccionado. Devuelve un sólo registro.
* `fetchall()`: Método que nos devuelve todos los registros seleccionados.

Veamos algunos ejemplos:

### Mostrar número de registros seleccionados

```python
import sys
import MySQLdb
try:
	db = MySQLdb.connect("localhost","usuario","asdasd","testdb" )
except MySQLdb.Error as e:
	print("No puedo conectar a la base de datos:",e)
	sys.exit(1)

sql="select * from EMPLOYEE"
cursor = db.cursor()
try:
   cursor.execute(sql)
   print("Número de registros seleccionados:", cursor.rowcount)
except:
   print("Error en la consulta")
db.close()
```

En este ejemplo se imprime el número de registros seleccionados:

```bash
$ python3 programa.py 
Número de registros seleccionados: 3
```

### Listar los registros seleccionados

Vamos a listar todos los registros de la tabla:

```python
import sys
import MySQLdb
try:
	db = MySQLdb.connect("localhost","usuario","asdasd","testdb" )
except MySQLdb.Error as e:
	print("No puedo conectar a la base de datos:",e)
	sys.exit(1)

sql="select * from EMPLOYEE"
cursor = db.cursor()
try:
   cursor.execute(sql)
   registros = cursor.fetchall()
   for registro in registros:
      print(registro[0],registro[1],registro[2],registro[3],registro[4])
except:
   print("Error en la consulta")
db.close()
```

Veamos con detenimiento este ejemplo:

1. La variable `registros` guarda todos los registros seleccionados de la consulta. Po defecto se devuelve una tupla de tuplas:

```
(('José', 'Domingo', 20, 'M', 2000.0), ('Pablo', 'Ruíz', 21, 'M', 2100.0), ('María', 'López', 22, 'F', 2200.0))
```

2. Podemos recorrer los registros con un `for`, cada campo de un registro se guardará en una posición, por lo que usamos el indice para acceder:

```
for registro in registros:
   print(registro[0],registro[1],registro[2],registro[3],registro[4])
```

Veamos la ejecución del programa:

```bash
$ python3 programa.py 
José Domingo 20 M 2000.0
Pablo Ruíz 21 M 2100.0
María López 22 F 2200.0
```

### Listar los registros seleccionados usando un diccionario

Si tenemos muchos atributos en una tabla, puede ser complicado usar índices para seleccionarlos. Lo ideal sería que el cursos nos devolviera una tupla de diccionarios, y de esta manera poder referenciar los atributos por su nombre. Para ello, al crear el cursor debemos indicar que su tipo sea `DictCursor`, para ello:

```
...
cursor = db.cursor(MySQLdb.cursors.DictCursor)
...
```

De esta forma al devolver los registros seleccionados se nos devolverá una tupla de diccionarios:

```
({'FIRST_NAME': 'José', 'LAST_NAME': 'Domingo', 'AGE': 20, 'SEX': 'M', 'INCOME': 2000.0}, {'FIRST_NAME': 'Pablo'...
```

Podemos listar el primer nombre de los trabajadores de esta forma:

```python
import sys
import MySQLdb
try:
	db = MySQLdb.connect("localhost","usuario","asdasd","testdb")
except MySQLdb.Error as e:
	print("No puedo conectar a la base de datos:",e)
	sys.exit(1)

sql="select * from EMPLOYEE"
cursor = db.cursor(MySQLdb.cursors.DictCursor)
try:
   cursor.execute(sql)
   registros = cursor.fetchall()
   for registro in registros:
      print(registro["FIRST_NAME"])
except:
   print("Error en la consulta")
db.close()
```

### Recorriendo los registros seleccionados secuencialmente

Si no tenemos muchos registros el uso de `fetchall()` puede ser adecuado. Pero si tenemos gran cantidad de registros puede que tengamos problemas de rendimiento. La solución es ir recorriendo los registros seleccionados uno a uno, usando `fetchone()`. En este caso podemos usar una estructura `while`: "mientras haya otro registro, lo proceso.". El ejemplo quedaría de la siguiente manera (imprimimos el nombre y apellido del empleado):

```python
import sys
import MySQLdb
try:
	db = MySQLdb.connect("localhost","usuario","asdasd","testdb")
except MySQLdb.Error as e:
	print("No puedo conectar a la base de datos:",e)
	sys.exit(1)

sql="select * from EMPLOYEE"
cursor = db.cursor(MySQLdb.cursors.DictCursor)
try:
   cursor.execute(sql)
   registro = cursor.fetchone()
   while registro:
      print(registro["FIRST_NAME"],registro["LAST_NAME"])
      registro = cursor.fetchone()
except:
   print("Error en la consulta")
db.close()
```

## Conclusiones

Hemos usado la librería `mysqldb` para introducir las posibilidades de gestionar una base de datos mysql/mariadb usando python3. Cómo hemos comentado tenemos varias opciones para realizar este trabajo, si miras cualquier manual que use otra de las librerías disponibles verás que la metodología es muy similar, esto es debido a que todas las librerías implementan la [Python Database API Specification v2.0](https://www.python.org/dev/peps/pep-0249/).

Como siempre para seguir profundizando tienes que estudiar la [documentación oficial](https://mysqlclient.readthedocs.io/).
