---
title: 'Habilitar IP Forwarding en Debian 13'
tags: 
  - Linux
  - Debian
---

En **Debian 13 (Trixie)** el *IP forwarding* ya no se configura en `/etc/sysctl.conf`, sino en un archivo bajo `/etc/sysctl.d/`.

1. Crea `/etc/sysctl.d/99-forward.conf` con:

   ```
   net.ipv4.ip_forward=1  
   net.ipv6.conf.all.forwarding=1  
   ```

2. Aplica y reinicia servicios:

   ```bash
   sudo sysctl --system
   sudo systemctl restart systemd-sysctl
   ```

Con esto el reenvío queda habilitado de forma persistente.
