---
title: 'nip.io'
tags: 
  - Guacamole
  - ssh
  - Debian
---
[Guacamole](https://guacamole.apache.org/) es una aplicación web que nos permita gestionar conexiones remotas (ssh, rdp, vnc, ...). En el instituto tenemos una versión antigua de Guacamole y este año al trabajar con Debian 12 Bookworm, nos hemos dado cuenta que el servidor ssh ha cambiado su algoritmo de encriptación y por lo tanto hay que realizar un cambio en la configuración para seguir conectando por ssh desde guacamole. Para ell en el fichero `/etc/ssh/sshd_config` tenemos que añadir las siguientes líneas:

```
PubkeyAcceptedKeyTypes +ssh-rsa
HostKeyAlgorithms +ssh-rsa
```


