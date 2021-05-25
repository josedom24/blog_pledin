---
title: 'Nuevo sistema de comentarios con Staticman'
permalink: /2021/05/comentarios-pledin-staticman/
tags:
  - Pledin
---

![staticman]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2021/05/staticman.png){: .align-center }

Cuando [migré mi página personal Pledin](https://www.josedomingo.org/pledin/2018/09/bienvenidos-a-pledin30/) a un sistema de generación de páginas estáticas como Jekyll, tuve que decidir que sistema de comentarios pondría en mi blog. Teníendo en cuenta que ahora la página es estática, y no tenemos la posibilidad de programar esa funcionalidad, había que escoger un servicio externo para poder gestionar los comentarios escritos en los distintos post. En aquel momento elegí la opción de **Disqus**, que me parecía adecuada para lo que necesitaba.

Además de que Discus no es software libre y que pierdes el control de la gestión de tus comentarios, en los últimos tiempos incluía demasiada publicidad en mi página web, por lo que en los últimos días he estado buscando una alternativa a Disqus como sistema de comentarios para mi blog.

Mi decisión final ha sido utilizar [Staticman](https://staticman.net/). Veamos cómo ha sido el proceso del cambio...

<!--more-->

## ¿Cómo funciona Staticman?

**Staticman** esta pensado para gestionar los comentarios de un blog que esté construido con páginas estáticas. En mi caso es perfecto, yo uso el generador de sitios estáticos [Jekyll](https://jekyllrb.com/) para crear mi página estática. Además uso el tema de jekyll [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/) que tienes soporte para Staticman, por lo que me va a facilitar el trabajo.

Pero, **¿cómo funciona Staticman?**: En realidad no tenemos una base de datos, ni podemos hacer un programa que guarde los comentarios que vamos introduciendo en nuestros posts. **Staticman** es un programa escrito en node.js (es software libre), y nos ofrece una API a la que podemos mandar los datos del comentario desde un formulario HTML y se encarga de generar una fichero yaml con la información del comentario y hacer un pull request sobre nuestro repositorio GitHub para añadir dicho fichero con el comentario. Aunque staticman podría escribir directamente en el repositorio, esta forma de crear un pull request me parece más acertada, por que da la posibilidad de moderar los comentarios, ya que soy yo el que finalmente va a aceptar o no el pull request y en consecuencia añadir un nuevo fichero con un nuevo comentario en mi repositorio.

## Permitir que Saticman pueda trabajar con GitHub

**Staticman** se va comportar como un bot que será capaz de acceder a mi repositorio github donde tengo almacenada mi página personal para hacer un pull request que añadirá un fichero con la información de un comentario.

En la la [documentación](https://staticman.net/docs/getting-started.html) podemos encontrar distintos métodos para que Staticman se autentifique contra GitHub, en mi caso he seguido la opción de **Usar un token personal para el acceso a GitHub**, para ello seguimos los siguientes pasos:

Registramos una nueva cuenta en GitHub que es la que va a utilizar Staticman para acceder a GitHub. En mi caso la hellamado *pledin-staticman*:

![cuenta]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2021/05/cuenta-github.png){: .align-center }

Vamos a crear un token de acceso para esta cuenta: `Settings` - `Developer settings` - `Personal access tokens` - `Generate new token`:

![cuenta]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2021/05/token-personal.png){: .align-center }

En esta pantalla indicamos un nombre y damos los permisos adecuados con los que vamos a tener acceso con este token, de principio sólo sería necesario escoger el apartado **repo**. Guardamos el token que hemos generado que lo utilizaremos posteriormente.

## Instalación de Staticman

Siguiendo la [documentación](https://staticman.net/docs/getting-started.html) de Staticman, nos ofrecen varias formas de desplegar el programa. En mi caso he elegido docker, y he realizado la instalación en el mismo servidor donde tengo alojada mi página. Para ello he clonado el repositorio del proyecto y he creado el contenedor docker de la siguiente manera:

```bash
$ git clone https://github.com/eduardoboucas/staticman.git
```

A continuación necesito generar una clave privada que permitirá a Staticman poder encriptar los datos sensibles, para ello ejecuto:

```bash
$ openssl genrsa
```

Finalmente voy a crear el contenedor de Staticman usando el fichero `docker-compose.yml`, por medio de variables de entorno voy a configurar la aplicación, tenemos distintos [parámetros de configuración](https://staticman.net/docs/api), pero al menos hay que indicar el parámetro `GITHUB_TOKEN` donde indicamos el token de acceso que hemos generado al crear la cuenta de github, y `RSA_PRIVATE_KEY` donde vamos a indicar la clave privada que hemos generado en el paso anterior. El fichero `docker-compose.yml` quedaría:

```yaml
version: '2'
services:
  staticman:
    build: .
    env_file: .env
    ports:
      - '8080:3000'
    restart: unless-stopped
    environment:
      NODE_ENV: production
      PORT: 3000
      GITHUB_TOKEN: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      RSA_PRIVATE_KEY: |
         -----BEGIN RSA PRIVATE KEY-----
         ...
```

Al ejecutar el `docker-compose` se creará una nueva imagen a partir del fichero `Dockerfile`, que será la utilizada para crear el contenedor:

```bash
$ docker-compose up -d
...
$ docker-compose ps
        Name             Command    State           Ports         
------------------------------------------------------------------
staticman_staticman_1   npm start   Up      0.0.0.0:8080->3000/tcp
```

Y comprobamos que la API nos responde, ejecutando:

```bash
$ curl http://localhost:8080/
Hello from Staticman version 3.0.0!
```

Necesitamos que la API sea accesible desde internet, por lo tanto vamos a usar un proxy inverso para que accediendo al nombre `comentarios.josedomingo.org` (este nombre lo hemos creado en nuestro DNS para que apunte al servidor) estemos accediendo a la API, en mi caso he usado apache2 como proxy inverso y la configuración quedaría:

```xml
<VirtualHost *:443>
        ServerAdmin webmaster@localhost
        ServerName   comentarios.josedomingo.org
        ErrorLog ${APACHE_LOG_DIR}/error_staticman.log
        CustomLog ${APACHE_LOG_DIR}/acceess_staticman.log combined
        ProxyPass "/" "http://localhost:8080/"
        Include /etc/letsencrypt/options-ssl-apache.conf
        SSLCertificateFile /etc/letsencrypt/live/josedomingo.org/fullchain.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/josedomingo.org/privkey.pem
</VirtualHost>
```
Ahora nuestra instancia de Staticman será accesible desde internet, podemos probar ejecutando:

```bash
$ curl https://comentarios.josedomingo.org
Hello from Staticman version 3.0.0!
```

## Envíando una invitación de colaboración a nuestra instancia de Staticman

A continuación, desde nuestra nuestra cuenta principal de GitHub, vamos a invitar a nuestra instancia Staticman para que tenga permisos de acceder a nuestro repositorio donde tenemos los ficheros de nuestra página, para ello [seguimos estos pasos](https://docs.github.com/en/github/setting-up-and-managing-your-github-user-account/managing-access-to-your-personal-repositories/inviting-collaborators-to-a-personal-repository): desde el repositorio, `Settings` - `Manage access` - `Invite a collaborator`, elegimos el nombre de la nueva cuenta, y lo invitamos para colaborar.

![cuenta]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2021/05/invitacion.png){: .align-center }

Para aceptar la invitación por parte de nuestra instancia de Staticman tendremos que hacer una petición GET a `{STATICMAN_BASE_URL}/v3/connect/{GIT_PROVIDER_USERNAME}/{REPO}` y recibir un `OK!` como respuesta, en mi caso:

```bash
$ curl https://comentarios.josedomingo.org/v3/connect/josedom24/blog_pledin
OK!
```

Y podemos comprobar que hemos añadido de coplaborador al usaurio `pledin-staticman`:

![cuenta]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2021/05/colaborador.png){: .align-center }

