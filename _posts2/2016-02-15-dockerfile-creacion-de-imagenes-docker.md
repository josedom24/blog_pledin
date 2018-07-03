---
id: 1620
title: 'Dockerfile: Creación de imágenes docker'
date: 2016-02-15T19:10:48+00:00


guid: http://www.josedomingo.org/pledin/?p=1620
permalink: /2016/02/dockerfile-creacion-de-imagenes-docker/


tags:
  - docker
  - Virtualización
---

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile.png" rel="attachment wp-att-1636"><img class="size-full wp-image-1636 aligncenter" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile.png" alt="dockerfile" width="307" height="180" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile.png 307w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/dockerfile-300x176.png 300w" sizes="(max-width: 307px) 100vw, 307px" /></a>

En la entrada anterior, estudiamos un método para crear nuevas imágenes a partir de contenedores que anteriormente habíamos configurado. En esta entrada vamos a presentar la forma más usual de crear nuevas imágenes: usando el comando `docker buid` y definiendo las características que queremos que tenga la imagen en un fichero `Dockerfile`.

## ¿Cómo funciona docker build?

Un `Dockerfile` es un fichero de texto donde indicamos los comandos que queremos ejecutar sobre una imagen base para crear una nueva imagen. El comando `>docker build` construye la nueva imagen leyendo las instrucciones del fichero `Dockerfile` y la información de un entorno, que para nosotros va a ser un directorio (aunque también podemos guardar información, por ejemplo, en un repositorio git).

La creación de la imagen es ejecutada por el **docker engine**, que recibe toda la información del entorno, por lo tanto es recomendable guardar el `Dockerfile` en un directorio vacío y añadir los ficheros necesarios para la creación de la imagen. El comando `docker build` ejecuta las instrucciones de un `Dockerfile` línea por línea y va mostrando los resultados en pantalla.

Tenemos que tener en cuenta que cada instrucción ejecutada crea una imagen intermedia, una vez finalizada la construcción de la imagen nos devuelve su *id*. Alguna imágenes intermedias se guardan en caché, otras se borran. Por lo tanto, si por ejemplo, en un comando ejecutamos `cd /scripts/` y en otra linea le mandamos a ejecutar un script (`./install.sh`) no va a funcionar, ya que ha lanzado otra imagen intermedia. Teniendo esto en cuenta, la manera correcta de hacerlo sería:

    cd /scripts/;./install.sh

Para terminar indicar que la creación de imágenes intermedias generadas por la ejecución de cada instrucción del `Dockerfile`, es un mecanismo de caché, es decir, si en algún momento falla la creación de la imagen, al corregir el `Dockerfile` y volver a construir la imagen, los pasos que habían funcionado anteriormente no se repiten ya que tenemos a nuestra disposición las imágenes intermedias, y el proceso continúa por la instrucción que causó el fallo.

## Buenas prácticas al crear Dockerfile

### Los contenedores deber ser "efímeros"

Cuando decimos "efímeros" queremos decir que la creación, parada, despliegue de los contenedores creados a partir de la imagen que vamos a generar con nuestro `Dockerfile` debe tener una mínima configuración.

###  Uso de ficheros .dockerignore

Como hemos indicado anteriormente, todos los ficheros del contexto se envían al **docker engine**, es recomendable usar un directorio vacío donde vamos creando los ficheros que vamos a enviar. Además, para aumentar el rendimiento, y no enviar al *daemon* ficheros innecesarios podemos hacer uso de un fichero `.dockerignore`, para excluir ficheros y directorios.

### No instalar paquetes innecesarios

Para reducir la complejidad, dependencias, tiempo de creación y tamaño de la imagen resultante, se debe evitar instalar paquetes extras o innecesarios Si algún paquete es necesario durante la creación de la imagen, lo mejor es desinstalarlo durante el proceso.

### Minimizar el número de capas

Debemos encontrar el balance entre la legibilidad del `Dockerfile` y minimizar el número de capa que utiliza.

### Indicar las instrucciones a ejecutar en múltiples líneas

Cada vez que sea posible y para hacer más fácil futuros cambios, hay que organizar los argumentos de las instrucciones que contengan múltiples líneas, esto evitará la duplicación de paquetes y hará que el archivo sea más fácil de leer. Por ejemplo:

    RUN apt-get update && apt-get install -y \
    git \
    wget \
    apache2 \
    php5

## Instrucciones de Dockerfile

En este apartado vamos a hacer una introducción al uso de las instrucciones más usadas que podemos definir dentro de un fichero `Dockerfile`, para una descripción más detallada consulta la <a href="https://docs.docker.com/engine/reference/builder/">documentación oficial</a>.

### FROM

`FROM` indica la imagen base que va a utilizar para seguir futuras instrucciones. Buscará si la imagen se encuentra localmente, en caso de que no, la descargará de internet.

**Sintaxis**

    FROM <imagen>
    FROM <imagen>:<tag>

### MAINTAINER

Esta instrucción nos permite configurar datos del autor que genera la imagen.

**Sintaxis**

    MAINTAINER <nombre> <Correo>

### RUN

Esta instrucción ejecuta cualquier comando en una capa nueva encima de una imagen y hace un commit de los resultados. Esa nueva imagen intermedia es usada para el siguiente paso en el `Dockerfile`. `RUN` tiene 2 formatos:

* El modo shell: `/bin/sh -c`
      
        RUN comando

* Modo ejecución:

        RUN ["ejecutable", "parámetro1", "parámetro2"]

    El modo ejecución nos permite correr comandos en imágenes bases que no cuenten con `/bin/sh`, nos permite además hacer uso de otra shell si así lo deseamos, ejemplo:

        RUN ["/bin/bash", "-c", "echo prueba"]

### ENV

Esta instrucción configura las variables de ambiente, estos valores estarán en los ambientes de todos los comandos que sigan en el `Dockerfile`.

**Sintaxis**

    ENV <key> <value>
    ENV <key>=<value> ...

Estos valores persistirán al momento de lanzar un contenedor de la imagen creada y pueden ser usados dentro de cualquier fichero del entorno, por ejemplo un script ejecutable. Pueden ser sustituida pasando la opción `-env` en `docker run`. Ejemplo:

    docker run -env <key>=<valor>

### ADD

Esta instrucción copia los archivos o directorios de una ubicación especificada y los agrega al sistema de archivos del contenedor en la ruta especificada. Tiene dos formas:

**Sintaxis**

    ADD <src>... <dest>
    ADD ["<src>",... "<dest>"]

### EXPOSE

Esta instrucción le especifica a docker que el contenedor escucha en los puertos especificados en su ejecución. `EXPOSE` no hace que los puertos puedan ser accedidos desde el host, para esto debemos mapear los puertos usando la opción `-p` en `docker run`.

**Ejemplo:**

    EXPOSE 80 443

### CMD y ENTRYPOINT

Estas dos instrucciones son muy parecidas, aunque se utilizan en situaciones diferentes, y además pueden ser usadas conjuntamente, en el <a href="https://www.ctl.io/developers/blog/post/dockerfile-entrypoint-vs-cmd/">siguiente artículo</a> se explica muy bien su uso.

Estas dos instrucciones nos permiten especificar el comando que se va a ejecutar por defecto, sino indicamos ninguno cuando ejecutamos el `docker run`. Normalmente las imágenes bases (debian, ubuntu,...) están configuradas con estas instrucciones para ejecutar el comando `/bin/sh` o `/bin/bash`. Podemos comprobar el comando por defecto que se ha definido en una imagen con el siguiente comando:

    $ docker inspect debian
    ...
    "Cmd": [
                      "/bin/bash"
           ],
    ...


Por lo tanto no es necesario indicar el comando como argumento, cuando se inicia un contenedor:

    $ docker run -i -t  debian

En el siguiente gráfico puedes ver los detalles de algunas imágenes oficiales: su tamaño, las capas que la conforman y el comando que se define por defecto:

<a class="thumbnail" href="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/image-layers.png" rel="attachment wp-att-1633"><img class="aligncenter size-full wp-image-1633" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/image-layers.png" alt="image-layers" width="478" height="292" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/image-layers.png 478w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2016/02/image-layers-300x183.png 300w" sizes="(max-width: 478px) 100vw, 478px" /></a>

**CMD**

`CMD` tiene tres formatos:

* Formato de ejecución:

        CMD ["ejecutable", "parámetro1", "parámetro2"]

* Modo shell:

        CMD comando parámetro1 parámetro2

* Formato para usar junto a la instrucción ENTRYPOINT

        CMD ["parámetro1","parámetro2"]

Solo puede existir una instrucción `CMD` en un `Dockerfile`, si colocamos más de una, solo la última tendrá efecto.Se debe usar para indicar el comando por defecto que se va a ejecutar al crear el contenedor, pero permitimos que el usuario ejecute otro comando al iniciar el contenedor.

**ENTRYPOINT**

`ENTRYPOINT` tiene dos formatos:

* Formato de ejecución:

        ENTRYPOINT ["ejecutable", "parámetro1", "parámetro2"]

* Modo shell:

        ENTRYPOINT comando parámetro1 parámetro2

Esta instrucción también nos permite indicar el comando que se va ejecutar al iniciar el contenedor, pero en este caso el usuario no puede indicar otro comando al iniciar el contenedor. Si usamos esta instrucción no permitimos o no  esperamos que el usuario ejecute otro comando que el especificado. Se puede usar junto a una instrucción `CMD`, donde se indicará los parámetro por defecto que tendrá el comando indicado en el `ENTRYPOINT`. Cualquier argumento que pasemos en la línea de comandos mediante `docker run` serán anexados después de todos los elementos especificados mediante la instrucción `ENTRYPOINT`, y anulará cualquier elemento especificado con CMD.

**Ejemplo:**

Si tenemos un fichero `Dockerfile`, que tiene las siguientes instrucciones:

    ENTRYPOINT ["http", "-v"]

    CMD ["-p", "80"]

Podemos crear un contenedor a partir de la imagen generada:

* `docker run centos:centos7`: Se creará el contenedor con el servidor web escuchando en el puerto 80.
* `docker run centos:centros7 -p 8080`: Se creará el contenedor con el servidor web escuchando en el puerto 8080.

## Conclusiones

En esta entrada hemos estudiado los fundamentos y conceptos necesarios para crear imágenes a partir de fichero `Dockerfile` y el comando `docker build`. En la próxima entrada vamos a estudiar algunos ejemplos de ficheros `Dockerfile`, y la creación de contenedores a partir de las imágenes que vamos a generar.


<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->