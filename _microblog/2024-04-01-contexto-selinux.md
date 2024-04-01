---
title: 'Contextos de seguridad SELinux'
tags: 
  - SELinux
  - Podman

---
Estoy trabajando en los últimos días con Podman, y me estoy peleando un poco con SELinux. Dejo aquí algunos comandos que pueden ser útiles si te inicias en este sistema de seguridad:

* Para mostrar el contexto de seguridad SELinux de un directorio:

  ```
  $ ls -dZ /home/usuario/web
  ```

* Para cambiar el contexto de seguridad SELinux de un directorio:

  ```
  sudo chcon -Rv unconfined_u:object_r:httpd_user_content_t:s0 /home/usuario/web
  ```

