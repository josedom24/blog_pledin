---
title: 'Configuración automática de una máquina virtual de Proxmox con cloud-init'
permalink: /2022/10/proxmox-cloud-init/
tags:
  - Virtualización
  - Proxmox
  - cloud-init
---

![Pull Requests]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2022/10/proxmox_cloudinit.png){: .align-center }

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


