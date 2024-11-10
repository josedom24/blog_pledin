---
title: 'Configuración mínima de cloud-init'
tags: 
  - OpenStack
  - Cloud Computing
  
---
Dejo aquí apuntada (para que no se me olvide) una configuración mínima de cloud-init, que puedo usar en la creación de instancias de OpenStack para actualizar los paquetes y asignar contraseñas a los usuarios.

```sh
#cloud-config
# Actualiza los paquetes
package_update: true
package_upgrade: true
# Cambia las contraseña a los usuarios creados
chpasswd:
  expire: False
  users:
    - name: root
      password: newpassword
      type: text
    - name: debian
      password: otrapassword
      type: text
```

