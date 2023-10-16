---
title: 'Introducción a la criptografía'
permalink: /2023/10/introduccion-criptografia/
tags:
  - Criptografía
  - Seguridad
  - Manuales
---

La **Criptografía** (que viene de dos palabras "cripto" (**secreto**) y "grafía" (**escritura**)) nos permite el **cifrado** o **codificación** de mensajes con el fin de hacerlos ininteligibles. Puedes profundizar en este concepto en la [Wikipedia](https://es.wikipedia.org/wiki/Criptograf%C3%ADa).

Veamos algunos conceptos sobre criptografía:

![croptografía]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia1.png){: .align-center }

* **Emisor**: Cualquier persona o sistema (navegadores web, servicios, routers,...) que quieren enviar un mensaje de forma segura.
* **Receptor**: Cualquier persona o sistema que quiere recibir un mensaje de forma segura.
* **Atacante**: Cualquier persona o sistema que trata de leer, eliminar, modificar,... el mensaje enviado por el emisor hacia el receptor.
* **Algoritmo de encriptación/desencriptación**: Operación matemática que nos permite a partir de una **clave de encriptación** cifrar el mensaje que queremos enviar a un mensaje cifrado. Este mensaje cifrado podremos descifrarlo a partir de una **clave de desencriptación**.

Podemos indicar dos tipos de criptografía dependiendo de las claves usadas:

* **Criptografía de clave simétrica**: Las claves de usadas por el emisor y el receptor son las mismas.
* **Criptografía de clave asimétrica o de clave pública**: Cada usuario tiene una **clave pública** conocida por todos y una **clave privada**, que es secreta.

<!--more-->

## Criptografía de clave simétrica

![croptografía]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia2.png){: .align-center }

Como hemos indicado anteriormente el emisor y el receptor usan **la misma clave** para cifrar y descifrar el mensaje. Por lo tanto, el emisor y el receptor, antes de poder comunicarse, deben ponerse de acuerdo en el valor de la clave. Una vez que ambas partes tienen acceso a esta clave, el remitente cifra un mensaje usando la clave, lo envía al destinatario, y este lo descifra con la misma clave. 

Los algoritmos usados en la criptografía simétrica (por ejemplo, **aes**) son principalmente operaciones booleanas y de transposición, y es **más eficiente que la criptografía asimétrica**. 

## Criptografía asimétrica

![croptografía]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia3.png){: .align-center }

En este tipo de criptografía, el emisor y el receptor  no comparten clave secreta. Cada usuario tiene una clave de encriptación que es **pública**, y por lo tanto conocida por todos. La clave de desencriptación es **privada**, conocida sólo por el receptor.

Por lo tanto en este caso, utilizando distintos tipos de algoritmos (por ejemplo DSA o RSA) cualquier usuario puede puede cifrar un mensaje usando **la clave pública de un usuario**, sólo este usuario podrá descifrar el mensaje usando su **clave privada**.

Este tipo de criptografía es más compleja que la simétrica, por lo tanto es menos eficiente, aunque es más segura.

En al mayoría de los protocolos que usan criptografía para cifrar la información que se trasmite (por ejemplo, ssh o https) utilizamos las dos tipos de criptografía que hemos estudiado:
* **Criptografía simétrica** para el **cifrado de la información**, ya que es mucho más eficiente. 
* **Criptografía asimétrica**, para transmitir de forma segura la clave de encriptación simétrica entre el emisor y el receptor.

## Firma digital

Antes de seguir explicando la firma digital, vamos a introducir el concepto de **función de dispersión o hash**. Por medio de un algoritmo (por ejemplo MD5, SHA-1,...) a partir de un fichero se obtiene un resumen de tamaño fijo. Evidentemente, a partir del resultado (hash) no podemos generar el fichero original. Podemos utilizar los hash para comprobar la **integridad** de un fichero. Por ejemplo, si sabemos el hash de un fichero, si lo descargamos podemos volver a ejecutar la función de dispersión para comprobar si hemos descargado un fichero corrupto. Si el hash del fichero descargado es igual que el hash del fichero original, podemos asegurar la integridad del fichero.

Una firma digital certifica un documento y le añade una marca de tiempo. Si posteriormente el documento fuera modificado en cualquier modo, el intento de verificar la firma fallaría. La utilidad de una firma digital es la misma que la de una firma escrita a mano, sólo que la digital tiene una resistencia a la falsificación.
Para que un usuario firme un mensaje utilizará su clave privada, y para poder verificar dicha firma se utilizará la clave pública del usuario.

Por lo tanto firmando un mensaje estamos asegurando su autenticidad, su integridad (que no ha sido modificado) y el no repudio (garantiza al receptor que el mensaje ha sido generado por el emisor).

Resulta computacionalmente caro encriptar mensajes largos con nuestra calve privada para firmarlos. Por lo que al firmar un documento, vamos a calcular su hash lo vamos a encriptar con la clave privada del emisor. 

![croptografía]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/10/criptografia4.png){: .align-center }

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
7. Si los dos hash (el del punto 5 y el 6) son iguales significa que la validación es correcta

## Anillo de confianza

 

