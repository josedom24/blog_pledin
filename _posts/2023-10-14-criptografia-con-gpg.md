---
title: 'Introducción a la criptografía con gpg'
permalink: /2023/10/criptografia-con-gpg/
tags:
  - Criptografía
  - gpg
  - Manuales
---

![gpg]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/logo-gnupg-light-purple-bg.png){: .align-center }

La **Criptografía** (que viene de dos palabras "cripto" (**secreto**) y "grafía" (**escritura**)) nos permite el **cifrado** o **codificación** de mensajes con el fin de hacerlos ininteligibles. Puedes profundizar en este concepto en la [Wikipedia](https://es.wikipedia.org/wiki/Criptograf%C3%ADa).

Veamos algunos conceptos sobre criptografía:

![gpg]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia1.png){: .align-center }

* **Emisor**: Cualquier persona o sistema (navegadores web, servicios, routers,...) que quieren enviar un mensaje de forma segura.
* **Receptor**: Cualquier persona o sistema que quiere recibir un mensaje de forma segura.
* **Atacante**: Cualquier persona o sistema que trata de leer, eliminar, modificar,... el mensaje enviado por el emisor hacia el receptor.
* **Algoritmo de encriptación/desencriptación**: Operación matemática que nos permite a partir de una **clave de encriptación** cifrar el mensaje que queremos enviar a un mensaje cifrado. Este mensaje cifrado podremos descifrarlo a partir de una **clave de desencriptación**.

Podemos indicar dos tipos de criptografía dependiendo de las claves usadas:

* **Criptografía de clave simétrica**: Las claves de usadas por el emisor y el receptor son las mismas.
* **Criptografía de clave asimétrica o de clave pública**: Cada usuario tiene una **clave pública** conocida por todos y una **clave privada**, que es secreta.

<!--more-->

## Criptografía de clave simétrica

![gpg]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia2.png){: .align-center }

Como hemos indicado anteriormente el emisor y el receptor usan **la misma clave** para cifrar y descifrar el mensaje. Por lo tanto, el emisor y el receptor, antes de poder comunicarse, deben ponerse de acuerdo en el valor de la clave. Una vez que ambas partes tienen acceso a esta clave, el remitente cifra un mensaje usando la clave, lo envía al destinatario, y este lo descifra con la misma clave. 

Los algoritmos usados en la criptografía simétrica (POR EJEMPLO, **aes**) son principalmente operaciones booleanas y de transposición, y es **más eficiente que la criptografía asimétrica**. 

## Criptografía simétrica usando gpg

[GnuPG](https://www.gnupg.org/) es una implementación completa y gratuita del estándar OpenPGP, también conocido como PGP. GnuPG nos permite usar criptografía simétrica y asimétrica para cifrar y firmar nuestros datos.

Para instalar gpg en nuestro sistema operativo basado en Debian, ejecutamos:

```bash
apt install gnupg
```

Vamos a usar la opción `-c` del comando `gpg` para cifrar. Por ejemplo para cifrar un fichero, ejecutamos:

```bash
gpg -c fichero.txt
```

Nos pide la clave de encriptación (**Nota: si estáis usando gnome al introducir la clave para realizar la encriptación se guarda en una cache, por lo que no os va a pedir la clave a la hora de desencriptar**) y nos genera el fichero `fichero.txt.gpg`.

Para desencriptar el fichero usamos la opción `-d`, simplemente ejecutamos:

```bash
gpg -d fichero.txt.gpg
```

Por lo tanto, si queremos recuperar el fichero original podríamos ejecutar:

```bash
gpg -d fichero.txt.gpg > fichero2.txt
```

## Criptografía asimétrica

![gpg]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia3.png){: .align-center }

En este tipo de criptografía, el emisor y el receptor  no comparten clave secreta. Cada usuario tiene una clave de encriptación que es **pública**, y por lo tanto conocida por todos. La clave de desencriptación es **privada**, conocida sólo por el receptor.

Por lo tanto en este caso, utilizando distintos tipos de algoritmos (por ejemplo DSA o RSA) cualquier usuario puede puede cifrar un mensaje usando **la clave pública de un usuario**, sólo este usuario podrá descifrar el mensaje usando su **clave privada**.

Este tipo de criptografía es más compleja que la simétrica, por lo tanto es menos eficiente, aunque es más segura.

## Criptografía asimétrica con gpg

### Generación de claves

Lo primero que tenemos que hacer es generar un par de claves (pública y privada) para un usuario de nuestro sistema. Tenemos varias formas de generar las claves, la más sencilla es usar la siguiente opción:

```bash
gpg --gen-key
```

Nos pedirá el nombre del usuario y su correo electrónico, además podremos introducir una **frase de paso** para proteger la clave privada, cad vez que la usemos se nos pedirá esta frase.
Muchas de las opciones para generar las claves se han tomado por defecto, si queremos que nos pida más detalle de la generación de la clave podemos usar la opción `--full-generate-key`. Si usamos esta opción no pedirá el tipo de clave que vamos a generar, el tamaño de la clave y la fecha de validez de la clave.

### Listar las claves

Podemos listar las claves públicas que tenemos, con el siguiente comando:

```bash
gpg --list-key
/home/usuario/.gnupg/pubring.kbx
--------------------------------
pub   rsa3072 2023-10-16 [SC] [expires: 2025-10-15]
      F8F2A90AF7A9BFCC530BFC8F603DCFEBDFC063AB
uid           [ultimate] José Domingo <correo@example.org>
sub   rsa3072 2023-10-16 [E] [expires: 2025-10-15]
```

Vemos que se ha generado una clave principal pública (`pub`). También vemos la fecha de validez, así como su identificador (`uid`) (el nombre de usuario, el correo o el identificador alfanumérico). Esta clave primaría nos permite realziar firmas digitales, para cifrar se ha generado una subclave (`sub`) que está vinculada a la clave principal. Para más información sobre las subclaves puedes ver la [wiki de Debian](https://wiki.debian.org/Subkeys).

También podemos listar las calves privadas, ejecutando:

```bash
gpg --list-secret-key
/home/usuario/.gnupg/pubring.kbx
--------------------------------
sec   rsa3072 2023-10-16 [SC] [expires: 2025-10-15]
      F8F2A90AF7A9BFCC530BFC8F603DCFEBDFC063AB
uid           [ultimate] José Domingo <correo@example.org>
ssb   rsa3072 2023-10-16 [E] [expires: 2025-10-15]
```

Vemos que es la clave privada (`sec`) y que de la misma forma que la anterior, se ha asociado una subclave (`ssb`).

### Exportación e importación de claves

Si queremos que otros usuarios utilicen nuestra calve pública para cifrar mensajes, es necesaria enviarles nuestra clave pública. Para ello vamos a usar la siguiente instrucción donde tenemos que identificar nuestra calve pública (con el nombre, el correo o el identificador):

```bash
gpg --output josedom.gpg --export correo@example.org
```

El fichero `josedom.gpg` es un binario con nuestra clave pública, si para facilitar el envío queremos generarlo en formato de texto plano, ejecutamos:

```bash
gpg --armor --output josedom.asc --export correo@example.org
```

Podemos enviar el fichero `josedom.asc` a otros usuarios o subir nuestra calve pública a un servidor público de claves PGP, por ejemplo al de [red.es](https://www.rediris.es/servicios/identidad/pgp/index.html.es).





## Firma digital

## Firma digital con gpg

## Anillo de confianza

 

