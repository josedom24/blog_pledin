---
title: 'Introducción a git. Comenzando a trbajar con git, github, gitlab,...'
permalink: /2020/02/introduccion-git-github-gitlab/
tags:
  - git
  - GitHub
  - GitLab
published: false
---

![git]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/02/git.png){: .align-center }

En esta entrada vamos a hacer una introducción muy básica del uso de git para controlar las versiones de nuestros proyectos. Realmente este artículo puede servir a cualquiera que se quiera iniciar en el uso de esta tecnología, y en realidad es la clase de introducción que doy a mis alumnos para empezar a usar git en nuestras clases. 

Utilizaremos git para realizar el control de versiones de los proyectos (los proyectos puedes ser de distinto tipo: documentación, código fuente de programas, ... y desde el punto de vista educativo lo podemos usar en distintos ámbitos: el alumno puede guardar sus apuntes en un repositorio, las distintas prácticas se pueden documentar y guardar el código fuente en un repositorio,...). El uso de git nos permitirá realizar los proyectos de forma incremental, registrando los cambios (commits) realizados. 

Los cambios realizados en los ficheros de nuestros proyectos se guardan en repositorios locales, además podemos sincronizar nuestros repositorios locales con repositorios remotos (en la nube), por ejemplo servicios como [GitHub](https://github.com/) o [GitLab](https://about.gitlab.com/) nos posibilitan trabajar con repositorios git remotos. Desde el punto de vista educativo el tener guardado los proyectos en un repositorio remoto puede ser muy bueno para consultar todos los cambios realizados, sus fechas, sus descripciones, y su contenido se podrán compartir con otros compañeros y el profesor.

A mis alumnos le comento que es muy bueno usar repositorios públicos de GitHub/GitLab ya que se convierten en un perfecto escaparate y porfolio de proyectos desarrollados. Cada vez son más las empresas que visitan los perfiles de usuarios de GitHub/GitLab para ver los trabajos realizados. La visibilidad y transparencia de GitHub/GitLab lo convierten también en una herramienta fundamental para aprender, ya que tenemos a nuestra disposición mucha documentación y códigos fuentes de distintos proyectos de software libre que podemos estudiar.

Veamos los pasos fundamentales para crear un repositorio y empezar a trabajar en él:

<!--more-->

## Empecemos

1. Crea una cuenta en GitHub/GitLab. La forma de acceder a los repositorios remotos de GitHub/GitLab va a ser por SSH, y la autentificación la vamos a realizar usando un par de claves pública/privada:

    * Si no tienes un par de claves creada, lo primero que vamos a hacer es crearlas, para ello ejecuta con el usuario que vas a utilizar para trabajar con el repositorio la siguiente instrucción:

        ```
        usuario@ordenador:~$ ssh-keygen
        Generating public/private rsa key pair.
        Enter file in which to save the key (/home/usuario/.ssh/id_rsa): 
        Enter passphrase (empty for no passphrase): 
        Enter same passphrase again: 
        Your identification has been saved in /home/usuario/.ssh/id_rsa.
        Your public key has been saved in /home/usuario/.ssh/id_rsa.pub.
        The key fingerprint is:
        SHA256:VGLCpV7XDEhyslna1h/+PcQ0cU4OT0F52/ti12XRQXY debian@k8s-1
        The key's randomart image is:
        +---[RSA 2048]----+
        |     .+oB.o   +*E|
        |      .&.+ +  .X=|
        |      = = o +  oX|
        |     . + . o .oo+|
        |      . S   o  oo|
        |             ..oo|
        |              .o=|
        |              o =|
        |             . o |
        +----[SHA256]-----+

        usuario@ordenador:~$ cd .ssh
        usuario@ordenador:~/.ssh$ ls 
        id_rsa  id_rsa.pub  known_hosts
        ```

        * Como vemos hemos dejado el nombre de las claves por defecto (la clave privada se llama `id_rsa` y la pública se llama `id_rsa.pub`) las dos claves se guardan en el directorio `/home/usuario/.ssh`.
        * Durante la generación de las claves se nos pide una contraseña *passphase* que se nos pedirá al usar nuestra clave privada. es una buena idea indicar una contraseña para tener más seguridad en el uso de nuestras claves.

    * A continuación tenemos que guardar el contenido de nuestra clave pública (`id_rsa.pub`) en GitHub/GitLab, para que posteriormente usando nuestra clave privada podamos conectarnos al servicio.

        ```
        usuario@ordenador:~/.ssh$ cat id_rsa.pub 
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDozQieWKx7DaojLXhZCQtgm+KYnb9cFwi4gaVB        +5KfYfYVNzKwRfGEy3gH0XEb42slkOxkxvLZfw2nuaasWlG6GSej91dGdHZ7O3t8QazKv8m9k1TEBh6iaWN72c/GqxB/NvRZH3Z7Mg92JL0dGiHH/       NRP9N4Ux7ZUI74mGZ1NyCGdBnMRVNLlwkt7Nx2m3CPB/iJxZzrQWWnyYPyW7IM6ubuqKK8l     +cKHtHtx3qvMzGn2EZKxHrerhLfUIDQUWKN5R9t2cLgsqUZS6TEr30IwATLrI5GIzFX5fJW9OB+Yv7BPOM36KLRkIw5P54bfeTb1fx0fn9N4XdgfxYPtOsY5 usuario@ordenador
        ```

    * En GitHub tenemos que ir a la opción `Settings` de nuestro perfil y a la opción `SSH y GPG keys` y al botón `New SSH key`:

        ![git]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/02/github1.png){: .align-center }
    
    * En GitLab elegimos la opción `Settings` de nuestro perfil y la opción `SSH Keys` y al botón `Add key`:

        ![git]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/02/gitlab1.png){: .align-center }


2. Crea en GitHub/GitLab un repositorio con el nombre **prueba** (inicializa el repositorio con un fichero README) y la descripción **Repositorio de prueba**.

    * En GitHub pulsamos sobre la opción `New Project`:

        ![git]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/02/github2.png){: .align-center }
    
    * En GitLab nos vamos a la pantalla de Proyectos y pulsamos el botón `New Project`:

        ![git]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/02/gitlab2.png){: .align-center }
    
    * Es importante que al crear el repositorio marquemos la opción de crear un fichero README (en este fichero se describe el contenido del repositorio). De esta manera el repositorio tendrá contenido y lo podremos clonar en nuestro ordenador (esta es la forma más sencilla de empezar a usar repositorios: creamos un repositorio remoto en GitHub/GitLab con contenido para luego clonarlo en nuestro repositorio local).

3. Instala git en tu ordenador, como superusuario:

		# apt install git

4. Vamos a configurar git. Lo primero que deberías hacer cuando instalas Git es establecer tu nombre y dirección de correo electrónico. Esto es importante porque las confirmaciones de cambios (commits) en Git usan esta información, y es introducida de manera inmutable en los commits que envías:

		git config --global user.name "José Domingo Muñoz"
		git config --global user.email josedom@example.com

	De nuevo, sólo necesitas hacer esto una vez si especificas la opción `--global`, ya que Git siempre usará esta información para todo lo que hagas en ese sistema.

5. Clonar el repositorio remoto. Copia la url SSH del repositorio (no copies la URL https) y vamos a clonar el repositorio en nuestro ordenador.



		usuario@ordenador:~$ git clone git@github.com:josedom24/prueba.git

	Comprueba que dentro del repositorio que hemos creado se encuentra el fichero README.md, en este fichero podemos poner la descripción del proyecto.

6. Vamos a crear un nuevo fichero, lo vamos a añadir a nuestro repositorio local y luego lo vamos a sincronizar con nuestro repositorio remoto de GitHub. Cada vez que hagamos una modificación en un fichero lo podemos señalar creando un commit. Los mensajes de los commits son fundamentales para explicar la evolución de un proyecto. Un commit debe ser un conjunto pequeño de cambios de los ficheros del proyecto con una cierta coherencia.

		echo "Esto es una prueba">ejemplo.txt
		git add ejemplo.txt
		git commit -m "He creado el fichero ejemplo.txt"
		git push

7. Si modificas un fichero en tu repositorio local, no tienes que volver a añadirlo a tu repositorio (`git add`). Pero tienes que usar la opción -a al hacer el commit.

		git commit -am "He modificado el fichero ejemplo.txt"
		git push

8. Si quieres cambiar el nombre de un fichero o directorio de tu repositorio:

		git mv ejemplo.txt ejemplo2.txt
		git commit -am "He cambiado el nombre del fichero"
		git push

9. Si quieres borrar un fichero de tu repositorio:

		git rm ejemplo2.txt
		git commit -am "He borrado el fichero ejemplo2"
		git push

10. Puedes clonar tu repositorio de GitHub en varios ordenadores (por ejemplo, si quieres trabajar en tu casa y en el instituto), por lo tanto antes de trabajar en un repositorio local tienes que sincronizar los posibles cambios que se hayan producido en el repositorio remoto, para ello:

		git pull

11. Para comprobar el estado de mi repositorio local:

		git status


Si te quieres hacerte un experto de Git:[Pro Git, el libro oficial de Git](http://librosweb.es/pro_git/)



