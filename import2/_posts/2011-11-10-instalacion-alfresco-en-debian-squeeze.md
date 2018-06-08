---
layout: post
status: publish
published: true
title: Instalaci&oacute;n de Alfresco en Debian Squeeze
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 517
wordpress_url: http://www.josedomingo.org/pledin/?p=517
date: '2011-11-10 23:12:33 +0000'
date_gmt: '2011-11-10 22:12:33 +0000'
categories:
- General
tags:
- CMS
- Manuales
- Apache
- Alfresco
- Tomcat
comments:
- id: 153
  author: Luis Miguel Cabezas
  author_email: luismiguel.cabezas@gmail.com
  author_url: http://ninjaphp.wordpress.com
  date: '2012-01-18 12:40:04 +0000'
  date_gmt: '2012-01-18 11:40:04 +0000'
  content: "Buenas, genial el art&iacute;culo. Muy claro e intuitivo.\r\n\r\nSigo
    los pasos poco a poco y con cuidado, pero al iniciar tomcat alfresco con inicia.
    En cambio share si puedo verlo.\r\n\r\nViendo el log de Catalina creo que es un
    problema con el Conector de MySQL, pero no se muy bien como corregirlo. \r\n\r\n&iquest;Alguna
    idea?\r\n\r\nUn saludo."
- id: 154
  author: admin
  author_email: clasinfo@gmail.com
  author_url: ''
  date: '2012-01-19 16:11:54 +0000'
  date_gmt: '2012-01-19 15:11:54 +0000'
  content: "Hola,\r\n\r\nllevo algunos d&iacute;as buscando informaci&oacute;n y no
    se donde puede estar el fallo. Te sugiero que copies el conector directamente
    en /var/lib/tomcat6/webapps/alfresco/WEB-INF/lib y comprueba si funciona.\r\n\r\nEspero
    qhe sirva de algo.\r\n\r\nUn saludo y gracias por escribir."
---
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2011/11/alfresco1.jpg"><img class="aligncenter size-medium wp-image-518" title="alfresco1" src="http://www.josedomingo.org/pledin/wp-content/uploads/2011/11/alfresco1-300x86.jpg" alt="" width="300" height="86" /></a></p>
<p>Este art&iacute;culo est&aacute; basado en este <a href="http://widget.linkwithin.com/redirect?url=http%3A//yoadminsis.blogspot.com/2010/04/instalacion-alfresco-33-community-war_15.html&amp;vars=%5B%22http%3A//yoadminsis.blogspot.com/search/label/alfresco%22%2C%20290792%2C%201%2C%20%22http%3A//yoadminsis.blogspot.com/2010/04/03-instalacion-alfresco-33-community.html%22%2C%2044707827%2C%200%2C%2044707835%5D&amp;ts=1320959033698">otro</a>, y sobre todo en mi propia experiencia instalando Alfresco Comunity 4.0 en&nbsp; Debian Squeeze. La instalaci&oacute;n se ha realizado sobre una m&aacute;quina virtual con 3 gigabytes de memoria RAM. Empecemos...</p>
<p>Alfresco es un gestor de Documentaci&oacute;n profesional y Open Source. Tiene dos versiones. Una versi&oacute;n Enterprise (de pago y con servicio t&eacute;cnico, etc.) y Community (gratuita y sin garant&iacute;a). Para la instalaci&oacute;n de Alfresco 4.0 Community usaremos los ficheros WAR que sirven para desplegar aplicaciones en un servidor Tomcat ya existente. Necesitaremos hacer los siguientes pasos:</p>
<p><strong>Instalaci&oacute;n de Java</strong><br />
En mi caso voy a usar el Java de Oracle, recuerda que debes tener los repositorios non-free configurados:</p>
<pre class="brush: bash; gutter: false; first-line: 1">aptitude install sun-java6-bin sun-java6-jre sun-java6-jdk sun-java6-plugin sun-java6-fonts libcommons-el-java</pre>
<p>Cuando nos lo pida en la consola aceptamos la licencia. Si tuvi&eacute;ramos ya instalado otro java podr&iacute;amos hacer que se use por defecto el de Sun con:</p>
<pre class="brush: bash; gutter: false; first-line: 1">update-alternatives --set java /usr/lib/jvm/java-6-sun/jre/bin/java</pre>
<p><strong>Instalaci&oacute;n de MySQL</strong><br />
Instalamos el servidor mysql:</p>
<pre class="brush: bash; gutter: false; first-line: 1">aptitude install mysql-server-5.1 mysql-client-5.1 libmysql-java</pre>
<p>libmysql-java es el controlador JDBC de MySQL version 5.1.10. Lo configuramos en la instalaci&oacute;n de tomcat6.</p>
<p><strong>Instalamos el servidor de aplicaciones Tomcat 6.</strong></p>
<pre class="brush: bash; gutter: false; first-line: 1">aptitude install tomcat6 tomcat6-admin tomcat6-docs tomcat6-examples tomcat6-user</pre>
<p>Para manejar el gestor de aplicaciones y el gestor de hosts de tomcat desde el explorador web debemos a&ntilde;adir nuestro usuario a los roles manager y admin de tomcat. Para ello configuramos el fichero /etc/tomcat6/tomcat-user.xml y a&ntilde;adimos el usuario a la secci&oacute;n tomcat-users. Sustituimos usuario y contrase&ntilde;a por los nuestros.</p>
<pre class="brush: xml; gutter: false; first-line: 1"><tomcat-users>
<user username="usuario" password="contrase&ntilde;a" roles="admin,manager"/>
</tomcat-users></pre>
<p>Para configurar el conector AJP y que as&iacute; el servidor web Apache env&iacute;e las peticiones a Tomcat configuramos el siguiente fichero y descomentamos la linea del conector.</p>
<pre class="brush: bash; gutter: false; first-line: 1">nano /etc/tomcat6/server.xml

<!-- Define an AJP 1.3 Connector on port 8009 -->
<Connector port="8009" protocol="AJP/1.3" redirectPort="8443" /></pre>
<p>Creamos el directorio endorsed en /var/lib/tomcat6/common</p>
<pre class="brush: bash; gutter: false; first-line: 1">mkdir /var/lib/tomcat6/common/endorsed
chown -R tomcat6:tomcat6 /var/lib/tomcat6/common/endorsed</pre>
<p>Para que podamos usar alfresco correctamente debemos cambiar unos par&aacute;metros en el fichero /etc/default/tomcat6</p>
<p>Pra resolver el problema de "Out of Memory" que nos puede surgir con alfresco lo cambiamos dependiendo de la memoria que tengamos, se recomienda tener al menos 3G.</p>
<pre class="brush: bash; gutter: false; first-line: 1">JAVA_OPTS="-Djava.awt.headless=true  -Dfile.encoding=UTF-8 -server -Xms1536m -Xmx1536m -XX:NewSize=256m -XX:MaxNewSize=256m -XX:PermSize=256m -XX:MaxPermSize=256m -XX:+DisableExplicitGC  -Xmx3G  -Djava.endorsed.dirs=/usr/share/tomcat6/endorsed:/var/lib/tomcat6/common/endorsed"</pre>
<p>Habilitamos esta opci&oacute;n para que tomcat o sus aplicaciones puedan usar puertos por debajo de 1024 con usuarios no privilegiados (como tomcat6).</p>
<pre class="brush: bash; gutter: false; first-line: 1">AUTHBIND=yes</pre>
<p>Hemos terminado con ese fichero, por otro lado indicar que libmysql-java es el controlador JDBC de MySQL y libcommons-el-java son componentes reusables opensource de java. Esta instalaci&oacute;n instala los jar JDBC de mysql y commons en java pero para que funcione correctamente con tomcat debemos incluirlo en el classpath de tomcat. Esto lo hacemos a&ntilde;adiendo un link simb&oacute;lico al jar de mysql y commons en java en el directorio /usr/share/tomcat6/lib.</p>
<pre class="brush: bash; gutter: false; first-line: 1">cd /usr/share/tomcat6/lib
ln -s ../../java/mysql.jar mysql.jar
ln -s ../../java/commons-el.jar commons-el.jar</pre>
<p>En /usr/share/java tenemos un link simb&oacute;lico llamado mysql.jar que apunta al jdbc de mysql (mysql-connector-java-5.1.10.jar) en el mismo directorio. Por eso apuntamos mysql.jar en el directorio de tomcat a mysql.jar en el directorio de java. Un link a otro link.</p>
<p>Reiniciamos tomcat</p>
<pre class="brush: bash; gutter: false; first-line: 1">/etc/init.d/tomcat6 restart</pre>
<p>Y vemos que funciona en http://localhost:8080 y que podemos acceder al manager y al hostmanager con el usuario y contrase&ntilde;a que pusimos.</p>
<p><strong>Instalaci&oacute;n de Apache 2.2</strong></p>
<p>Instalamos el servidor web de apache. No es necesario en principio pero lo haremos para que sea apache el que se encargue de las peticiones web.</p>
<pre class="brush: applescript; gutter: false; first-line: 1">aptitude install apache2 apache2-utils</pre>
<p>No voy a entrar en la configuraci&oacute;n de apache, solo configuraremos el conector de apache a tomcat.</p>
<p>Para conectar el servidor web con el servidor de aplicaciones (contenedor de servlets y JSP) se usa el protocolo AJP. Para configurar esto se pueden usar, o el m&oacute;dulo de apache mod_jk o el m&oacute;dulo mod_proxy. La recomendaci&oacute;n es usar el m&oacute;dulo mod_proxy ya que es m&aacute;s moderno y es el que configuraremos. Tambi&eacute;n se puede usar para balanceo de carga, clusters... Por defecto, ya viene instalado con apache2.</p>
<p>En la instalaci&oacute;n de Tomcat ya configuramos el conector AJP para que funcionara correctamente. Ahora nos ocupamos de la parte de configuraci&oacute;n de apache. Para configurar el conector editamos el fichero de configuraci&oacute;n de mod proxy y lo dejamos as&iacute; (Cambia la direcci&oacute;n ip del servidor tomcat):</p>
<pre class="brush: bash; gutter: false; first-line: 1">nano /etc/apache2/mods-available/proxy.conf</pre>
<pre class="brush: bash; gutter: true; first-line: 1"><IfModule mod_proxy.c>
        #turning ProxyRequests on and allowing proxying from all may allow
        #spammers to use your proxy to send email.
        # Con esta directiva en Off hacemos que se deshabilite la redirecci&oacute;n del
        # proxy excepto para las entradas que nosotros pongamos con ProxyPass
        ProxyRequests Off

        # Hace que las peticiones originales de informaci&oacute;n de host se mantengan a
        # trav&eacute;s de la conexi&oacute;n del conector AJP. Es &uacute;til para aplicaciones que
        # necesitan mantener esta informaci&oacute;n.
        ProxyPreserveHost On

        # Indica que todos los hosts (*) pueden acceder a traves del proxy
        <Proxy *>
                AddDefaultCharset off
                Order deny,allow
                Allow from all
                #Allow from .example.com
        </Proxy>

        # Enable/disable the handling of HTTP/1.1 "Via:" headers.
        # ("Full" adds the server version; "Block" removes all outgoing Via: headers)
        # Set to one of: Off | On | Full | Block
        ProxyVia On

        # Indica que las peticiones a apache para /alfresco se pasen por el protocolo AJP
        # a la direcci&oacute;n IP y puerto donde Tomcat est&aacute; escuchando mediante el protocolo
        # AJP con un conector.
        ProxyPass /alfresco ajp://192.168.1.35:8009/alfresco

        # Indica que cualquier peticion de cabeceras (request headers) del reverse proxy
        # deber&iacute;a ser reescrita de forma adecuada para asegurar que las redirecciones que
        # haga el servidor Tomcat sean manejadas de forma correcta.
        ProxyPassReverse /alfresco ajp://192.168.1.35:8009/alfresco

        # Permitimos el acceso a la aplicaci&oacute;n alfresco
        <Location /alfresco >
                Order allow,deny
                Allow from all
        </Location>

        # Bloque para share.war. Con cada aplicaci&oacute;n desplegada que queramos incluir en
        # el conector deberemos poner el bloque siguiente.
        ProxyPass /share ajp://192.168.1.35:8009/share
        ProxyPassReverse /share ajp://192.168.1.35:8009/share
        <Location /share>
                Order allow,deny
                Allow from all
        </Location>

</IfModule></pre>
<p>Activamos los m&oacute;dulos proxy (se configuran en el mismo archivo anterior)</p>
<pre class="brush: applescript; gutter: false; first-line: 1">a2enmod proxy_balancer proxy_ajp proxy</pre>
<p>Y reiniciamos apache2.</p>
<p>En la siguiente imagen vemos como el conector, apache y tomcat est&aacute;n funcionando. No usamos directamente el puerto 8080 de tomcat si no el 80 de apache. El error de Alfresco es simplemente debido a que todav&iacute;a no lo hemos instalado en su sitio.</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2011/11/Pantallazo-Apache-Tomcat-6.0.28-Informe-de-Error-Google-Chrome.png"><img class="aligncenter size-medium wp-image-532" title="Pantallazo-Apache Tomcat-6.0.28 - Informe de Error - Google Chrome" src="http://www.josedomingo.org/pledin/wp-content/uploads/2011/11/Pantallazo-Apache-Tomcat-6.0.28-Informe-de-Error-Google-Chrome-300x157.png" alt="" width="300" height="157" /></a><strong>Instalaci&oacute;n de herramientas adicionales</strong></p>
<p>Para un correcto funcionamiento necesitamos instalar las siguientes herramientas.</p>
<ul>
<li>Flash 10.x.</li>
<li>SWF Tools: para la conversion de pdf y swf usar la vista previa de pdfs.</li>
<li>OpenOffice.org</li>
<li>Imagemagick: Para manipulaci&oacute;n de im&aacute;genes. Ya viene por defecto, pero por si acaso lo incluimos.</li>
</ul>
<p>Las herramientas que est&aacute;n en los repositorios de Debian las instalamos:</p>
<pre class="brush: bash; gutter: false; first-line: 1">aptitude install  flashplugin-nonfree openoffice.org imagemagick</pre>
<p>Sin embargo no existe en Debian un paquete para instalar SWF Tools, por lo tanto es necesario compilarlas, para ello:</p>
<p>Descargate la &uacute;ltima versi&oacute;n de la herramienta con:</p>
<pre class="brush: bash; gutter: false; first-line: 1">wget http://www.swftools.org/swftools-2011-10-10-1647.tar.gz</pre>
<p>Antes de compilarla instala algunas herramientas necesarias:</p>
<pre class="brush: bash; gutter: false; first-line: 1">apt-get install libjpeg62-dev libfreetype6-dev libpng3-dev libt1-dev libungif4-dev make build-essential</pre>
<p>Descomprimimos el fichero que hemos bajado y lo compilamos:</p>
<pre class="brush: bash; gutter: false; first-line: 1">./configure
make
make install</pre>
<p>Puedes probar que se ha instalado de manera adecuada ejecuntando:</p>
<pre class="brush: bash; gutter: false; first-line: 1">pdf2swf -V</pre>
<p>Por &uacute;ltimo crea el siguinete enlace s&iacute;mbolico para que se pueda localizar el programa:</p>
<pre class="brush: bash; gutter: false; first-line: 1">ln -s /usr/local/bin/pdf2swf /usr/bin/pdf2swf</pre>
<p><strong>Instalaci&oacute;n de Alfresco 4.0</strong></p>
<p>Alfresco se compone de varios elementos con distintas funcionalidades. Al instalar el archivo WAR es necesario instalar estos componentes por separado. Si us&aacute;ramos el paquete de instalaci&oacute;n, incluir&iacute;a tomcat, openoffice, etc. Pero nosotros queremos instalar el fichero war solo.</p>
<p>Nos bajaremos los ficheros desde http://wiki.alfresco.com/wiki/Community_file_list_4.0.b</p>
<p>En concreto yo me bajo los siguientes. Todos no son necesarios para una instalaci&oacute;n b&aacute;sica de alfresco y share.</p>
<p><em>alfresco-community-4.0.b.zip<br />
alfresco-community-webeditor-4.0.b.zip<br />
alfresco-community-deployment-4.0.b.zip</em></p>
<p>En principio, para la configuraci&oacute;n inicial usaremos el primero de la lista que contienen los WAR. Lo bajamos, descomprimimos y comprobamos que tenemos dos archivos WAR (en el directorio /web-server/webapps) que se auto desplegar&aacute;n en el servidor de aplicaciones y otros directorios y ficheros.</p>
<ul>
<li>Alfresco.war es la aplicaci&oacute;n core de gesti&oacute;n de la documentaci&oacute;n.</li>
<li>Share.war es la aplicaci&oacute;n de gesti&oacute;n de contenidos y documentaci&oacute;n.</li>
</ul>
<p>Una vez descomprimidos vamos a crear la base de datos en MySQL. Para ello debemos usar el script</p>
<pre class="brush: bash; gutter: false; first-line: 1">nano db_setup.sql
create database alfresco default character set utf8 collate utf8_bin;
grant all on alfresco.* to 'alfresco'@'localhost' identified by 'alfresco' with grant option;
grant all on alfresco.* to 'alfresco'@'localhost.localdomain' identified by 'alfresco' with grant option;</pre>
<p>Vemos que lo que hace es crear la base de datos para utf8 por defecto y los usuarios por defecto alfresco y contrase&ntilde;a alfresco. Lo dejamos as&iacute; por ahora y creamos la base de datos y comprobamos que existe. Si queremos podemos poner nuestra contrase&ntilde;a ahora y luego acordarnos de cambiarla en el fichero de propiedades (m&aacute;s adelante) Tambi&eacute;n comprobamos que existen los usuarios nuevos y recargamos las tablas de permisos.</p>
<pre class="brush: bash; gutter: false; first-line: 1">mysql -u root -p < db_setup.sql
mysql -u root -p -e "select user,host,password from user where user like 'alfresco'" mysql
mysqladmin -u root -p flush-privileges</pre>
<p>Creamos el directorio donde vamos a guardar el repositorio de alfresco que es donde se van a guardar los &iacute;ndices y los ficheros que subamos (documentos, etc.). Despu&eacute;s cambiamos los permisos para que tomcat pueda leer los datos.</p>
<pre class="brush: bash; gutter: false; first-line: 1">mkdir /srv/alfresco/alf_data
chown -R tomcat6:tomcat6 /srv/alfresco</pre>
<p>Copiamos todos los ficheros del directorio endorsed al directorio de tomcat, endorsed.</p>
<pre class="brush: bash; gutter: false; first-line: 1">cd web-server
cp endorsed/* /var/lib/tomcat6/common/endorsed/
chown -R tomcat6:tomcat6 /var/lib/tomcat6/common/endorsed</pre>
<p>Copiamos los ficheros .war al directorio de aplicaciones de tomcat donde se autodesplegar&aacute;n simplemente copi&aacute;ndolos en el directorio.</p>
<pre class="brush: bash; gutter: false; first-line: 1">cd webapps
cp alfresco.war share.war /var/lib/tomcat6/webapps/</pre>
<p><strong>Configuraci&oacute;n b&aacute;sica de Alfresco</strong></p>
<p>Una vez desplegados los war, Alfresco tiene dos directorios de configuraci&oacute;n, uno para el mismo y otro para share que son:</p>
<ul>
<li><configroot>: /var/lib/tomcat6/webapps/alfresco/WEB-INF</li>
<li><configrootshare>: /var/lib/tomcat6/webapps/share/WEB-INF</li>
</ul>
<p>Dentro de estos directorios se puede configurar alfresco o share.</p>
<p>El fichero general de configuraci&oacute;n de alfresco lo tenemos en /var/lib/tomcat6/webapps/alfresco/WEB-INF/classes/alfresco-global.properties.sample. Lo debemos copiar con el mismo nombre pero sin la extensi&oacute;n sample.</p>
<p>Y debe quedar de la siguiente manera:</p>
<pre class="brush: bash; gutter: true; first-line: 1">###############################
## Common Alfresco Properties #
###############################

#
# Sample custom content and index data location
#-------------
# Repositorio de documentaci&oacute;n de Alfresco que
# creamos antes.
dir.root=/srv/alfresco/alf_data

#
# Sample database connection properties
#-------------
# Datos de conexi&oacute;n de la base de datos. Si cambiamos
# la contrase&ntilde;a o el usuario al configurar mysql
# debemos cambiarlos aqu&iacute;.
db.name=alfresco
db.username=alfresco
db.password=alfresco
db.host=localhost
db.port=3306

#
# External locations
#-------------
# Rutas a los programas que necesita alfresco y que
# instalamos previamente. Podemos usar whereis.
ooo.exe=/usr/bin/soffice
#ooo.enabled=false
#img.root=./ImageMagick
img.exe=/usr/bin/convert
#swf.exe=/usr/bin/pdf2swf

#
# MySQL connection
#-------------
# Driver de mysql. Por defecto usa el dialecto
# hybernate de InnoDB asi que no ponemos nada m&aacute;s.
db.driver=org.gjt.mm.mysql.Driver
db.url=jdbc:mysql://${db.host}:${db.port}/${db.name}

#
# Index Recovery Mode
#-------------
index.recovery.mode=FULL

#
# Outbound Email Configuration
#-------------
mail.host=localhost
mail.port=25
#mail.username=anonymous
#mail.password=
mail.encoding=UTF-8
mail.from.default=admin@dominio.com
#mail.smtp.auth=false</pre>
<p><strong>&Uacute;ltimos pasos</strong></p>
<p>Vamos terminando. Tenemos que indicar en que fichero se van a guardar los log de alfresco. Para ello modificamos el fichero /var/lib/tomcat6/webapps/alfresco/WEB-INF/classes/log4j.properties y modificar la siguiente l&iacute;nea:</p>
<pre class="brush: bash; gutter: false; first-line: 1">log4j.appender.File.File=/var/log/tomcat6/alfresco.log</pre>
<p>Del mismo modo lo tendr&aacute;s que hacer en el fichero: /var/lib/tomcat6/webapps/share/WEB-INF/classes/log4j.properties</p>
<p>Si vamos ahora a http://localhost/alfresco veremos, por fin, la p&aacute;gina de alfresco funcionando.</p>
<p><a href="http://www.josedomingo.org/pledin/wp-content/uploads/2011/11/Pantallazo-Mi-Alfresco-Google-Chrome.png"><img class="aligncenter size-medium wp-image-535" title="Pantallazo-Mi Alfresco - Google Chrome" src="http://www.josedomingo.org/pledin/wp-content/uploads/2011/11/Pantallazo-Mi-Alfresco-Google-Chrome-300x240.png" alt="" width="300" height="240" /></a>Recomiendo que en los &uacute;ltimos pasos de la instalaci&oacute;n se vayan monitorizando los ficheros de logs: catalina.out y alfresco.log. Si surge alg&uacute;n error la mejor manera de solucionar es buscar en internet donde he encontrado mucha informaci&oacute;n sobre la instalaci&oacute;n de alfresco. Espero quele sirva a alguien.</p>
<p>Un saludo.</p>
