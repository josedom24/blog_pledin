---
title: 'Trabajando con claves ssh'
permalink: /2023/01/claves-ssh/
tags:
  - ssh
  - Manuales
---

En el trabajo cotidiano de los administradores de sistemas una de las tarea que se hace a menudo es la conexión remota a servidores usando el protocolo ssh. Además de la posibilidad de usar nombre de usuario y contraseña para autentificarnos en la máquina remota, en este post vamos a estudiar otra manera de autentificación que nos proporciona ssh: **Autentificación usando claves ssh**.

Como casi siempre, escribo este artículo para mis alumnos, en esta ocasión, para mis alumnos de 2º del ciclo de grado medio de Sistemas Microinformáticos y Redes. Vamos a ello:

## Entorno de trabajo

Vamos a trabajar con dos máquinas donde hemos instalado el sistema operativo Debian 11:

* **nodo1**: Actuará de cliente, desde donde nos vamos a conectar. Tiene la dirección IP `10.0.0.10` y hemos creado un usuario que hemos llamado **usuario1**.
* **nodo2**: Actuará como servidor ssh, es la máquina a la que nos vamos a conectar. Tiene la dirección IP `10.0.0.11` y hemos creado un usuario que hemos llamado **usuario2**.

Por lo tanto nos vamos a conectar desde la máquina `nodo1` con el usuario `usuario1` a la máquina `nodo2` con el `usuario2`.

## Creación de las claves ssh en el cliente

En la máquina cliente `nodo1`, el `usuario1` va a crear sus claves ssh, en concreto, un par de claves pública/privada cifradas con el algoritmo RSA. Para generar las claves vamos a usar el comando `ssh-keygen` y durante la generación se nos solicita alguna información:

* **La ubicación y el nombre de las claves**: En principio el directorio donde se guarda es `.ssh` en el home del usuario, y el nombre puede ser cualquiera, pero para empezar os sugiero que dejéis el que viene por defecto `id_rsa`, de esta manera no habrá que indicar el nombre de la clave al realizar la conexión (se toma el nombre `id_rsa` por defecto). Por lo tanto en la primera pregunta dejamos los valores por defecto.
* **Frase de paso (passphrase)**: Se nos pide a continuación una palabra de paso. Por seguridad, os sugiero que la pongáis porque será la contraseña de vuestra clave privada. Al utilizar la clave privada se os pedirá la frase de paso. Si vuestra clave privada cae en malas manos necesitarán esta frase para poder usarla.

```sh
usuario1@nodo1:~$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/usuario1/.ssh/id_rsa): 
Created directory '/home/usuario1/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/usuario1/.ssh/id_rsa
Your public key has been saved in /home/usuario1/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:FfyzzFqODXZi+sFeLei+1ILURDTmzHwt8khSUvj+TjY usuario1@nodo1
The key's randomart image is:
+---[RSA 3072]----+
|        .=O      |
|        .X.o .   |
|        ..X.o .  |
|         *.=o.   |
|        S.oo.o   |
|       . o*o*.   |
|        .+*@E .  |
|        .+o*+o   |
|         o*o.    |
+----[SHA256]-----+
```

<!--more-->

Si hacemos ahora un listado de los ficheros del directorio `~/.ssh`, aparecerán los ficheros:

```sh
usuario@cliente:~$ ls -l ~/.ssh/

usuario1@nodo1:~$ ls -al .ssh
total 16
drwx------ 2 usuario1 usuario1 4096 Jan 24 16:04 .
drwxr-xr-x 3 usuario1 usuario1 4096 Jan 24 16:02 ..
-rw------- 1 usuario1 usuario1 2655 Jan 24 16:04 id_rsa
-rw-r--r-- 1 usuario1 usuario1  568 Jan 24 16:04 id_rsa.pub
...
```

* `id_rsa` es la clave privada del usuario adecuadamente protegida (permisos 0600). No la pierdas, esta clave te identifica. ¡Guárdala bien!.
 * `id_rsa.pub` es la clave pública del usuario.

## Configuración del servidor

Para que con nuestra clave privada podamos autentificarnos al conectarnos con ssh con el servidor, tenemos que copiar nuestra clave pública en el servidor. Copiaremos el contenido de la clave pública en el fichero `~/.ssh/authorized_keys` del usuario del servidor con el que vamos a realizar la conexión.

Para realizar esta copia vamos a usar la instrucción `ssh-copy-id` desde el cliente, indicando la clave pública que vamos a copiar:

```sh
usuario1@nodo1:~$ ssh-copy-id -i .ssh/id_rsa.pub usuario2@10.0.0.11
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: ".ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
usuario2@10.0.0.11's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'usuario2@10.0.0.11'"
and check to make sure that only the key(s) you wanted were added.
```

Ahora podemos comprobar en el servidor que en el home del `usuario2` se ha creado un fichero `.ssh/authorized_keys` con el contenido de la clave pública del `usuario1` del cliente:

```sh
usuario2@nodo2:~$ ls -al .ssh
total 12
drwx------ 2 usuario2 usuario2 4096 Jan 24 16:26 .
drwxr-xr-x 3 usuario2 usuario2 4096 Jan 24 16:26 ..
-rw------- 1 usuario2 usuario2  568 Jan 24 16:26 authorized_keys

usuario2@nodo2:~$ cat .ssh/authorized_keys 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9WwLHgn7oJxGOyc7zCfEg+FFF/mL0pSkGsLHHb6wC+hvV4BDGBTfNrXEnDQvlLt+FmZ9Fv4fvFgfILbg2+ZEyMIuDDz1zcK8kJp5hcUQPksfAdVJGDLAdoj77qkKeb6uEZ6765aXYHh9sEY6A1hqsXitS9S007AvdYpZdd6Q4/5gwGNUlUw28fqDEoY1IjsC177yxvKXzgoL49Fl4ozf5bb6u9skugVpmzlfS3/ZRELtgCNgyxRnG3lP5Iu7NP8h9o58Eba/EHOtCUKV08UyfvDTFgPqoKiR0HntKAvqMTBsf/ZFbp99XSAkP+qli3KSBhQKIyMeqoha+n75NVY1/DTeW1uirfEVuUaQ/rBDBexib4kzj66c16AqqPIaFzV8z+UB5nZSA13I0XnkJkn/7pWcN9+4/gazH7kdGtqA0DSx7gOxw4ZrVMARK8i5QWKSeAJbfFdgHe4LEZiQ7KU/jYWltbXxNa+Xga5kpy1/UGlPvcE7k1KfGeqpqOvpju+0= usuario1@nodo1
```

**Nota:** Podríamos copiar el contenido de la clave pública del cliente al servidor de forma manual, sin utilizar el comando `ssh-copy-id`. simplemnte tendríamos que copiar en el portapapeles el contenidod el fichero `id_rsa.pub` en el cliente y pegarlo en el fichero `.ssh/authorized_keys` del servidor.

## Accediendo por ssh sin contraseña

Ahora desde el cliente podremos acceder desde el `usario1` (utilizando su clave privada) al `usuario2` del servidor sin necesidad de introducir la contraseña de ese usuario, sin embargo como estamos usando la clave privada se nos pedirá la frase de paso:

```
usuario1@nodo1:~$ ssh usuario2@10.0.0.11
Enter passphrase for key '/home/usuario1/.ssh/id_rsa': 
Linux nodo2 5.10.0-20-amd64 #1 SMP Debian 5.10.158-2 (2022-12-13) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Jan 24 16:26:04 2023 from 10.0.0.10
usuario2@nodo2:~$ 
```

### Accediendo por ssh sin contraseña desde Gnome

Si la conexión la hacemos desde una terminal de Gnome, la primera vez aparecerá una ventana donde se nos pedirá la frase de paso, al introducirla se guardará en una aplicación llamada **GNOME Keyring**, que es un almacén de claves y en las próximas conexiones que hagamos en la sesión que tenemos abierta no se nos volverá a pedir la frase de paso.

![ssh en gnome]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/01/ssh_gnome.png){: .align-center }

### Accediendo por ssh sin contraseña desde Gnome y ssh-agent

Si la conexión la hacemos desde una máquina en la que no tenemos un entorno gráfico instalado, como vimos anteriormente, cada vez que hagamos una conexión (usemos nuestra clave privada) se nos pedirá la frase de paso.

**ssh-agent** en un programa que almacena las claves privadas y las utiliza en cada sesión ssh que establezcamos en la sesión actual, lo ejecutamos y añadimos nuestra clave privada:

```sh
suario1@nodo1:~$ ssh-agent /bin/bash
usuario1@nodo1:~$ ssh-add .ssh/id_rsa
Enter passphrase for .ssh/id_rsa: 
Identity added: .ssh/id_rsa (usuario1@nodo1)
```

Una vez que hemos añadido nuestra clave privada, en las próximas conexiones dentro de esta sesión, no se nos volverá a pedir la frase de paso:

```sh
usuario1@nodo1:~$ ssh usuario2@10.0.0.11
Linux nodo2 5.10.0-20-amd64 #1 SMP Debian 5.10.158-2 (2022-12-13) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Jan 24 16:30:50 2023 from 10.0.0.10
usuario2@nodo2:~$
```

## Conclusiones

Espero que con esta entrada haya quedado claro la configuración del servidor ssh para el acceso por ssh sin contraseña, usando claves criptográficas ssh. Si en nuestro trabajo tenemos que conectar de forma remota con servidores de forma continuada, es la forma más sencilla de realizarlo. Además, aunque la autentificación con contraseña es sencilla y segura, no es válida para procesos no interactivos o para usuarios sin contraseña, es decir, siempre es necesario que haya una persona esperando la solicitud de la contraseña para escribirla y es imprescindible que el usuario del equipo remoto tenga definida una contraseña, cosa que no ocurre siempre sobre todo con usuarios vinculados a servicios o similares.
