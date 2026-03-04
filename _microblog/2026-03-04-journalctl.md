---
title: 'Dominando journalctl: Filtra logs como un pro con Unidades y Tags'
tags: 
  - journalctl
  - logs
---

`journalctl` es la herramienta de línea de comandos que permite consultar y administrar de forma centralizada todos los registros (logs) del sistema y de los servicios gestionados por **systemd** en Linux.

En `journalctl`, una etiqueta o **tag** (técnicamente llamado `SYSLOG_IDENTIFIER`) es el nombre breve que identifica al programa o servicio que ha generado un mensaje, permitiendo filtrar rápidamente los logs por su procedencia.

Podemos leer los dos logs de dos formas distintas:

* **`journalctl -u` (Unit):** Se usa para filtrar por una **unidad de systemd** (normalmente archivos `.service`). Es ideal cuando quieres ver todo lo que ha pasado con un demonio específico (arranque, paradas y errores), como por ejemplo `apache2`, `mysql` o `nginx`.
* **`journalctl -t` (Tag/Identifier):** Se usa para filtrar por el **identificador de syslog** (`SYSLOG_IDENTIFIER`). Es ideal para localizar mensajes enviados por scripts personalizados, comandos manuales (usando `logger`) o aplicaciones que no tienen un servicio propio pero "firman" sus logs con un nombre.

Para ver qué etiquetas (**SYSLOG_IDENTIFIER**) tienes disponibles y cuáles puedes usar para filtrar, el comando más directo y limpio es el siguiente:

```bash
sudo journalctl -F SYSLOG_IDENTIFIER
```

