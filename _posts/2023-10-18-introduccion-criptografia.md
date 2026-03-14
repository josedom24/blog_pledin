---
title: 'Introducción a la criptografía'
permalink: /2023/10/introduccion-criptografia/
tags:
  - Criptografía
  - Seguridad
  - Manuales
---

![criptografía]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/intro.png){: .align-center }

La **Criptografía** (que viene de dos palabras "cripto" (**secreto**) y "grafía" (**escritura**) nos permite el **cifrado** o **codificación** de mensajes con el fin de hacerlos ininteligibles. Puedes profundizar en este concepto en la [Wikipedia](https://es.wikipedia.org/wiki/Criptograf%C3%ADa).

Veamos algunos conceptos sobre criptografía:

![criptografía]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia1.png){: .align-center }

* **Emisor**: Cualquier persona o sistema (navegadores web, servicios, routers,...) que quieren enviar un mensaje de forma segura.
* **Receptor**: Cualquier persona o sistema que quiere recibir un mensaje de forma segura.
* **Atacante**: Cualquier persona o sistema que trata de leer, eliminar, modificar,... el mensaje enviado por el emisor hacia el receptor.
* **Algoritmo de encriptación/desencriptación**: Operación matemática que nos permite a partir de una **clave de encriptación** cifrar el mensaje que queremos enviar, obteneiendo un mensaje cifrado. Este mensaje cifrado podremos descifrarlo a partir de una **clave de desencriptación**.

Podemos indicar dos tipos de criptografía dependiendo de las claves usadas:

* **Criptografía de clave simétrica**: Las claves encriptación/desencriptación usadas por el emisor y el receptor son las mismas.
* **Criptografía de clave asimétrica o de clave pública**: Cada usuario tiene una **clave pública** conocida por todos y una **clave privada**, que es secreta.

<!--more-->

## Criptografía de clave simétrica

![criptografía]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia2.png){: .align-center }

Como hemos indicado anteriormente el emisor y el receptor usan **la misma clave** para cifrar y descifrar el mensaje. Por lo tanto, el emisor y el receptor, antes de poder comunicarse, deben ponerse de acuerdo en el valor de la clave. Una vez que ambas partes tienen acceso a esta clave, el remitente cifra un mensaje usando la clave, lo envía al destinatario, y este lo descifra con la misma clave. 

Los algoritmos usados en la criptografía simétrica (por ejemplo, **aes**) son principalmente operaciones booleanas y de transposición. Estos algoritmos son **más eficientes que los usados en la criptografía asimétrica**. 

## Criptografía asimétrica

![criptografía]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia3.png){: .align-center }

En este tipo de criptografía, el emisor y el receptor  no comparten una clave. Cada usuario tiene una clave que es **pública**, y por lo tanto conocida por todos y una clave que es **privada**, conocida sólo por el receptor.

Por lo tanto en este caso, utilizando distintos tipos de algoritmos (por ejemplo **DSA** o **RSA**) cualquier usuario puede cifrar un mensaje usando **la clave pública de un usuario**, sólo este usuario podrá descifrar el mensaje usando su **clave privada**.

Este tipo de criptografía es más compleja que la simétrica, por lo tanto es menos eficiente, aunque es más segura.

En al mayoría de los protocolos que usan criptografía para cifrar la información que se trasmite (por ejemplo, ssh o https) utilizamos las dos tipos de criptografía que hemos estudiado:
* **Criptografía simétrica** para el **cifrado de la información**, ya que es mucho más eficiente. 
* **Criptografía asimétrica**, para transmitir de forma segura la clave simétrica entre el emisor y el receptor.

## Firma digital

Antes de seguir explicando la firma digital, vamos a introducir el concepto de **función de dispersión o hash**. Por medio de un algoritmo (por ejemplo MD5, SHA-1,...) a partir de un fichero se obtiene un resumen de tamaño fijo. Evidentemente, a partir del resultado (hash) no podemos generar el fichero original. Podemos utilizar los hash para comprobar la **integridad** de un fichero. Por ejemplo, si sabemos el hash de un fichero, si lo descargamos podemos volver a ejecutar la función de dispersión para comprobar si hemos descargado un fichero corrupto. Si el hash del fichero descargado es igual que el hash del fichero original, podemos asegurar la integridad del fichero.

Una **firma digital** certifica un documento y le añade una marca de tiempo. Si posteriormente el documento fuera modificado en cualquier modo, el intento de verificar la firma fallaría. La utilidad de una firma digital es la misma que la de una firma escrita a mano, sólo que la digital tiene una resistencia a la falsificación.
Para que **un usuario firme un mensaje utilizará su clave privada**, y para **poder verificar dicha firma se utilizará la clave pública del usuario**.

Por lo tanto firmando un mensaje estamos asegurando su autenticidad, su integridad (que no ha sido modificado) y el no repudio (garantiza al receptor que el mensaje ha sido enviado por el emisor).

Resulta computacionalmente caro encriptar mensajes largos con nuestra clave privada para firmarlos. Por lo que al firmar un documento, vamos a calcular su hash y la vamos a encriptar con la clave privada del emisor, es decir, firmamos el hash. 

![criptografía]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia4.png){: .align-center }

Como vemos en el gráfico, tenemos un fichero que queremos firmar. Para ello:

1. Se calcula el hash usando una función de dispersión.
2. El hash se firma, es decir se cifra usando la clave privada del usuario.
3. Tenemos tres posibilidades para enviar la firma digital:
      * Si el receptor ya tiene el documento original, sólo mandamos la firma digital. 
      * Podemos mandar el fichero original y la firma por separado.
      * Podemos mandar un solo fichero con la el documento original y la firma.
4. Una vez que el documento es recibido por el receptor puede hacer varias cosas:
      * Validar la firma, es decir comprobar que realmente ha sido firmada por el usuario emisor.
      * Validar la firma y recuperar el documento original.
5. Para validar la firma, se vuelve a calcular el hash del documento.
6. Se descifra la firma con la clave pública del emisor y nos da el hash que habíamos cifrado en el punto 2.
7. Si los dos hash (el del punto 5 y el 6) son iguales significa que la validación es correcta.

## Necesidad de la confianza en la criptografía asimétrica

Uno de los problemas que nos podemos encontrar al usar criptografía asimétrica es **poder confiar que la clave pública que estamos usando para cifrar un documento o verificar una firma digital pertenece a un usuario adecuado**. Dicho de otro modo: necesitamos establecer una **confianza** en que la clave pública de un usuario es correcta, es decir el único que posee la clave privada correspondiente es el usuario auténtico al que pertenece. Cuanto más fiable sea el método de establecer esta confianza más seguridad tendrá el sistema. 

Lo ideal sería que cada usuario comunicara (e idealmente probara) de forma directa al resto de usuarios cuál es su clave pública. Sin embargo esto no es posible en la realidad y se desarrollan distintos esquemas para aportar confianza. Existen varios modelos, pero vamos a señalar dos de ellos:

### Red de confianza

![criptografía]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia5.png){: .align-center }

Establecimiento de una **red de confianza**: Los usuario recogen claves públicas de otros usuarios y aseguran su identidad si están seguros de que la clave privada correspondiente pertenece en exclusiva a ese usuario. Se pueden organizar [Grupos de firmas](https://www.gnupg.org/howtos/es/gpg-party.html) para que los usuarios amplíen su red de confianza. 

Para establecer que un usuario confía en otro, este firma digitalmente la clave pública de otro usuario (realmente firma la **huella digital** que es el hash de la clave pública tras aplicarle una función de dispersión). Además, dos usuarios que no se conocen pueden confiar en sus claves públicas si existe **una cadena de confianza** que enlace ambas partes, es decir un usuario puede confiar en otro aunque no tenga su clave pública firmada, si esta clave esta firmada por un tercer usuario en el que el primero confía.

### Infraestructura de clave pública o PKI

![criptografía]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia6.png){: .align-center } 

En este modelo hay una o varias entidades emisoras de certificados (**Autoridades de certificación** o **CA** del inglés **C**ertification **A**uthority) que aseguran la autenticidad de la clave pública y de ciertos atributos de identidad del usuario. Para ello firman con su clave privada ciertos atributos del usuario incluyendo su clave pública generando lo que se llama **certificado del usuario**.

## Conclusiones

En este artículo del blog he realizado un pequeño resumen de los conceptos teóricos más importantes sobre la Criptografía. He pretendido hacer un resumen de los contenidos que se imparten en la unidad de Criptografía en el módulo de Seguridad y Alta Disponibilidad del ciclo formativo de Administración de sistemas Informáticos. En la siguiente entrada veremos cada uno de estos conceptos usando la herramienta de encriptación y firma digital **GnuPGP (GNU Privacy Guard)**.




