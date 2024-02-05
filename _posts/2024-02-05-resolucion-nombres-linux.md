---
title: 'Resolución de nombres en sistemas Linux'
permalink: /2024/02/resolucion-nombres-linux/
tags:
  - dns
  - Linux
  - Manuales
---

Los diferentes servicios que nos ofrecen la posibilidad de resolver nombres de dominio a direcciones IP dentro de un sistema operativo GNU/Linux ha ido evolucionando a lo largo del tiempo. En este artículo quiero introducir la situación actual acerca de este tema, y presentar los distintos servicios involucrados en la resolución de nombres.

## Conceptos relacionados con la la resolución de nombres de dominio

* DNS
* Resolución estática
* NSS

Plugins de NSS (https://wiki.archlinux.org/title/Domain_name_resolution)

* files: reads the /etc/hosts file, see hosts(5)
* dns: the glibc resolver which reads /etc/resolv.conf, see resolv.conf(5)
* mdns

systemd provides three NSS services for hostname resolution:


* nss-resolve(8) — a caching DNS stub resolver, described in systemd-resolved
* nss-myhostname(8) — provides local hostname resolution without having to edit /etc/hosts
* nss-mymachines(8) — provides hostname resolution for the names of local systemd-machined(8) containers

## Cómo funcionan la resolución de nombres de dominio


systemd-resolved puede actuar como un proveedor de servicios de resolución de nombres para nss. 




https://www.freedesktop.org/software/systemd/man/latest/nss-resolve.html
nss-resolve is a plug-in module for the GNU Name Service Switch (NSS) functionality of the GNU C Library (glibc) enabling it to resolve hostnames via the systemd-resolved(8) local network name resolution service. It replaces the nss-dns plug-in module that traditionally resolves hostnames via DNS.

<!--more-->


## Conclusiones

https://medium.com/@gabber12/explained-domain-name-resolutions-c85cd1acff91
https://nelsonslog.wordpress.com/2016/10/29/ubuntu-name-lookup-dns-vs-nss/
https://wiki.archlinux.org/title/Domain_name_resolution