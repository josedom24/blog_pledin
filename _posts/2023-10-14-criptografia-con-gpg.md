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

Veamos un ejemplo:

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


 

