---
title: 'Despliegue en Heroku usando su CLI'
permalink: /2022/04/heroku-cli/
tags:
  - Heroku
  - Python
  - Flask
  - PaaS
---

![heroku]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/04/heroku.png){: .align-center }

[Heroku](https://www.heroku.com/) es una aplicación que nos ofrece un servicio de Cloud Computing PaaS (Plataforma como servicio). Ya hemos tratado esta herramienta en más ocasiones en Pledin: [Instalación de drupal en heroku](https://www.josedomingo.org/pledin/2015/11/instalacion-de-drupal-en-heroku/) y [Despliegue de una aplicación Python Bottle en Heroku (https://www.josedomingo.org/pledin/2017/04/despliegue-de-una-aplicacion-python-bottle-en-heroku/).

Desde hace una semana la integración de Heroku con GitHub está fallando. Al día de hoy no podemos conectar desde el dashboard de Heroku a nuestros repositorios de GitHub. El problema es que GitHub ha denegado la integración desde varias herramientas (entre ellas Heroku) porque han detectado el acceso a repositorios privados usando token OAuth ilegítimos, puedes encontrar más información en [So, what happened with GitHub, Heroku, and those raided private repos?](https://www.theregister.com/2022/04/21/github-stolen-oauth-tokens-used-in-breaches/).

En el módulo de *Lenguaje de Marcas* del ciclo de *Administración de Sistemas Informáticos* usamos Heroku para desplegar las aplicaciones web construidas por los alumnos y tradicionalmente hemos usado la integración con GitHub para facilitar el despliegue: [Despliegue de aplicación flask en un PaaS Heroku](https://fp.josedomingo.org/lmgs/u08/heroku.html).

Evidentemente este curso vamos a usar otro método para realizar el despliegue de las aplicaciones en Heroku: vamos  a usar el CLI de Heorku.

<!--more-->

## Instalación del CLI Heroku

La instrucción de línea de comando de Heroku lo podemos [instalar de distintas maneras](https://devcenter.heroku.com/articles/heroku-cli#install-the-heroku-cli). En este manual voy a instalarlo usando apt en mi Debian 11 Bullseye, para ello y siguiendo las instrucciones de la documentación, ejecutamos lo siguiente:

```
curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
```

Y comprobamos la versión instalada:

```
$ heroku --version
heroku/7.60.1 linux-x64 node-v14.19.0
```

Por último nos vamos a autentificar para usar el CLI con nuestra cuenta:

```
$ heroku login
heroku: Press any key to open up the browser to login or q to exit:
```

Y como se indica, pulsamos cualquier tecla para abrir un navegador web y autentificarnos:

![heroku]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/04/heroku1.png){: .align-center }

Volvemos al terminal y comprobamos que ya no es hemos logueado:

```
...
Logging in... done
Logged in as usuario@gmail.com
```

## Despliegue de aplicaciones con el CLI Heroku

Siguiendo el manual [Despliegue de aplicación flask en un PaaS Heroku](https://fp.josedomingo.org/lmgs/u08/heroku.html) hemos realizado los siguientes pasos:

1. Hemos modificado nuestra aplicación de forma adecuada para que lea el puerto que va a usar el servidor web desde una variable de entorno.
2. Hemos creado en el repositorio el fichero `requirements.txt` con la lista de dependencias de nuestra aplicación y el fichero `Procfile` donde indicamos el comando que se tiene que ejecutar para iniciar  el servidor web.
3. Hemos creado una aplicación desde el dashboard de Heroku. Mi aplicación se llama `prueba-jdmr`.

A continuación accedemos en el terminal al repositorio GitHub donde tenemos la aplicación que queremos desplegar y vamos añadirle otro repositorio remoto, para ello ejecutamos:

```
~/github/ejemplo_flask_heroku2$ heroku git:remote -a prueba-jdmr
set git remote heroku to https://git.heroku.com/prueba-jdmr.git
```

Si comprobamos el fichero de configuración de nuestro repositorio `.git/config` observamos que se ha añadido otro repositorio:

```
...
[remote "origin"]
	url = git@github.com:josedom24/ejemplo_flask_heroku2.git
	fetch = +refs/heads/*:refs/remotes/origin/*
...
[remote "heroku"]
	url = https://git.heroku.com/prueba-jdmr.git
	fetch = +refs/heads/*:refs/remotes/heroku/*
...
```

Es decir, nuestro repositorio local tiene asociado dos repositorios remotos:

* **origin**: Corresponde al repositorio guardado en GitHub.
* **heroku**: El repositorio del contenedor donde desplegamos nuestra aplicación en Heroku.

Por lo tanto si ejecutamos (estoy suponiendo que mi rama principal se llama `master`, en los repositorios nuevos se llama `main`):

```
git push heroku master
```

Estaremos sincronizando nuestro repositorio local con el repositorio del contenedor en Heroku y se despliega la aplicación.

Sin embargo si ejecuto:

```
git push origin master
```

Estaremos sincronizando nuestro repositorio local con el repositorio de GitHub.

## Prueba de funcionamiento

Vamos a desplegar nuestra aplicación, para ello, como hemos visto, ejecutamos:

```
~/github/ejemplo_flask_heroku2$ git push heroku master
Enumerando objetos: 37, listo.
Contando objetos: 100% (37/37), listo.
Compresión delta usando hasta 12 hilos
Comprimiendo objetos: 100% (32/32), listo.
Escribiendo objetos: 100% (37/37), 5.65 KiB | 5.65 MiB/s, listo.
Total 37 (delta 13), reusado 14 (delta 3), pack-reusado 0
remote: Compressing source files... done.
remote: Building source:
remote: 
remote: -----> Building on the Heroku-20 stack
remote: -----> Determining which buildpack to use for this app
remote: -----> Python app detected
remote: -----> No Python version was specified. Using the buildpack default: python-3.10.4
remote:        To use a different version, see: https://devcenter.heroku.com/articles/python-runtimes
remote: -----> Installing python-3.10.4
remote: -----> Installing pip 22.0.4, setuptools 60.10.0 and wheel 0.37.1
remote: -----> Installing SQLite3
remote: -----> Installing requirements with pip
remote:        Collecting certifi==2020.12.5
remote:          Downloading certifi-2020.12.5-py2.py3-none-any.whl (147 kB)
remote:        Collecting chardet==4.0.0
remote:          Downloading chardet-4.0.0-py2.py3-none-any.whl (178 kB)
remote:        Collecting click==7.1.2
remote:          Downloading click-7.1.2-py2.py3-none-any.whl (82 kB)
remote:        Collecting Flask==1.1.2
remote:          Downloading Flask-1.1.2-py2.py3-none-any.whl (94 kB)
remote:        Collecting idna==2.10
remote:          Downloading idna-2.10-py2.py3-none-any.whl (58 kB)
remote:        Collecting itsdangerous==1.1.0
remote:          Downloading itsdangerous-1.1.0-py2.py3-none-any.whl (16 kB)
remote:        Collecting Jinja2==2.11.3
remote:          Downloading Jinja2-2.11.3-py2.py3-none-any.whl (125 kB)
remote:        Collecting MarkupSafe==1.1.1
remote:          Downloading MarkupSafe-1.1.1.tar.gz (19 kB)
remote:          Preparing metadata (setup.py): started
remote:          Preparing metadata (setup.py): finished with status 'done'
remote:        Collecting requests==2.25.1
remote:          Downloading requests-2.25.1-py2.py3-none-any.whl (61 kB)
remote:        Collecting urllib3==1.26.5
remote:          Downloading urllib3-1.26.5-py2.py3-none-any.whl (138 kB)
remote:        Collecting Werkzeug==1.0.1
remote:          Downloading Werkzeug-1.0.1-py2.py3-none-any.whl (298 kB)
remote:        Building wheels for collected packages: MarkupSafe
remote:          Building wheel for MarkupSafe (setup.py): started
remote:          Building wheel for MarkupSafe (setup.py): finished with status 'done'
remote:          Created wheel for MarkupSafe: filename=MarkupSafe-1.1.1-cp310-cp310-linux_x86_64.whl size=34030 sha256=c0f447530976abf5add1322d62799feb4b172a2daaedc4963f406872e9fce9f6
remote:          Stored in directory: /tmp/pip-ephem-wheel-cache-_e2_1bk8/wheels/a6/81/81/3fcafa7c24e4b4e25bcf383c792b343e53c38e6196f44bc3e3
remote:        Successfully built MarkupSafe
remote:        Installing collected packages: certifi, Werkzeug, urllib3, MarkupSafe, itsdangerous, idna, click, chardet, requests, Jinja2, Flask
remote:        Successfully installed Flask-1.1.2 Jinja2-2.11.3 MarkupSafe-1.1.1 Werkzeug-1.0.1 certifi-2020.12.5 chardet-4.0.0 click-7.1.2 idna-2.10 itsdangerous-1.1.0 requests-2.25.1 urllib3-1.26.5
remote: -----> Discovering process types
remote:        Procfile declares types -> web
remote: 
remote: -----> Compressing...
remote:        Done: 62.6M
remote: -----> Launching...
remote:        Released v3
remote:        https://prueba-jdmr.herokuapp.com/ deployed to Heroku
remote: 
remote: Verifying deploy... done.
To https://git.heroku.com/prueba-jdmr.git
 * [new branch]      master -> master
```

Observamos las siguientes tareas que se han ejecutado:

1. Se ha sincronizado nuestro repositorio local al repsoitorio del contenedor de heroku.
2. Se ha instalado las dependencias en el contenedor a partir del fichero `requirements.txt`.
3. Se ha encontrado el fichero `Procfile` y se ha ejecutado el servidor web.
4. Nos informa que la aplicación se ha desplegado en `https://prueba-jdmr.herokuapp.com/`.

Podemos acceder a la aplicación para comporbar que funciona:

![heroku]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/04/heroku2.png){: .align-center }

Si queremos acceder a los logs de acceso de la aplicación, por ejmplo cuando tenemos algún error, ejecutamos:

```
heroku logs
```

Puedes encontrar todas las operaciones disponible en el CLI de Heroku en su [documentación oficial](https://devcenter.heroku.com/categories/command-line).

## Conclusiones

El día que expliqué el despliegue de aplicaciones web escritas en Python en Heroku nos contramos con el problema. Creaímos que era algo temporal, pero ha pasado una semana y parece que el problema persiste.

![heroku]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/04/heroku3.png){: .align-center }

Por todo esto, este año vamos a usar el despligue de aplicaciones en Heroku usando el CLI. 
