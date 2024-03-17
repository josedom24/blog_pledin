---
title: 'Configuración Guacamole - Debian 12'
tags: 
  - Guacamole
  - ssh
  - Debian
---
[Guacamole](https://guacamole.apache.org/) es una aplicación web que nos permite gestionar conexiones remotas (ssh, rdp,...). En el instituto tenemos una versión antigua de Guacamole y este año al trabajar con Debian 12 Bookworm, nos hemos dado cuenta que el servidor ssh ha cambiado su algoritmo de encriptación y por lo tanto hay que realizar un cambio en su configuración para seguir conectando por ssh desde guacamole. Para ello, en el fichero `/etc/ssh/sshd_config` tenemos que añadir las siguientes líneas:

```
PubkeyAcceptedKeyTypes +ssh-rsa
HostKeyAlgorithms +ssh-rsa
```


