---
id: 583
title: Introducción a Ruby on Rails con Debian Squeeze
date: 2012-01-07T20:29:40+00:00


guid: http://www.josedomingo.org/pledin/?p=583
permalink: /2012/01/introduccion-a-ruby-on-rails-con-debian-squeeze/


tags:
  - Ruby on Rails
  - Web 2.0
---
**<img class="alignnone" title="ror" src="http://rubyonrails.org/images/rails.png" alt="" width="87" height="111" />**

**Ruby on Rails**, también conocido como **RoR** o **Rails** es un [framework](http://es.wikipedia.org/wiki/Framework "Framework") de [aplicaciones web](http://es.wikipedia.org/wiki/Aplicaci%C3%B3n_web "Aplicación web") de [código abierto](http://es.wikipedia.org/wiki/C%C3%B3digo_abierto "Código abierto") escrito en el lenguaje de programación [Ruby](http://es.wikipedia.org/wiki/Ruby "Ruby"), siguiendo el paradigma de la arquitectura [Modelo Vista Controlador](http://es.wikipedia.org/wiki/Modelo_Vista_Controlador "Modelo Vista Controlador") (MVC). Trata de combinar la simplicidad con la posibilidad de desarrollar aplicaciones del mundo real escribiendo menos código que con otros frameworks y con un mínimo de configuración. El lenguaje de programación Ruby permite la [metaprogramación](http://es.wikipedia.org/wiki/Metaprogramaci%C3%B3n "Metaprogramación"), de la cual Rails hace uso, lo que resulta en una sintaxis que muchos de sus usuarios encuentran muy legible. Rails se distribuye a través de [RubyGems](http://es.wikipedia.org/wiki/RubyGems "RubyGems"), que es el formato oficial de paquete y canal de distribución de bibliotecas y aplicaciones Ruby.

Podemos indicar que los diferentes elementos del sistema son los siguientes:

  * Ruby, el intérprete del lenguaje de programación
  * RubyGems, el gestor de paquetes de Ruby
  * Ruby on Rails, el framework para desarrollo de aplicaciones web en Ruby

<!--more-->

**Instalación**

  1. Instalación de ruby: **aptitude install ruby**
  2. Instalación de rybygems: **aptitude install rubygems**
  * Para actualizar la versión de ruby:  **gem update &#8211;system**
  * Para ver los módulos (gemas) instalados: **gem list**
  * Para instalar un módulos: **gem install _módulo_**

  3. Instalación de Rails: **aptitude install rails **
  4. Si vamos a usar mysql debemos instalar el driver mysql para RoR:
  
    **aptitude install mysql-server**
  
    **aptitude install libmysqlclient-dev**
  
    **gem install mysql**

**Mi primera aplicación**

Vamos a construir una aplicación que me permita insertar, modificar, listar y borrar los datos de una tabla. Una aplicación con estas características implementada en una lenguaje de programación Web tradicional,  por ejemplo PHP, conlleva la escritura de mucho código, además si utilizamos una base de datos MySQL nuestro código sólo será válido para este gestor de base de datos y tendremos que conocer el lenguaje SQL compatible con él. Veremos que la construcción de esta aplicación con RoR es muy sencilla utilizando las herramientas que nos ofrece. Vamos a crear una aplicación que nos permita la gestión de una base de datos de películas.

**Creando un esqueleto**

Lo primero que tenemos es que construir los ficheros y directorios de una aplicación base, para ello:

<pre class="brush: bash; gutter: false; first-line: 1">mkdir Proyectos
cd Proyectos
rails videoclub</pre>

Nuestra aplicación se va a llamar videoclub. Una aplicación rails se encuentra en el subdirectorio app y se compone de los siguientes directorios:

apis &#8211; las librerías que su programa requiere fuera de Rails mismo.
  
controllers &#8211; Los controladores
  
helpers &#8211; Los helpers
  
models &#8211; Los modelos. Básicamente las clases que representan los datos que nuestra aplicación manipulará.
  
views &#8211; Las vistas, que son archivos rhtml (como JSP o ASP).
  
views/layouts &#8211; Los diseños. Cada controlador tiene su propio diseño, donde se pondrán las cabeceras y pies de página.
  
config &#8211; Archivos de configuración. La configuración de la base de datos se encuentra aquí.
  
script &#8211; Utilerías para generar código y ejecutar el servidor.
  
public &#8211; La raíz del directorio virtual. Cualquier contenido que usted encuentre aquí será publicado en su aplicación directamente. En una nueva aplicación, usted puede encontrar las páginas web para los errores 404 y 500, las imágenes, javascripts, estilos, etcétera.
  
test &#8211; Los archivos para las pruebas funcionales y de unidad.

**Configuración de la base de datos**

El siguiente paso es configurar el acceso a nuestra base de datos, para ello modificamos el siguiente fichero:

<pre class="brush: bash; gutter: false; first-line: 1">cd videoclub
nano config/database.yml

Y lo configuramos de la siguiente manera:</pre>

<pre class="brush: bash; gutter: false; first-line: 1">development:
  adapter: mysql
  database: videoclub_dev
  host: localhost
  username: root
  password: password_del_root

test:
  adapter: mysql
  database: videoclub_test
  host: localhost
  username: root
  password: password_del_root

production:
  adapter: mysql
  database: videoclub_prod
  host: localhost
  username: root
  password: password_del_root</pre>

Si nos damos cuenta podemos ejecutar nuestra aplicación en tres entornos: desarrollo, test y producción, cada una de ellas tiene características distintas, y en cada uno de ellas podemos utilizar base de datos distintas. Por defecto estamos trabajando en el entorno de desarrollo.

Ahora podemos crear las bases de datos que necesitamos con la siguiente orden:

<pre class="brush: bash; gutter: false; first-line: 1">rake db:create:all</pre>

**Probando nuestra aplicación**

RoR posee un servidor web que es apropiado para hacer pruebas, para mostrar nuestra aplicación ejecutamos el servidor WEBrick:

<pre class="brush: bash; gutter: false; first-line: 1">ruby script/server</pre>

Con esta instrucción el servidor web es accesible sólo desde localhost, si queremos acceder desde otro cliente tenemos que indicarle la dirección IP dpnde se encuentra alojado, en este caso:

<pre class="brush: bash; gutter: false; first-line: 1">ruby script/server -b direccion_ip</pre>

Por defecto el servidor web funciona en el puerto 3000, de tal forma que podemos acceder a la página principal de nuestro proyecto:[<img class="aligncenter size-medium wp-image-588" title="Pantallazo" src="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/Pantallazo-300x210.png" alt="" width="300" height="210" srcset="{{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/Pantallazo-300x210.png 300w, {{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/Pantallazo.png 871w" sizes="(max-width: 300px) 100vw, 300px" />]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2012/01/Pantallazo.png)

**Creando un andamio**

Un andamio es una estructura que nos permite crear los recursos necesarios para gestionar una tabla en nuestra base de datos, vamos a crear un andamio (scafford) que nos permita gestionar una tabla de películas, con tres campos: título, descripción y URL de la carátula, para ello:

<pre class="brush: bash; gutter: false; first-line: 1">ruby script/generate scaffold Pelicula titulo:string descripcion:text url_caratula:string</pre>

De esta manera hemos creado un modelo de datos que podemos ver en el fichero creado en el directorio db/migrate, en mi caso:

<pre class="brush: bash; gutter: false; first-line: 1">nano db/migrate/20120107183925_create_peliculas.rb

class CreatePeliculas &lt; ActiveRecord::Migration
  def self.up
    create_table :peliculas do |t|
      t.string :titulo
      t.text :descripcion
      t.string :url_caratula

      t.timestamps
    end
  end

  def self.down
    drop_table :peliculas
  end
end</pre>

Y migramos nuestro modelo a nuestro gestor de base de datos, con lo que se creara la tabla películas, con la siguiente instrucción:

<pre class="brush: bash; gutter: false; first-line: 1">rake db:migrate</pre>

A continuación iniciamos nuestro servidor web y accedemos a la siguiente URL, y ya tenemos funcionando nuestra aplicación: http://dirección_servidor:3000/peliculas

Espero que os haya funcionado.

<!-- AddThis Advanced Settings generic via filter on the_content -->

<!-- AddThis Share Buttons generic via filter on the_content -->