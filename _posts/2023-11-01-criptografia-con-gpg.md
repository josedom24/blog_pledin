---
title: 'Introducción a la criptografía con GnuPG'
permalink: /2023/11/criptografia-con-gpg/
tags:
  - Criptografía
  - gpg
  - Manuales
---

![gpg]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/11/logo-gnupg-light-purple-bg.png){: .align-center }

En el artículo anterior: [Introducción a la criptografía](https://www.josedomingo.org/pledin/2023/10/introduccion-criptografia/) repasamos los aspectos más importantes sobre criptografía. En este artículo vamos a hacer una aplicación práctica utilizando el software GnuPG.

[GnuPG](https://www.gnupg.org/) es una implementación completa y gratuita del estándar OpenPGP, también conocido como PGP. GnuPG nos permite usar criptografía simétrica y asimétrica para cifrar y firmar nuestros datos.

Para instalar gpg en nuestro sistema operativo basado en Debian, ejecutamos:

```
apt install gnupg
```

## Criptografía simétrica usando gpg

Recordamos que en la **criptografía simétrica** las claves encriptación/desencriptación usadas por el emisor y el receptor son las mismas.

Vamos a usar la opción `-c` del comando `gpg` para cifrar. Por ejemplo para cifrar un fichero, ejecutamos:

```
gpg -c fichero.txt
```

Nos pide la clave de encriptación (**Nota: si estáis usando gnome al introducir la clave para realizar la encriptación se guarda en una cache, por lo que no os va a pedir la clave a la hora de desencriptar**) y nos genera el fichero `fichero.txt.gpg`.

Para desencriptar el fichero usamos la opción `-d`, simplemente ejecutamos:

```
gpg -d fichero.txt.gpg
```

Por lo tanto, si queremos recuperar el fichero original podríamos ejecutar:

```
gpg -d fichero.txt.gpg > fichero2.txt
```

<!--more-->

## Criptografía asimétrica con gpg

En la **criptografía asimétrica o de clave pública**, cada usuario tiene una clave pública conocida por todos y una clave privada, que es secreta.

### Generación de claves

Lo primero que tenemos que hacer es generar un par de claves (pública y privada) para un usuario de nuestro sistema. Tenemos varias formas de generar las claves, la más sencilla es usar la siguiente opción:

```
gpg --gen-key
```

Nos pedirá el nombre del usuario y su correo electrónico, además podremos introducir una **frase de paso** para proteger la clave privada, cad vez que la usemos se nos pedirá esta frase.
Muchas de las opciones para generar las claves se han tomado por defecto, si queremos que nos pida más detalle de la generación de las claves podemos usar la opción `--full-generate-key`. Si usamos esta opción nos pedirá el tipo de clave que vamos a generar, el tamaño de la clave y la fecha de validez de la clave.

### Listar las claves

Podemos listar las claves públicas que tenemos, con el siguiente comando:

```
gpg --list-key
/home/usuario/.gnupg/pubring.kbx
--------------------------------
pub   rsa3072 2023-10-16 [SC] [expires: 2025-10-15]
      F8F2A90AF7A9BFCC530BFC8F603DCFEBDFC063AB
uid           [ultimate] José Domingo <correo@example.org>
sub   rsa3072 2023-10-16 [E] [expires: 2025-10-15]
```

Vemos que se ha generado una clave principal pública (`pub`). También vemos la fecha de validez, así como su identificador (`uid`) (el nombre de usuario, el correo o el identificador alfanumérico). Esta clave primaría nos permite realizar firmas digitales, para cifrar se ha generado una subclave (`sub`) que está vinculada a la clave principal. Para más información sobre las subclaves puedes ver la [wiki de Debian](https://wiki.debian.org/Subkeys).

También podemos listar las claves privadas, ejecutando:

```
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

Si queremos que otros usuarios utilicen nuestra clave pública para cifrar mensajes, es necesaria enviarles nuestra clave pública. Para ello vamos a exportarla, usando la siguiente instrucción, donde tenemos que identificar nuestra clave pública (con el nombre, el correo o el identificador):

```
gpg --output josedom.gpg --export correo@example.org
```

El fichero `josedom.gpg` es un binario con nuestra clave pública, si para facilitar el envío queremos generarlo en formato de texto plano, ejecutamos:

```
gpg --armor --output josedom.asc --export correo@example.org
```

Podemos enviar el fichero `josedom.asc` a otros usuarios o subir nuestra clave pública a un servidor público de claves PGP, por ejemplo al de [red.es](https://www.rediris.es/servicios/identidad/pgp/index.html.es).

Por último, si nosotros recibimos una clave pública de otro usuario en el fichero `ahsoka.asc` y queremos importarlo, ejecutaremos:

```
gpg --import ahsoka.asc
```

Y podemos comprobar que la importación ha sido correcta:

```
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

Si queremos cifrar un documento para el usuario Ahsoka, lo haremos usando su clave pública. Solo el usuario Ashoka podrá descifrarlo con su clave privada. Por lo tanto, si queremos cifrar un documento cifrado para que solo lo descifre el usuario Ahoska, lo cifraremos (con la opción `--encrypt`) con su clave pública:

```
gpg --output fichero.txt.gpg --encrypt --recipient ahsoka@example.org fichero.txt 
```

Cuando el usuario recibe el fichero cifrado, utilizará su clave privada (por lo tanto se nos pedirá la frase de paso) para descifrarlo:

```
gpg --output fichero.txt --decrypt fichero.txt.gpg 
gpg: encrypted with 3072-bit RSA key, ID FA920C331CD102E2, created 2023-10-16
      "Ahsoka Tano <ahsoka@example.org>"
```
## Firma digital con gpg

Una **firma digital** certifica un documento y le añade una marca de tiempo. Si posteriormente el documento fuera modificado en cualquier modo, el intento de verificar la firma fallaría. La utilidad de una firma digital es la misma que la de una firma escrita a mano, sólo que la digital tiene una resistencia a la falsificación. Para que **un usuario firme un mensaje utilizará su clave privada, y para poder verificar dicha firma se utilizará la clave pública del usuario.**

El parámetro `--sign` se usa para generar una firma digital. El documento que se desea firmar es la entrada, y la salida es el documento firmado. 

```
gpg --output fichero.sig --sign fichero.pdf
```
Si es necesario se pedirá la frase de paso de la clave privada. El documento se comprime antes de ser firmado, y la salida es en formato binario.

El usuario al que enviamos el documento firmado necesita tener nuestra clave pública para poder verificar la firma. Con un documento con firma digital el usuario puede llevar a cabo dos acciones: comprobar sólo la firma o comprobar la firma y recuperar el documento original al mismo tiempo. Para comprobar la firma se usa la opción `--verify`. 

```
gpg --verify fichero.sig
gpg: Firmado el dom 22 oct 2023 11:27:51 CEST
gpg:                usando RSA clave 67379D6620EAD8BF2DA7111760DAB70F3B298B8C
gpg: Firma correcta de "José Domingo Muñoz Rodríguez <josedom24@josedomingo.org>" [absoluta]
```

Para verificar la firma y extraer el documento se usa la opción `--decrypt`. El documento con la firma es la entrada, y el documento original recuperado es la salida.

```
gpg --output fichero_original.pdf --decrypt fichero.sig
```

En algunos casos es necesario no comprimir el fichero firmado, y generar firmas ASCII, para ello usaremos la opción `--clearsign`:

```
gpg --clearsign fichero.txt
```

Se genera el fichero `fichero.txt.asc` con el contenido del fichero y la firma digital en formato ASCII.

Si el receptor ya tiene el documento original, sólo mandamos la firma digital. Generamos la firma con la opción `--detach-sign` de gpg.

```
gpg --output fichero.sig --detach-sig fichero.pdf
```

El fichero `fichero.sig` es sólo la firma digital del fichero que hemos firmado.

## Validación de las claves

Como hemos visto anteriormente es necesario poseer la clave pública de los usuarios con los que estoy intercambiando información. Esa clave pública nos servirá:

* Para poder cifrar mensajes que le envío a ese usuario y que solamente el podrá descifrar con su clave privada.
* Para poder verificar la firma digital que haya realizado ese usuario.

Cuando recibimos la clave pública de un usuario y la hayamos importado, es necesario validarla. Tenemos dos métodos para validar las claves:

### Validación personal

En este caso, se verifica la huella digital (el hash de la clave pública), se comprueba que pertenece al usuario apropiado (garantizar que la persona con la que se está comunicando sea el auténtico propietario de la clave), y a continuación **firmamos su clave pública con nuestra clave privada**.

En nuestro ejemplo hemos importado la clave pública de Ahsoka Tano, tendríamos que calcular la huella digital de la clave, ejecutando el subcomando `fpr` al editar la clave:

```
gpg --edit-key ahsoka@example.org
gpg (GnuPG) 2.2.40; Copyright (C) 2022 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


pub  rsa3072/E0EE582D3C903041
     created: 2023-10-22  expires: 2025-10-21  usage: SC  
     trust: unknown       validity: unknown
sub  rsa3072/11518C522A7B719A
     created: 2023-10-22  expires: 2025-10-21  usage: E   
[ unknown] (1). Ahsoka Tano <ahsoka@example.org>

gpg> fpr
pub   rsa3072/E0EE582D3C903041 2023-10-22 Ahsoka Tano <ahsoka@example.org>
 Primary key fingerprint: 11AD F9B8 DF66 0DFB D147  B4A5 E0EE 582D 3C90 3041
```

Ahora tendría que verificar la huella digital con el propietario de la clave, es decir, con Ahsoka Tano. Esto puede hacerse en persona o por teléfono, o por medio de otras maneras, siempre y cuando el usuario pueda garantizar que la persona con la que se está comunicando sea el auténtico propietario de la clave. Si la huella digital que se obtiene por medio del propietario es la misma que la que se obtiene de la clave, entonces se puede estar seguro de que se está en posesión de una copia correcta de la clave.

Después de esta comprobación, ya podríamos realizar la firma, con el subcomando `--sign` (como haremos uso de nuestra clave privada, se nos pedirá la frase de paso):

```
gpg> sign

pub  rsa3072/E0EE582D3C903041
     created: 2023-10-22  expires: 2025-10-21  usage: SC  
     trust: unknown       validity: unknown
 Primary key fingerprint: 11AD F9B8 DF66 0DFB D147  B4A5 E0EE 582D 3C90 3041

     Ahsoka Tano <ahsoka@example.org>

This key is due to expire on 2025-10-21.
Are you sure that you want to sign this key with your
key "José Domingo <correo@example.org>" (603DCFEBDFC063AB)

Really sign? (y/N) y
```

Para terminar la edición de la clave, guardamos los cambios con el subcomando `save`.

### Anillo de confianza

Desafortunadamente este proceso es complicado cuando debemos validar un gran número de claves o cuando debemos comunicarnos con personas a las que no conocemos personalmente.
GnuPG trata este problema con un mecanismo conocido como **anillo de confianza**. En el modelo del anillo de confianza la responsabilidad de la validación de las claves públicas recae en las personas en las que confiamos.

Pongamos un ejemplo:

* Yo he firmado la clave pública de Ahsoka Tano,
* y Ahsoka Tano ha firmado las claves de Anakin Skywalker y de Obi-Wan Kenobi.

Si yo confío en Ahsoka Tano, ya que he validado personalmente su clave, entonces puede deducir que las claves de Anakin Skywalker y de Obi-Wan Kenobi son válidas sin llegar a comprobarlas personalmente. Tendré que usar la clave pública de Ahsoka Tano para comprobar que las las claves de Anakin Skywalker y de Obi-Wan Kenobi son válidas. 

Hay que introducir un nuevo concepto **confianza en en el propietario** (**trust**). Hay que diferenciar este concepto con el de **validación** (**validity**) que será la confianza en que una clave pertenece a la persona asociada con el identificador de clave.

En la práctica la confianza es algo subjetivo. Por ejemplo, la clave de Ahoska Tano es válida para mi, ya que la he firmado, pero puedo desconfiar de otras claves que hayan sido validadas por la firma de Ahsoka Tano. En este caso, puede que yo no acepte las claves de Anakin Skywalker y de Obi-Wan Kenobi como válidas sólo porque hayan sido firmadas por Ahsoka Tano. Si volvemos a editar la clave de Ahsoka:

```
gpg --edit-key ahsoka@example.org 
gpg (GnuPG) 2.2.40; Copyright (C) 2022 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.


pub  rsa3072/E0EE582D3C903041
     created: 2023-10-22  expires: 2025-10-21  usage: SC  
     trust: unknown       validity: full
sub  rsa3072/11518C522A7B719A
     created: 2023-10-22  expires: 2025-10-21  usage: E   
[  full  ] (1). Ahsoka Tano <ahsoka@example.org>

gpg> 

```
Vemos como la confianza en el propietario es desconocida (**unknown**) y sin embargo la confianza de que la clave es de Ahsoka Tano es total (**full**) ya que la he firmado anteriormente. El nivel de confianza en una clave es algo que sólo nosotros podemos asignar a la clave, y se considera información privada. El nivel de confianza no se exporta con la clave, de hecho no se almacena en los anillos de claves sino en una base de datos aparte. El editor de claves nos permite ajustar nuestra confianza en el propietario de una clave, para ello usamos el subcomando `trust`:

```
gpg> trust
pub  rsa3072/E0EE582D3C903041
     created: 2023-10-22  expires: 2025-10-21  usage: SC  
     trust: unknown       validity: full
sub  rsa3072/11518C522A7B719A
     created: 2023-10-22  expires: 2025-10-21  usage: E   
[  full  ] (1). Ahsoka Tano <ahsoka@example.org>

Please decide how far you trust this user to correctly verify other users' keys
(by looking at passports, checking fingerprints from different sources, etc.)

  1 = I don't know or won't say
  2 = I do NOT trust
  3 = I trust marginally
  4 = I trust fully
  5 = I trust ultimately
  m = back to the main menu

Your decision? 
```

Como vemos podemos configurar la confianza del propietario de la clave en distintos niveles:

* **1 = I don't know or won't say (unknown)**: No lo sé o prefiero no decirlo. No se sabe nada sobre el dueño de la clave firmante. Las claves en nuestro anillo de claves que no nos pertenezcan tendrán al principio este nivel de confianza.
* **2 = I do NOT trust (never)**: No tengo confianza. Se sabe que el propietario firma otras claves de modo impropio.
* **3 = I trust marginally (marginal)**: Confío un poco. El propietario comprende las implicaciones de firmar una clave y valida las claves de forma correcta antes de firmarlas.
* **4 = I trust fully (full)**:Confío totalmente. El propietario comprende perfectamente las implicaciones de firmar una clave y su firma sobre una clave es tan buena como la nuestra.
* **5 = I trust ultimately (ultimate)**: confío absolutamente. Es la confianza que tenemos sobre nuestras claves. Problablemente tendremos además las privadas del usuario.

### Usar la confianza para validar las claves

El anillo de confianza permite usar un algoritmo más elaborado para validar una clave. Hasta ahora, una clave sólo se consideraba válida si la firmábamos nosotros personalmente. Ahora es posible usar un algoritmo más flexible: una clave se considera válida si cumple dos condiciones:

* Si viene firmada por las suficientes claves válidas, lo que quiere decir:
      * Que la hemos firmado nosotros personalmente,
      * o que ha sido firmada por una clave de plena confianza,
      * o que ha sido firmada por tres claves de confianza marginal;
* y si el camino de claves firmadas que nos lleva desde la clave hasta nuestra propia clave es de cinco pasos o menos.

La longitud del camino, en número de claves con confianza marginal requeridas, y el número de claves con confianza plena requeridas se pueden cambiar. Los números dados arriba son los valores por definición usados por GnuPG.

Veamos un ejemplo:

* Ahoska Tano ha firmado la clave de Obi-Wan Kenobi, por lo tanto la valida.
* Yo recibo la clave pública de Obi-Wan Kenobi, firmado por Ahsoka Tano. No conozco a Obi-Wan, por lo que no firmo su clave para validarla.
* He recibido la clave de Anakin Skywalker que ha sido firmada por Obi-Wan Kenobi.

![criptografía]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/11/criptografia7.png){: .align-center }

Si yo confio totalmente en Ahoska Tano:

* La clave de Obi-Wan Kenobi también es válida por el anillo de conianza ya que **ha sido firmada por una clave de plena confianza**.
* La clave de Anakin Skywalker no es válida, realmente su validez no esta definidad.

```
gpg --list-keys
/home/vagrant/.gnupg/pubring.kbx
--------------------------------
...
uid           [ultimate] José Domingo <correo@example.org>
...
uid           [  full  ] Ahsoka Tano <ahsoka@example.org>
...
uid           [  full  ] Obi-Wan Kenobi <obi@example.org>
...
uid           [  undef ] Anakin Skywalker <anakin@example.org>
```

Sin embargo, si cambio el nivel de confianza de Ahsoka Tano a marginal:

*  Comprobamos que ahora la validez de la clave de Obi-Wan será marginal.
* Y la clave de Anakin Skywalker es desconocida.

```
gpg --list-keys
/home/vagrant/.gnupg/pubring.kbx
--------------------------------
...
uid           [ultimate] José Domingo <correo@example.org>
...
uid           [  full  ] Ahsoka Tano <ahsoka@example.org>
...
uid           [  marginal  ] Obi-Wan Kenobi <obi@example.org>
...
uid           [  unknown ] Anakin Skywalker <anakin@example.org>
```

## Conclusiones

En este artículo hemos hecho un resumen del uso de la herramienta GnuPG para trabajar con criptografía simétrica y asimétrica. Para seguir profundizando en el uso de esta herramienta os sugiero la lectura de la [documentación oficial](https://www.gnupg.org/documentation/index.html).



