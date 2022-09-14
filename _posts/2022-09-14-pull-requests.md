---
title: '¿Cómo colaborar en un proyecto de software libre? ¿Qué es un Pull Request?'
permalink: /2022/09/que-es-pull-requests/
tags:
  - GitHub
---

![Pull Requests]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/09/pr.jpg){: .align-center }

Una de las acciones más usadas cuando trabajamos con repositorios en GitHub es la realización de **Pull Requests**. Podemos definir un Pull Request como la acción de validar un código que se va a fusionar de una rama a otra. 

Cuando trabajamos con nuestros repositorios está acción no tiene mucho sentido. Empieza a tener sentido cuando tenemos un grupo de trabajo y necesitamos validar de alguna forma la propuesta de cambio hecho sobre el repositorio por otro usuario.

Por lo tanto, los Pull Requests se han convertido en la forma más habitual de colaborar en proyecto de software libre, ya que cualquiera de nosotros tiene la posibilidad de realizar una petición de cambio al propietario de cualquier repositorio. Será dicho propietario el que validará nuestra propuesta y decidirá si es apta, fusionándola con el contenido de la rama principal del repositorio o simplemente si no acepta el cambio rechazará la petición.

Veamos los pasos principales que tenemos que dar para la realización de un Pull Reuests:

## Pasos para la realización de un Pull Requets

Queremos hacer una propuesta de cambio a un repositorio del que no somos propietario. Vamos a trabajar con un usuario que no es propietario del repositorio: [https://github.com/josedom24/blog_pledin/](https://github.com/josedom24/blog_pledin/). Este repositorio es donde está alojado este blog, por lo tanto el usuario podría crear un Pull Request para solicitar un cambio en el blog. veamos los pasos:

1. El usuario tiene que hacer un **fork** del repositorio al que quiere contribuir. Un fork es una copia completa de un determinado repsoitorio a nuestra cuenta de GitHub. Para ello accedemos al repositorio y pulsamos sobre el botón **Fork**:

![Pull Requests]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/09/pr1.png){: .align-center }

	Y crearemos un nuevo fork:

![Pull Requests]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/09/pr2.png){: .align-center }

	Qué creará un nuevo repositorio en la cuenta de nuestro usuario:

![Pull Requests]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/09/pr3.png){: .align-center }

2. Una vez que hemos copia el repositorio a nuestra cuenta, podemos **clonar** ese repositorio. En nuestro caso hemos configurado el acceso SSH a GitHub y por lo tanto podemos usar la URL de acceso por SSH:

![Pull Requests]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/09/pr4.png){: .align-center }	

	Para realizar la clonación ejecutamos:

	```
	$ git clone git@github.com:pledin-staticman/blog_pledin.git
	```

3. A continuación vamos a crear una nueva rama, donde realizaremos los cambios que posteriormente propondremos como cambios. Para crear la rama ejecutamos:

	```
	~/blog_pledin$ git checkout -b cambios
	Switched to a new branch 'cambios'
	```

	Modificamos el contenido que deseemos y realizamos el commit:

	```
	~/blog_pledin$ commit -am "Cambios realizados" 
	[cambios af3bf5c] Cambios realizados
	 1 file changed, 1 insertion(+), 1 deletion(-)
	
	```

	Por último tenemos que subir los cambios a nuestro repositorio, creando una rama en el repositorio remoto. Normalmente el nombre del repositorio remoto es **origin**, pero podemos ejecutar la siguiente instrucción para estar seguros:

	```
	~/blog_pledin$ git remote
	origin
	```

	Y subimos los cambios:

	```
	~/blog_pledin$ git push origin cambios
	Enumerating objects: 5, done.
	Counting objects: 100% (5/5), done.
	Compressing objects: 100% (3/3), done.
	Writing objects: 100% (3/3), 304 bytes | 304.00 KiB/s, done.
	Total 3 (delta 2), reused 0 (delta 0), pack-reused 0
	remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
	remote: 
	remote: Create a pull request for 'cambios' on GitHub by visiting:
	remote:      https://github.com/pledin-staticman/blog_pledin/pull/new/cambios
	remote: 
	To github.com:pledin-staticman/blog_pledin.git
	 * [new branch]      cambios -> cambios
	```

4. Por último tenemos que crear el Pull Requests desde la página de GitHub. Comprobamos que nos aparece un cuadro que nos dice que hemos hecho cambios en una nueva rama y podemos crear un nuevo Pull Requests para proponer dichos cambios, para ello pulsamos el botón **Caompare & pull request**:

![Pull Requests]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/09/pr5.png){: .align-center }	

	A continuación nos aparece un foirmulario donde podemos escribir un comentario al propietario del repositorio al que estamos propniendo el cambio para explicar el Pull Reuests sugerido. Y finalmente pulsamos el botón **Create pull request** para crearlo.

![Pull Requests]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/09/pr6.png){: .align-center }	

5. Ya hemos explicado en los cuatros pasos anteriores cómo se realiza un Pull Requets, sin embargo es importante tener en cunta los siguiente: al hacer el fork del repositorio original hacemos una copia completa en un determinado momento, pero ese repositorio puede ir cambiando y sin embargo esos cambios no se verán reflejados en nuestro fork. Nos tenemos que asegurar antes de proponer un cambio (hacer un Pull Request), tener nuestro fork lo más actualizado posible para que no tengamos problemas introduciendo numerosos conflictos. Para ello vamos a realizar los siguientes pasos:

	Nos aseguremos de posicionarnos en la rama principal de nuestro fork (en este ejemplo se llama `master`, aunque actualmente se llama `main`):

	```
	~/blog_pledin$ git checkout master
	Switched to branch 'master'
	Your branch is up to date with 'origin/master'.
	```

	Añadimos un nuevo repositorio remoto a nuestro repositorio local que será el repositorio original que hemos copiado. A este nuevo repositorio lo vamos a llamar **upstream** (evidentemente al añadir el repositorio original usamos la URL https ya que no somos propietario del mismo):

	```
	~/blog_pledin$ git remote add upstream https://github.com/josedom24/blog-pledin.git
	```

	Ahora tendremos dos repositorios remotos asociados al repositorio local:

	```
	~/blog_pledin$ git remote -v
	origin	git@github.com:pledin-staticman/blog_pledin.git (fetch)
	origin	git@github.com:pledin-staticman/blog_pledin.git (push)
	upstream	https://github.com/josedom24/blog-pledin.git (fetch)
	upstream	https://github.com/josedom24/blog-pledin.git (push)
	```

		
	
