---
layout: post
status: publish
published: true
title: Introducci&oacute;n a Ruby on Rails con Debian Squeeze
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 583
wordpress_url: http://www.josedomingo.org/pledin/?p=583
date: '2012-01-07 20:29:40 +0000'
date_gmt: '2012-01-07 19:29:40 +0000'
categories:
- General
tags:
- Web 2.0
- Ruby on Rails
comments: []
---
<p><strong><img class="alignnone" title="ror" src="http://rubyonrails.org/images/rails.png" alt="" width="87" height="111" /></strong></p>
<p><strong>Ruby on Rails</strong>, tambi&eacute;n conocido como <strong>RoR</strong> o <strong>Rails</strong> es un <a title="Framework" href="http://es.wikipedia.org/wiki/Framework">framework</a> de <a title="Aplicaci&oacute;n web" href="http://es.wikipedia.org/wiki/Aplicaci%C3%B3n_web">aplicaciones web</a> de <a title="C&oacute;digo abierto" href="http://es.wikipedia.org/wiki/C%C3%B3digo_abierto">c&oacute;digo abierto</a> escrito en el lenguaje de programaci&oacute;n <a title="Ruby" href="http://es.wikipedia.org/wiki/Ruby">Ruby</a>, siguiendo el paradigma de la arquitectura <a title="Modelo Vista Controlador" href="http://es.wikipedia.org/wiki/Modelo_Vista_Controlador">Modelo Vista Controlador</a> (MVC). Trata de combinar la simplicidad con la posibilidad de desarrollar aplicaciones del mundo real escribiendo menos c&oacute;digo que con otros frameworks y con un m&iacute;nimo de configuraci&oacute;n. El lenguaje de programaci&oacute;n Ruby permite la <a title="Metaprogramaci&oacute;n" href="http://es.wikipedia.org/wiki/Metaprogramaci%C3%B3n">metaprogramaci&oacute;n</a>, de la cual Rails hace uso, lo que resulta en una sintaxis que muchos de sus usuarios encuentran muy legible. Rails se distribuye a trav&eacute;s de <a title="RubyGems" href="http://es.wikipedia.org/wiki/RubyGems">RubyGems</a>, que es el formato oficial de paquete y canal de distribuci&oacute;n de bibliotecas y aplicaciones Ruby.</p>
<p>Podemos indicar que los diferentes elementos del sistema son los siguientes:</p>
<ul>
<li>Ruby, el int&eacute;rprete del lenguaje de programaci&oacute;n</li>
<li>RubyGems, el gestor de paquetes de Ruby</li>
<li>Ruby on Rails, el framework para desarrollo de aplicaciones web en Ruby</li>
</ul>
<p><!--more--><strong>Instalaci&oacute;n</strong></p>
<ol>
<li>Instalaci&oacute;n de ruby: <strong>aptitude install ruby</strong></li>
<li>Instalaci&oacute;n de rybygems: <strong>aptitude install rubygems</strong></li>
<ul>
<li>Para actualizar la versi&oacute;n de ruby:&nbsp;<strong> gem&nbsp;update --system</strong></li>
<li>Para ver los m&oacute;dulos (gemas) instalados: <strong>gem list</strong></li>
<li>Para instalar un m&oacute;dulos:<strong> gem install <em>m&oacute;dulo</em></strong></li>
</ul>
<li>Instalaci&oacute;n de Rails: <strong>aptitude install rails&nbsp;</strong></li>
<li>Si vamos a usar mysql debemos instalar el driver mysql para RoR:<br />
<strong>aptitude install mysql-server</strong><br />
<strong>aptitude install libmysqlclient-dev</strong><br />
<strong>gem install mysql</strong></li>
</ol>
<p><strong>Mi primera aplicaci&oacute;n</strong></p>
<p>Vamos a construir una aplicaci&oacute;n que me permita insertar, modificar, listar y borrar los datos de una tabla. Una aplicaci&oacute;n con estas caracter&iacute;sticas implementada en una lenguaje de programaci&oacute;n Web tradicional,&nbsp; por ejemplo PHP, conlleva la escritura de mucho c&oacute;digo, adem&aacute;s si utilizamos una base de datos MySQL nuestro c&oacute;digo s&oacute;lo ser&aacute; v&aacute;lido para este gestor de base de datos y tendremos que conocer el lenguaje SQL compatible con &eacute;l. Veremos que la construcci&oacute;n de esta aplicaci&oacute;n con RoR es muy sencilla utilizando las herramientas que nos ofrece. Vamos a crear una aplicaci&oacute;n que nos permita la gesti&oacute;n de una base de datos de pel&iacute;culas.</p>
<p><strong>Creando un esqueleto</strong></p>
<p>Lo primero que tenemos es que construir los ficheros y directorios de una aplicaci&oacute;n base, para ello:</p>
<pre class="brush: bash; gutter: false; first-line: 1">mkdir Proyectos
cd Proyectos
rails videoclub</pre>
<p>Nuestra aplicaci&oacute;n se va a llamar videoclub. Una aplicaci&oacute;n rails se encuentra en el subdirectorio app y se compone de los siguientes directorios:</p>
<p>apis - las librer&iacute;as que su programa requiere fuera de Rails mismo.<br />
controllers - Los controladores<br />
helpers - Los helpers<br />
models - Los modelos. B&aacute;sicamente las clases que representan los datos que nuestra aplicaci&oacute;n manipular&aacute;.<br />
views - Las vistas, que son archivos rhtml (como JSP o ASP).<br />
views/layouts - Los dise&ntilde;os. Cada controlador tiene su propio dise&ntilde;o, donde se pondr&aacute;n las cabeceras y pies de p&aacute;gina.<br />
config - Archivos de configuraci&oacute;n. La configuraci&oacute;n de la base de datos se encuentra aqu&iacute;.<br />
script - Utiler&iacute;as para generar c&oacute;digo y ejecutar el servidor.<br />
public - La ra&iacute;z del directorio virtual. Cualquier contenido que usted encuentre aqu&iacute; ser&aacute; publicado en su aplicaci&oacute;n directamente. En una nueva aplicaci&oacute;n, usted puede encontrar las p&aacute;ginas web para los errores 404 y 500, las im&aacute;genes, javascripts, estilos, etc&eacute;tera.<br />
test - Los archivos para las pruebas funcionales y de unidad.</p>
<p><strong>Configuraci&oacute;n de la base de datos</strong></p>
<p>El siguiente paso es configurar el acceso a nuestra base de datos, para ello modificamos el siguiente fichero:</p>
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
<p>Si nos damos cuenta podemos ejecutar nuestra aplicaci&oacute;n en tres entornos: desarrollo, test y producci&oacute;n, cada una de ellas tiene caracter&iacute;sticas distintas, y en cada uno de ellas podemos utilizar base de datos distintas. Por defecto estamos trabajando en el entorno de desarrollo.</p>
<p>Ahora podemos crear las bases de datos que necesitamos con la siguiente orden:</p>
<pre class="brush: bash; gutter: false; first-line: 1">rake db:create:all</pre>
<p><strong>Probando nuestra aplicaci&oacute;n</strong></p>
<p>RoR posee un servidor web que es apropiado para hacer pruebas, para mostrar nuestra aplicaci&oacute;n ejecutamos el servidor WEBrick:</p>
<pre class="brush: bash; gutter: false; first-line: 1">ruby script/server</pre>
<p>Con esta instrucci&oacute;n el servidor web es accesible s&oacute;lo desde localhost, si queremos acceder desde otro cliente tenemos que indicarle la direcci&oacute;n IP dpnde se encuentra alojado, en este caso:</p>
<pre class="brush: bash; gutter: false; first-line: 1">ruby script/server -b direccion_ip</pre>
<p>Por defecto el servidor web funciona en el puerto 3000, de tal forma que podemos acceder a la p&aacute;gina principal de nuestro proyecto:<a href="http://www.josedomingo.org/pledin/wp-content/uploads/2012/01/Pantallazo.png"><img class="aligncenter size-medium wp-image-588" title="Pantallazo" src="http://www.josedomingo.org/pledin/wp-content/uploads/2012/01/Pantallazo-300x210.png" alt="" width="300" height="210" /></a></p>
<p><strong>Creando un andamio</strong></p>
<p>Un andamio es una estructura que nos permite crear los recursos necesarios para gestionar una tabla en nuestra base de datos, vamos a crear un andamio (scafford) que nos permita gestionar una tabla de pel&iacute;culas, con tres campos: t&iacute;tulo, descripci&oacute;n y URL de la car&aacute;tula, para ello:</p>
<pre class="brush: bash; gutter: false; first-line: 1">ruby script/generate scaffold Pelicula titulo:string descripcion:text url_caratula:string</pre>
<p>De esta manera hemos creado un modelo de datos que podemos ver en el fichero creado en el directorio db/migrate, en mi caso:</p>
<pre class="brush: bash; gutter: false; first-line: 1">nano db/migrate/20120107183925_create_peliculas.rb

class CreatePeliculas < ActiveRecord::Migration
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
<p>Y migramos nuestro modelo a nuestro gestor de base de datos, con lo que se creara la tabla pel&iacute;culas, con la siguiente instrucci&oacute;n:</p>
<pre class="brush: bash; gutter: false; first-line: 1">rake db:migrate</pre>
<p>A continuaci&oacute;n iniciamos nuestro servidor web y accedemos a la siguiente URL, y ya tenemos funcionando nuestra aplicaci&oacute;n: http://direcci&oacute;n_servidor:3000/peliculas</p>
<p>Espero que os haya funcionado.</p>
