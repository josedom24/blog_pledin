---
title: 'Instalación de instancias OpenStack desde imágenes ISO'
permalink: /2023/02/openstack-install-iso/
tags:
  - OpenStack
  - Virtualización
  - Cloud Computing
---

![openstack]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/02/openstack-wide.png){: .align-center }


De forma general cuando usamos un software que proporciona infraestructura en la nube (**IaaS**) como puede ser OpenStack, creamos las instancias a partir de imágenes de sistemas operativo preconfigurados. La propia filosofía de Cloud Computing, la posibilidad de obtener infraestructura bajo demanda y de una manera ágil, nos lleva a esta manera de trabajar en estos sistemas.

Sin embargo, en determinadas ocasiones, por ejemplo desde el punto de vista educativo, puede ser interesante realizar una instalación manual de una instancia a partir de una imagen ISO. En este artículo vamos a ver los pasos que tendríamos que dar en OpenStack para realizar una instalación de este tipo.

## Pasos iniciales

Vamos a realizar este ejemplo utilizando el cliente de línea de comandos de Openstack (OSC), sin embargo, si estás familiarizado con el dashboard de OpenStack, los pasos también se pueden realizar desde Horizon.

En primer lugar, tenemos que tener un fichero de imagen ISO en nuestro catálogo de imágenes:

```
$ openstack image show "Debian 11 ISO"
...
| disk_format      | iso                                                   
...
```
<!--more-->

## Creación de la instancia de instalación

Para realizar la instalación desde la imagen ISO vamos a realizar los siguientes pasos:

1. Creación de la instancia de instalación. OpenStack soporta el arranque de instancias utilizando imágenes ISO, por lo tanto, vamos a crear una instancia a partir de la imagen ISO:

	```
	$ openstack server create --image "Debian 11 ISO" --network "red de josedom" --flavor m1.normal instancia_instalador
	```

	La imagen  `Debian 11 ISO` es la imagen ISO, además hemos indicado la red a la que se conecta y el sabor de la instancia.

2. Vamos a crear un volumen que conectaremos posteriormente a la instancia como disco principal, donde se realizará la instalación del sistema operativo:

	```
	$ openstack volume create --size 5 --bootable disco_debian
	$ openstack server add volume instancia_instalador disco_debian --device /dev/vda
	```

3. A continuación accedemos a una *Consola* de la instancia y procedemos a la instalación manual del sistema. 

	![openstack]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2023/02/install-openstack.png){: .align-center }

## Hacer funcionales la instancia instalada desde la imagen ISO

Una vez terminada la instalación, la instancia que hemos creado no nos sirve para nada. Al reiniciar la instancia volverá a iniciar el instalador de Debian. Lo que realmente nos interesa es el volumen donde hemos realizado la instalación. Por lo tanto podemos borrar la instancia sin problemas:

```
$ openstack server delete instancia_instalador
```

A continuación tendremos el volumen con el sistema operativo desasociado:

```
$ openstack volume list
...
| 2c788674-ed40-450f-a8b2-a7659a5cfba4 | disco_debian | available |    5 |                               ...
```

Y tenemos varios opciones para trabajar con él:

1. Crear una instancia a partir de este volumen. Tendríamos una instancia con el sistema operativo que acabamos de instalar, para ello:

	```
	openstack server create --flavor vol.normal \
 	--volume disco_debian \
 	--security-group default \
 	--network "red de josedom" \
 	instancia_prueba
	```

2. Convertir el volumen en una imagen, para poder crear instancias a partir de ella. Podríamos crear distintas instancias con el sistema operativo que hemos instalado. Para ello:

	```
	openstack image create --volume disco_debian nueva_imagen_debian_11
	```

	Y podemos comprobar que hemos creado una nueva imagen desde la que podemos crear nuevas instancias:

	```
	$ openstack images list
	...
	| 447968c9-c2d6-4ad7-8526-d3fc4be26325 | nueva_imagen_debian_11   | active |
	...
	```

## Conclusiones

En determinados escenarios, por ejemplo si tenemos algún sistema operativo que no tengamos una imagen preconfigurada para OpenStack, o en entornos educativos, como indicábamos anteriormente, la posibilidad de arrancar una instancia en OpenStack a partir de una imagen ISO nos brinda la posibilidad de realizar una instalación personalizada de nuestros sistemas.

Como siempre para seguir profundizando podemos estudiar la documentación oficial de OpenStack: [Launch an instance using ISO image](https://docs.openstack.org/nova/rocky/user/launch-instance-using-ISO-image.html).
