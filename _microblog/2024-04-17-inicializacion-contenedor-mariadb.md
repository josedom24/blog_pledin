---
title: 'Inicialización de un contenedor con mariadb'
tags: 
  - Docker
  - Podman
  - Contenedor
  - mariadb
---

En la [documentación](https://hub.docker.com/_/mariadb) de la imagen `mariadb` encontramos que para inicializar la base de datos al crear un contenedor podemos copiar un fichero con extensión `sql` (por ejemplo, `schema.sql`) con las instrucciones SQL para la creación de las tablas de la base de datos en el directorio `/docker-entrypoint-initdb.d`. Podemos usar un fichero `Dockerfile` con el siguiente contenido:
```
FROM docker.io/mariadb:10.5
COPY schema.sql /docker-entrypoint-initdb.d/
ENV MARIADB_DATABASE=nombre_basedatos
ENV MARIADB_ROOT_PASSWORD=contraseña_root
ENV MARIADB_USER=usuario
ENV MARIADB_PASSWORD=password
```

