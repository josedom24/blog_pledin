---
title: 'Configuración automática de una máquina virtual de Proxmox con cloud-init'
permalink: /2022/10/proxmox-cloud-init/
tags:
  - Virtualización
  - Proxmox
  - cloud-init
---

![proxmox + cloud-init]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/10/proxmox_cloudinit.png){: .align-center }

[cloud-init](https://cloud-init.io/): **cloud instance initialization**, es un programa que permite realizar la configuración de la instancia al crearse a partir de una imagen. Es el estándar de facto en nube pública o privada, está desarrollado en python y es un proyecto liderado por Canonical.

cloud-init nos va a permitir la configuración inicial de un máquina virtual. Si estamos trabajando en su servicio de cloud computing IaaS, esta funcionalidad es totalmente necesaria, ya que la instancia se construye a partir de una imagen mínima, sin contraseña establecida y con una configuración totalmente genérica. Será necesario configurar ciertos parámetros de la máquina:

* Configuración esencial:
	* Generación de la clave ssh de la instancia
    * Parámetros de red, hostname, etc.
    * Autenticación del usuario (clave ssh)
* Configuración no esencial:
	* Actualización de los paquetes instalados, instalación de algún paquete,...
	* Creación de algún usuario
	* ...

En el caso de Proxmox también tenemos la posibilidad de usar cloud-init para configurar nuestras máquinas virtuales. En este artículo vamos a construir una plantilla de una máquina virtual configurada con cloud-init que nos permita crear máquinas clonadas y configurarlas por medio de esta herramienta.

<!--more-->

## Creación de la plantilla con cloud-init

He instalado una máquina virtual con Debian Bullseye (el proceso sería similar con otras distribuciones). En esta máquina vamos a instalar cloud-init con el siguiente comando:

```bash
apt install cloud-init
```

La información que le vamos a ofrecer a nuestras máquinas para que cloud-init las configuren se van a guardar en un fichero de texto dentro de una unidad de CD-ROM (en los proveedores de cloud se suele utilizar un servidor web, que llamamos de *servidor de metadatos*, donde se conectan las instancias por obtener la información de configuración). Por lo tanto una vez apagada nuestra máquina, nos vamos al apartado **Hardware** y le añadimos un dispositivo **CloudInit Drive** que añadirá una unidad de CD-ROM a nuestra máquina:

![proxmox + cloud-init]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/10/cloudinit1.png){: .align-center }

Tenderemos que elegir el tipo de bus y el pool de almacenamiento donde se guardará la información de este CD-ROM:

![proxmox + cloud-init]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/10/cloudinit2.png){: .align-center }

El siguiente paso, sería configurar los datos de configuración de la futura plantilla que estamos configurando. Posteriormente cuando clonemos la plantilla para crear una nueva máquina, estos datos se podrán reescribir. La información que podemos ofrecer a cloud-init para que configure la máquina será: el usuario y su contraseña, el dominio y el servidor DNS, la clave pública que se inyectará en la máquina para el acceso por SSH y la configuración de red.

Para hacer esta configuración por defecto, nos vamos a la opción **Cloud-Init**:

![proxmox + cloud-init]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/10/cloudinit3.png){: .align-center }

Donde hemos configurado un usuario y una contraseña por defecto, los servidores y dominios DNS lo hemos dejado sin indicar (para que coja los definidos en el servidor de proxmox), no hemos añadido una clave ssh y por último, hemos configurado la red para que se configure por DHCP.

Para terminar convertimos la máquina virtual en una plantilla, desde la cual podamos clonar nuevas máquinas:

![proxmox + cloud-init]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/10/cloudinit4.png){: .align-center }

## Creación de nuevas máquinas virtuales y configuración con cloud-init

Las nuevas máquinas virtuales que creemos a partir de la plantilla que hemos definido, tendrán un CD-ROM para guardar la información ofrecida a cloud-init. Además dicha información que configuramos para la plantilla, la podremos modificar. Vamos a crear una nueva máquina a partir de la plantilla, usando clonación enlazada:

![proxmox + cloud-init]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/10/cloudinit5.png){: .align-center }

A continuación, antes de iniciar la máquina, podemos redefinir la información de configuración para cloud-init, en este caso, he creado un nuevo usuario con su contraseña, he añadido mi clave pública ssh, y he configurado la red de forma estática:

![proxmox + cloud-init]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/10/cloudinit6.png){: .align-center }

Es muy recomendable usar la opción **Regenarate Image** para asegurarnos que la información nueva que hemos indicado se guarda de forma correcta.

Ya podemos iniciar la nueva máquina:

![proxmox + cloud-init]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/10/cloudinit7.png){: .align-center }

Y podemos comprobar varias cosas: cloud-init ha configurado el hostname de la máquina con el nombre que habíamos asignado en Proxmox, hemos accedido con el usuario y contraseña que configuramos y se ha configurado de forma estática la máquina. Además, cloud-init ha hecho más tareas de configuración internamente.

Por último, podemos comprobar que podemos acceder a la máquina virtual usando nuestra clave ssh privada:

```
ssh jose@192.168.122.250
The authenticity of host '192.168.122.250 (192.168.122.250)' can't be established.
ECDSA key fingerprint is SHA256:rcoqTVTYdLAAN19UpgdkjnIRkgB/xA/PuBcEFyhtWQE.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
...

jose@nuevamaquina:~$ 
```

## Conclusiones

Porxmox nos ofrece un sistema de virtualización para crear máquinas virtuales y contenedores Linux. En muchas ocasiones trabajamos con plantillas de máquinas virtuales, para que a partir de ellas, podamos crear nuevas máquinas. El problema que tenemos es que todas las máquinas clonadas tienen la misma configuración. Si usamos cloud-init tenemos una forma sencilla de configurar cada máquina virtual clonada con datos concretos que hagan diferentes a las máquinas.

cloud-init es es estándar para la configuración inicial de las instancias en los proveedores de cloud computing. Y como hemos visto en este artículo también lo podemos usar en nuestro sistema de virtualización Proxmox.




