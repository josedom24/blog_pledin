---
title: 'Introducción a la criptografía con gpg'
permalink: /2023/10/criptografia-con-gpg/
tags:
  - Criptografía
  - gpg
  - Manuales
---

![gpg]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/logo-gnupg-light-purple-bg.png){: .align-center }

En el artículo anterior: [Introducción a la criptografía](https://www.josedomingo.org/pledin/2023/10/introduccion-criptografia/) repsamos los aspectos más importantes sobre criptografía. En este artículo vamos a hacer una aplicación práctica utilizando el software GPG.

[GnuPG](https://www.gnupg.org/) es una implementación completa y gratuita del estándar OpenPGP, también conocido como PGP. GnuPG nos permite usar criptografía simétrica y asimétrica para cifrar y firmar nuestros datos.

Para instalar gpg en nuestro sistema operativo basado en Debian, ejecutamos:

```bash
apt install gnupg
```

## Criptografía simétrica usando gpg

Recordamos que en la **criptografía simétrica** las claves encriptación/desencriptación usadas por el emisor y el receptor son las mismas.

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

## Criptografía asimétrica con gpg

En la **criptografía asimétrica o de clave pública**, cada usuario tiene una clave pública conocida por todos y una clave privada, que es secreta.

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

Por último, si nosotros recibimos una clave pública de otro usuario en el fichero `ahsoka.asc` y queremos importarlo, ejecutaremos:

```bash
gpg --import ahsoka.asc
```

Y podemos comprobar que la importación ha sido correcta:

```bash
gpg --list-key
...
--------------------------------
pub   rsa3072 2023-10-16 [SC] [expires: 2025-10-15]
      F8F2A90AF7A9BFCC530BFC8F603DCFEBDFC063AB
uid           [ultimate] José Domingo <correo@example.org>
sub   rsa3072 2023-10-16 [E] [expires: 2025-10-15]

pub   rsa3072 2023-10-16 [SC] [expires: 2025-10-15]
      2BF88208A94C08B3204F0131D0C833A59DC79BA6
uid           [ultimate] Ahsoka Tano <ahsoka@example.org>
sub   rsa3072 2023-10-16 [E] [expires: 2025-10-15]
```

### Cifrar y descifrar documentos

Cada clave pública y privada tiene un papel específico en el cifrado y descifrado de documentos. Se puede pensar en una clave pública como en una caja fuerte de seguridad. Cuando un remitente cifra un documento usando una clave pública, ese documento se pone en la caja fuerte, la caja se cierra, y el bloqueo de la combinación de ésta se gira varias veces. La parte correspondiente a la clave privada, esto es, el destinatario, es la combinación que puede volver a abrir la caja y retirar el documento. Dicho de otro modo, sólo la persona que posee la clave privada puede recuperar un documento cifrado usando la clave pública asociada al cifrado.

Si queremos cifrar un documento para el usuario Ahsoka, loo haremos usando su clave pública. Solo el usuario Ashoka podrá descifrarlo con su clave privada. Por lo tanto, si queremos cifrar un documento cifrado para que solo lo descifre el usuario Ahoska, lo cifraremos (con la opción `--encrypt`) con su clave pública:

```bash
gpg --output fichero.txt.gpg --encrypt --recipient ahsoka@example.org fichero.txt 
```

Cuando el usuario recibe el fichero cifrado, utilizará su clave privada (por lo tanto se nos pedirá la frase de paso) para descifrarlo:

```bash
gpg --output fichero.txt --decrypt fichero.txt.gpg 
gpg: encrypted with 3072-bit RSA key, ID FA920C331CD102E2, created 2023-10-16
      "Ahsoka Tano <ahsoka@example.org>"
```
## Firma digital con gpg

Una **firma digital** certifica un documento y le añade una marca de tiempo. Si posteriormente el documento fuera modificado en cualquier modo, el intento de verificar la firma fallaría. La utilidad de una firma digital es la misma que la de una firma escrita a mano, sólo que la digital tiene una resistencia a la falsificación. Para que **un usuario firme un mensaje utilizará su clave privada, y para poder verificar dicha firma se utilizará la clave pública del usuario.**

el parámetro `--sign`` se usa para generar una firma digital. El documento que se desea firmar es la entrada, y la salida es el documento firmado. 

```bash
gpg --output fichero.sig --sign fichero.pdf
```
Si es necesario se pedirá la frase de paso de la clave privada. El documento se comprime antes de ser firmado, y la salida es en formato binario.

El usuario al que enviamos el documento firmado necesita tener nuestra clave pública para poder verificar la firma. Con un documento con firma digital el usuario puede llevar a cabo dos acciones: comprobar sólo la firma o comprobar la firma y recuperar el documento original al mismo tiempo. Para comprobar la firma se usa la opción `--verify`. 

```bash
gpg --verify fichero.sig
gpg: Firmado el dom 22 oct 2023 11:27:51 CEST
gpg:                usando RSA clave 67379D6620EAD8BF2DA7111760DAB70F3B298B8C
gpg: Firma correcta de "José Domingo Muñoz Rodríguez <josedom24@josedomingo.org>" [absoluta]
```
Para verificar la firma y extraer el documento se usa la opción `--decrypt`. El documento con la firma es la entrada, y el documento original recuperado es la salida.

```bash
gpg --output fichero_original.pdf --decrypt fichero.sig
```

En algunos casos es necesario no comprimir el fichero firmado, y generar firmas ASCII, para ello usaremos la opción `--clearsign`:

```bash
gpg --clearsign fichero.txt
```

Se genera el fichero `fichero.txt.asc` con el contenido del fichero y la firma digital en formato ASCII.

Si el receptor ya tiene el documento original, sólo mandamos la firma digital. Generamos la firma con la opción `--detach-sign` de gpg.

```bash
gpg --output fichero.sig --detach-sig fichero.pdf
```

El fichero `fichero.sig` es sólo la firma digital del fichero que hemos firmado.

## Validación de las claves

Como hemos visto anteriormente es necesario poseer la clave pública de los usuarios con los que estoy intercambiando información. Esa clave pública nos servirá:

* Para poder cifrar mensajes que le envío a ese usuario y que solamente el podrá descifrar con su clave privada.
* Para poder verificar la firma digital que haya realizado ese usuario.

Cuando recibimos la clave pública de un usuario podemos y la hayamos importado, es necesario validarla. Tenemos dos métodos para validar las claves:

### Validación personal

En este caso, se verifica la huella digital (el hash de la clave pública), se comprueba que pertenece al usuario apropiado (garantizar que la persona con la que se está comunicando sea el auténtico propietario de la clave), y a continuación **firmamos su clave pública con nuestra clave privada.**.

En nuestro ejemplo hemos importado la clave pública de Ahsoka Tano, tendríamos que calcular la huella digital de la clave, ejecutando el subcomando `fpr` al editar la clave:

```bash
gpg --edit-key ahsoka@example.org
gpg (GnuPG) 2.2.40; Copyright (C) 2022 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  rsa3072/D0C833A59DC79BA6
     created: 2023-10-16  expires: 2025-10-15  usage: SC  
     trust: ultimate      validity: ultimate
ssb  rsa3072/FA920C331CD102E2
     created: 2023-10-16  expires: 2025-10-15  usage: E   
[ultimate] (1). Ahsoka Tano <ahsoka@example.org>

gpg> fpr
pub   rsa3072/D0C833A59DC79BA6 2023-10-16 Ahsoka Tano <ahsoka@example.org>
 Primary key fingerprint: 2BF8 8208 A94C 08B3 204F  0131 D0C8 33A5 9DC7 9BA6
```

Ahora tendría que verificar la huella digital con el propietario de la clave, es decir, con Ahsoka Tano. Esto puede hacerse en persona o por teléfono, o por medio de otras maneras, siempre y cuando el usuario pueda garantizar que la persona con la que se está comunicando sea el auténtico propietario de la clave. Si la huella digital que se obtiene por medio del propietario es la misma que la que se obtiene de la clave, entonces se puede estar seguro de que se está en posesión de una copia correcta de la clave.

Después de esta comprobación, ya podríamos realizar la firma, con el subcomando `--sign` (como haremos uso de nuestra calve privada, se nos pedirá lsu frase de paso):

```bash
gpg> sign

sec  rsa3072/D0C833A59DC79BA6
     created: 2023-10-16  expires: 2025-10-15  usage: SC  
     trust: ultimate      validity: ultimate
 Primary key fingerprint: 2BF8 8208 A94C 08B3 204F  0131 D0C8 33A5 9DC7 9BA6

     Ahsoka Tano <ahsoka@example.org>

This key is due to expire on 2025-10-15.
Are you sure that you want to sign this key with your
key "José Domingo <correo@example.org>" (603DCFEBDFC063AB)

Really sign? (y/N) y

```

### Anillo de confianza

Desafortunadamente este proceso se complicado cuando debemos validar un gran número de claves o cuando debemos comunicarnos con personas a las que no conocemos personalmente.
GnuPG trata este problema con un mecanismo conocido como **anillo de confianza**. En el modelo del anillo de confianza la responsabilidad de la validación de las claves públicas recae en las personas en las que confiamos.

Pongamos un ejemplo:

* Si yo he firmado la clave pública de Ahsoka Tano,
* y Ahsoka Tano ha firmado las claves de Anakin Skywalker y de Obi-Wan Kenobi.

Si yo confío en Ahsoka Tano, ya que he validado personalmente su clave, entonces puede deducir que las claves de Anakin Skywalker y de Obi-Wan Kenobi son válidas sin llegar a comprobarlas personalmente. Tendré que usar la clave pública de Ahsoka Tano para comprobar que las las calves de Anakin Skywalker y de Obi-Wan Kenobi son válidas. 

