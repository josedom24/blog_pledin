---
title: 'Configuración de SPF, DKIM y DMARC para asegurar el envío de correos'
permalink: /2024/02/spf-dkim-dmark/
tags:
  - email
  - Manuales
---

En el día de hoy, como ya anunciaron hace unas semanas, Google y Yahoo intensifican sus políticas de verificación de protocolos de autenticación para correos electrónicos, con el objetivo de luchar contra el spam.

De tal forma, que estas dos compañías (presumiblemente el resto se irán sumando a estas nuevas políticas), exigirán que todos los correos cumplan con los estándares SPF, DKIM y DMARC. **SPF** autoriza al servidor que envía tus correos, **DKIM** garantiza la integridad del mensaje y **DMARC** indica al receptor qué hacer si alguno de los anteriores no coincide (por ejemplo, rechazarlo o enviarlo a carpeta de spam).

En este artículo, voy a hacer una introducción de cada uno de estos protocolos y cómo loo podemos configurar para asegurar que los correos enviados por los servidores de correos que administramos *"lleguen a buen puerto"*.

## SPF

En principio, cualquier máquina tiene la capacidad de enviar mensajes de correo a cualquier destino utilizando cualquier remitente. Esto se diseñó originalmente para permitir el envío de mensajes con diferentes remitentes a través de un mismo servidor de correos. Sin embargo, esta característica del correo electrónico ha sido ampliamente explotada para inundar los servidores de correo con mensajes no deseados y llevar a cabo suplantación de remitentes (email spoofing).

Dada la masiva utilización indebida de esta funcionalidad, se ha generalizado la implementación de medidas complementarias con el fin de reducir al máximo este problema. En la actualidad, la mayoría de los servidores de correo adoptan medidas que implican el rechazo o la clasificación como spam de los mensajes provenientes de servidores que no implementan algún mecanismo adicional de autenticación.

**Sender Policy Framework (SPF)** es un mecanismo de autenticación que mediante un registro DNS de tipo TXT describe las direcciones IPs y nombres DNS autorizados a enviar correo desde un determinado dominio. Actualmente muchos servidores de correo exigen como mínimo tener un registro SPF para tu correo o en caso contrario los mensajes provenientes de tu servidor se clasifican como spam o se descartan directamente.

Ejemplo de registro SPF:

    DOMINIO.    600 IN  TXT "v=spf1 a mx ptr ip4:X.X.X.X/32 ip6:XXXX:XXXX:XXXX::XXXX:XXXX/128 a:nombre_máquina -all"

En definitiva es una lista de direcciones IP que autorizamos el envío del correo de nuestro dominio. Los parámetros significan los siguiente:

* **a**: Las direcciones IP declaradas  en cualquier registro A de la zona DNS del dominio.
* **mx**: IP de la máquina a la que apunta el registro MX del DNS del dominio.
* **ptr**: Las direcciones IP declaradas en los registros PTR de nuestra zona de resolución inversa.
* **ip4**:  Direcciones IPv4.
* **ip6**:  Direcciones IPv6.

Por ejemplo, si tenemos un dominio `example.org` y nuestro servidor de correo posee una dirección IP pública `203.0.113.1`, el registro DNS podría definirse de la siguiente manera:
```
dig txt example.org
...
example.org.	0	IN	TXT	"v=spf1 ip4:203.0.113.1  ~all"
```

Es importante comentar el signo que aparece antes de `all`, ya que podemos indicarle a los otros servidores lo que deben hacer si reciben correo desde otra dirección o máquina diferente a las que aparecen en el registro anterior:

* `-`: Descartar el mensaje.
* `~`: Clasificarlo como spam.
* `?`: Aceptar el mensaje (sería como no usar SPF).

De esta forma el correo que enviemos desde nuestra máquina, pasará los filtros SPF en destino y la mayoría de nuestros correos llegarán a destino con poca probabilidad de que se clasifiquen como spam. 

<!--more-->

## DKIM

**DomainKeys Identified Mail o DKIM** es un método de autenticación pensado principalmente para reducir la suplantación de remitente. DKIM consiste en que se publica a través de DNS la clave pública del servidor de correos y se firman con la correspondiente clave privada todos los mensajes emitidos, así el receptor puede verificar cada correo emitido utilizando la clave pública.

Veamos los pasos principales para configurar DKIM en nuestro servidor de correos. Vamos a usar `postfix` como MTA instalado sobre una distribución Linux Debian Bookworm. Suponemos, además, que nuestro dominio es `axample.org`:

Lo primero será instalar los paquetes necesarios:

```
apt install opendkim opendkim-tools
```

A continuación vamos a crear el par de claves, para ello ejecutamos la siguiente instrucción:

```
sudo -u opendkim opendkim-genkey -D /etc/dkimkeys -d example.org -s clave_example_org
```

Es decir, con el usuario `opendkim` se generan un par de claves que se guardan en el directorio `/etc/dkimkeys` (`-D`), del dominio `example.org` y le ponemos un nombre al selector, en nuestro caso `clave_example_org`. El selector es el nombre que se va a utilizar para identificar las claves.

En este caso en el directorio `/etc/dkimkeys` se han creado dos ficheros:

* `clave_example_org.private`: Donde se guarda la clave privada con lo que se va a firmar los correos.
* `clave_example_org.txt`: Donde se guarda la clave pública.

A continuación vamos a configurar opendkim, para ello en el fichero `/etc/opendkim.conf` descomentamos y ponemos los siguiente valores en los siguientes parámetros:

```
Domain                  example.org
KeyFile                 /etc/dkimkeys/clave_example_org.private
Selector                clave_example_org
Socket                  inet:8892@localhost
```

Indicamos nuestro dominio, el fichero donde está la clave privada, el selector que hemos utilizado al crear las calves y por último configuramos el opendkim para que escuche peticiones en el puerto 8892/tcp de localhost (para que postfix se conecte a él).

Para integra postfix con opendkim, añadimos al fichero `/etc/postfix/main.cf` las siguientes líneas:

```
smtpd_milters = inet:localhost:8892
non_smtpd_milters = $smtpd_milters
```

Por último reiniciamos los dos servicios:

```
systemctl restart opendkim
systemctl restart postfix
```

Por último tenemos que publicar nuestra clave pública en un registro TXT del DNS de nuestro dominio, para ello visualizamos el contenido de la clave pública:

```
cat clave_example_org.txt
clave_example_org._domainkey	IN	TXT	( "v=DKIM1; h=sha256; k=rsa; "
	  "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAx2PSS+Z1bCqnUGay+rbr/0jjdBjlQ5SRdzX237NGv6YaeK7DqVFfWBY83Nk6QWCLjxg9Qg588AqjjnlLLDmVNNNPRpzytpFnBdIge6P5kUyJI8VPqw+c6uaNJ2yfG6awfWZvgvDGmqjO6ZFQX+vDV2yR7N0uejJd+WPvSMVN9fYGdBFWWnX+JZ8VVb49Cn9L4tbsMqhiDLY/4L"
	  "/3pLsJMzLOAVuzUac8p0CGPL/nJOKhaXDGdxyehxZW/FbT7ZYx/fYzSvG9OdEVHcTBxQkvE3hYWv/dPc617dJrO6YrB0AeJxOWmPJgeMbYehZYELUIMOGgIHt7z6/eR6du+27mYQIDAQAB" )  ; ----- DKIM key clave_example_org for dominio.algo
```

Tenemos que crear un registro TXT en nuestro DNS con el nombre `clave_example_org._domainkey.example.org` con el contenido desde **v=DKIM1** hasta la última comilla, quitando las comillas y poniendo todo en una misma línea.

Por ejemplo, para el registro de `josedomingo.org` sería:

```
dig txt zoho._domainkey.josedomingo.org 
...
zoho._domainkey.josedomingo.org. 0 IN	TXT	"v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsqnyWSY6LW0jaEAPLqVuNJPFGYDuDfskpMSRzInjv8jW6zoUPnmP+rrL2vOzQbNYV5nJyvkj63LiTMwdPgggPFeEdID5czfkscu8pfBFkQF4zMs5KWB10u6dw8RLagvfAC9Lg9lNOM0f0DwI5ZP1mPu6NsV1LA00jcg39z7j/PwIDAQAB"
```

Verificamos que la configuración del registro de DKIM es correcta utilizando alguna [herramienta externa](https://mxtoolbox.com/dkim.aspx), que da los resultados de forma fácilmente interpretable:

![dkim]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/02/dkim.png){: .align-center }

## DMARC

**Domain-based Message Authentication, Reporting, and Conformance o DMARC** es el último mecanismo de autenticación que vamos a configurar, realmente lo hace DMARC es ampliar el funcionamiento de SPF y DKIM, mediante la publicación en DNS de la política del sitio, en el que decimos si usamos, SPF, DKIM o ambos,y que se debe hacer con nuestro correo si no cumple con los protocolos anteriores.

La configuración de DMARC para el correo saliente es sencilla, consiste en un registro DNS TXT en el que se especifica si se está usando SPF y/o DKIM y qué hacer con el correo que no cumpla con los mecanismos de autenticación que estén habilitados, como en este caso están ambos, creamos un registro como el siguiente:

    _dmarc.DOMINIO. 3600    IN  TXT "v=DMARC1; p=quarantine;adkim=r;aspf=r; rua=mailto:correo@DOMINIO"

Veamos algunos parámetros:

* **p**, se indica la política de correos. `p=quarantine` indica que los servidores de correo electrónico deben "poner en cuarentena" los correos electrónicos que no superan DKIM y SPF, considerándolos potencialmente spam. Otras configuraciones posibles para esto son `p=none`, que permite que los correos que suspenden sigan pasando, y `p=reject`, que ordena a los servidores de correo electrónico que bloqueen los correos que suspenden.
* **adkim**: Indica cómo son la comprobaciones DKM. `adkim=s` significa que las comprobaciones DKIM son "estrictas" (el dominio del from debe coincidir con tu dominio). Esto también se puede configurar como "relajado" (el dominio del from puede ser un subdominio de tu dominio) si se cambia por `adkim=r`.
* **aspf**: Lo mismo que el anterior pero para SPF.
* **rua**: Se utiliza para designar una o varias direcciones de correo electrónico a las que enviar los informes DMARC Aggregate Feedback. 

El único parámetro obligatorio es el **p**.

Por ejemplo, el registro DMARC de `josedomingo.org` es:

```
dig txt _dmarc.josedomingo.org
...
_dmarc.josedomingo.org. 0	IN	TXT	"v=DMARC1; p=quarantine; adkim=r; aspf=r;"
```

## Conclusiones

En conclusión, la implementación conjunta de SPF, DKIM y DMARC se presenta como una estrategia fundamental en la lucha contra el correo no deseado y la suplantación de identidad en el ámbito del correo electrónico. **Sender Policy Framework (SPF)** establece una política de autorización para los servidores de correo saliente, **DomainKeys Identified Mail (DKIM)** ofrece un mecanismo de firma digital para verificar la autenticidad del contenido del mensaje, y **Domain-based Message Authentication, Reporting, and Conformance (DMARC)** proporciona directrices claras sobre cómo deben manejarse los mensajes que no cumplen con las políticas de autenticación establecidas. La combinación de estas tres tecnologías fortalece la seguridad de los correos electrónicos, reduce la posibilidad de suplantación y contribuye a la construcción de un entorno de comunicación más confiable y protegido contra amenazas cibernéticas.


