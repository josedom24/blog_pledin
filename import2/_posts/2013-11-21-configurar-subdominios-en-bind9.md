---
layout: post
status: publish
published: true
title: Configurar subdominios en bind9
author:
  display_name: admin
  login: admin
  email: josedom24@gmail.com
  url: ''
author_login: admin
author_email: josedom24@gmail.com
wordpress_id: 864
wordpress_url: http://www.josedomingo.org/pledin/?p=864
date: '2013-11-21 17:24:45 +0000'
date_gmt: '2013-11-21 16:24:45 +0000'
categories:
- General
tags:
- Redes Sociales
- Manuales
- dns
comments: []
---
<p style="text-align: justify;">El objetivo de este art&iacute;culo es estudiar las distintas formas que tenemos en el servidor dns bind9 para gestionar la creaci&oacute;n de un subdominio de nuestro dominio principal.</p>
<p style="text-align: justify;">Por ejemplo, tenemos el dominio example.org y queremos crear un subdomio es.example.org, por lo que podr&iacute;amos tener los siguientes nombres:</p>
<ul>
<li>Nombre de dominio principal: <strong>example.org</strong></li>
<li>Nombre de un host en el dominio principal: <strong>www.example.org</strong></li>
<li>Nombre del subdominio: <strong>es.example.org</strong></li>
<li>Nombre de un host en el subdominio:<strong> www.es.example.org</strong></li>
</ul>
<p>Para conseguir configurar subdominios tenemos dos alternativas:</p>
<ol>
<li style="text-align: justify;"><strong>Crear un subdominio virtual</strong>, en este caso es un s&oacute;lo servidor DNS el que va a tener autoridad sobre el dominio y sobre el subdomio.</li>
<li style="text-align: justify;"><strong>Delegar el subdomio</strong>, es decir el servidor DNS autorizado para el dominio va a delegar la gesti&oacute;n y autorizaci&oacute;n del subdominio a otro servidor DNS.</li>
</ol>
<p><!--more--></p>
<h1>Crear un subdominio virtual</h1>
<p style="text-align: justify;">En este caso suponemos de tenemos configurado un servidor DNS donde hemos configurado la zona example.org en el fichero /var/cache/bind/db.example.org. La configuraci&oacute;n del subdominio virtual se ha indicado en negrita, y quedar&iacute;a de la siguiente manera:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$TTL    86400
@       IN      SOA     ns1 mail (
                              4         
                         604800         
                          86400         
                        2419200       
                          86400 )       

                NS      ns1
ns1     IN      A       10.0.10.2
www     IN      A       10.0.10.1

<strong>$ORIGIN es.example.org.</strong>
<strong>www     IN      A      10.10.0.3</strong></pre>
<p style="text-align: justify;">Despu&eacute;s de reiniciar el servidor podemos hacer una consulta con la utilidad dig, de la siguiente manera:</p>
<pre class="brush: bash; gutter: false; first-line: 1"># dig @10.0.10.2 www.es.example.org

; <<>> DiG 9.8.4-rpz2+rl005.12-P1 <<>> @10.0.10.2 www.es.example.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 61235
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 1

;; QUESTION SECTION:
;www.es.example.org.		IN	A

;; ANSWER SECTION:
www.es.example.org.	86400	IN	A	10.10.0.3

;; AUTHORITY SECTION:
example.org.		86400	IN	NS	ns1.example.org.

;; ADDITIONAL SECTION:
ns1.example.org.	86400	IN	A	10.0.10.2

;; Query time: 0 msec
;; SERVER: 10.0.10.2#53(10.0.10.2)
;; WHEN: Thu Nov 21 15:27:26 2013
;; MSG SIZE  rcvd: 86</pre>
<p style="text-align: justify;">Donde podemos observar que la resoluci&oacute;n se hace correctamente, y como se&ntilde;alamos anteriormente el servidor con autoridad (registro NS) es el servidor ns1.example.org que, en realidad, es el servidor con autoridad del dominio example.org.</p>
<h1 style="text-align: justify;">Delegaci&oacute;n de subdominios</h1>
<p style="text-align: justify;">En esta ocasi&oacute;n partimos de un servidor DNS con autoridad sobre el dominio <strong>example.org</strong> (<strong>ns1.example.org</strong>), que va a delegar la gesti&oacute;n del subdominio <strong>es.example.org</strong> a otro servidor DNS (<strong>nssub.es.example.org</strong>). Veamos la configuraci&oacute;n de los servidores:</p>
<h3 style="text-align: justify;">Configuraci&oacute;n del servidor DNS del dominio principal (example.org)</h3>
<p style="text-align: justify;">La zona est&aacute; definida en el fichero /var/cache/bind/db.example.org, donde tendremos que indicar cual es el servidor DNS con autoridad para el subdominio, es decir indicaremos el servidor DNS al que vamos a delegar la gesti&oacute;n del subdominio <strong>es.example.org</strong>, que en nuestro caso ser&aacute; <strong>nssub.es.example.org</strong>. Indicamos en negrita la configuraci&oacute;n necesaria:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$TTL    86400
@       IN      SOA     ns1 mail (
                              4         
                         604800    
                          86400     
                        2419200   
                          86400 )   

                NS      ns1

ns1     IN      A       10.0.10.2
www     IN      A       10.0.10.1

<strong>$ORIGIN es.example.org.</strong>
<strong>@       IN      NS      nssub</strong>
<strong>nssub   IN      A       10.0.10.6</strong></pre>
<p style="text-align: justify;">Como podemos observar el servidor DNS con autoridad sobre la zona <strong>es.example.org</strong>, ser&aacute; <strong>nssub.es.example.org</strong> que se encuentra en la direcci&oacute;n <strong>10.0.10.6</strong>.</p>
<h3>Configuraci&oacute;n del servidor DNS del subdominio (es.example.org)</h3>
<p style="text-align: justify;">Ahora configuramos el segundo servidor DNS (<strong>nssub.es.example.org</strong>), al que vamos a delegar la gesti&oacute;n del dominio<strong> es.example.org.</strong> Lo primero que tenemos que hacer es definir la zona que corresponde con el subdominio en el fichero /etc/bind/named.conf.local:</p>
<pre class="brush: bash; gutter: false; first-line: 1">zone "es.example.org" {
  type master;
  file "db.es.example.org";
};</pre>
<p style="text-align: justify;">Y el fichero /var/cache/bind/db.es.example.org, quedar&iacute;a:</p>
<pre class="brush: bash; gutter: false; first-line: 1">$TTL    86400
@       IN      SOA     nssub mail (
                              4         
                         604800    
                          86400     
                        2419200   
                          86400 )   

                  NS      nssub
nssub     IN      A       10.0.10.6
www       IN      A       10.0.10.3</pre>
<p style="text-align: justify;">Ya estamos en disposici&oacute;n de consultar nombres de nuestro subdominio:</p>
<pre class="brush: bash; gutter: false; first-line: 1"># dig @10.0.10.2 www.es.example.org

; <<>> DiG 9.8.4-rpz2+rl005.12-P1 <<>> @10.0.10.2 www.es.example.org
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16747
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 0

;; QUESTION SECTION:
;www.es.example.org.		IN	A

;; ANSWER SECTION:
www.es.example.org.	86400	IN	A	10.0.10.3

;; AUTHORITY SECTION:
es.example.org.		86400	IN	NS	nssub.es.example.org.

;; Query time: 704 msec
;; SERVER: 10.0.10.2#53(10.0.10.2)
;; WHEN: Thu Nov 21 16:09:58 2013
;; MSG SIZE  rcvd: 72</pre>
<p style="text-align: justify;">Donde de nuevo comprobamos que la resoluci&oacute;n se hace de forma adecuada, pero en esta ocasi&oacute;n la est&aacute; haciendo el servidor con autoridad sobre el subdominio, en este caso nssub.es.example.org.</p>
<hr />
<p><strong>Actualizaci&oacute;n (19/11/2015)</strong></p>
<p>Durante la realizaci&oacute;n de esta pr&aacute;ctica en este curso, hemos experimentado que siguiendo este manual, en la infraestructura que tenemos en nuestro instituto la delegaci&oacute;n de subdominios no funcionaba.</p>
<p>Por seguridad, en nuestro cortafuego tenemos configurado que el &uacute;nico servidor DNS que puede hacer consultas al exterior (puerto 25 UTP) es nuestro servidor DNS principal. Por lo tanto los servidores DNS que instalan los alumnos se tienen que configurar como<em> forwarders</em> (si tienen que resolver una consulta de una zona de la que no tienen autoridad preguntan al servidor DNS principal del instituto), para ello en el fichero <strong>/etc/bind/named.conf.options</strong>, descomentamos y configuramos de forma adecuada la secci&oacute;n de <strong>forwarders</strong>.</p>
<p>Con esta configuraci&oacute;n cuando consultamos un nombre de subdominio, nuestro servidor DNS detecta que no tiene autoridad sobre &eacute;l, y pregunta al servidor DNS que hemos indicado en el forwarders, no hace la delegaci&oacute;n.</p>
<p>Para solucionar este problema tendr&iacute;amos que anular la funci&oacute;n de forwarders para la zona example.org, para ello en el fichero <strong>/etc/bind/named.conf.local</strong>, donde definimos las zonas DNS, configuramos el siguiente par&aacute;metro:</p>
<pre>zone "example.org" {
&nbsp;&nbsp;&nbsp; type master;
&nbsp;&nbsp;&nbsp; file "db.example.org";
&nbsp;&nbsp;&nbsp; <strong>forwarders { };</strong>
};</pre>
<p>&nbsp;</p>
