---
title: 'Configuración del enrutamiento y DNS en una VPN tailscale/headscale'
permalink: /2026/02/vpn-mesh-headscale-rutas-dns/
tags:
  - VPN
  - Headscale
  
---
![vpn](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2026/02/headscale2.png){: .align-center }

En el post anterior, [Construcción de VPN mesh con tailscale/headscale](https://www.josedomingo.org/pledin/2026/02/vpn-mesh-headscale/), logramos conectar varios dispositivos mediante una VPN mesh.

En este artículo, profundizaremos en tres capacidades críticas que transforman una red privada virtual en una solución de conectividad integral:

* **Subnet Routers:** Implementaremos el concepto de **VPN Site-to-Site**, permitiendo que nodos específicos actúen como *gateways* para exponer subredes completas (LAN) a la malla, integrando así dispositivos sin capacidad de instalar software (como impresoras, servidores NAS,...).
* **Exit Nodes:** Configuraremos nodos de salida para centralizar el tráfico de internet de la red mesh, permitiendo una navegación segura y controlada a través de un punto de confianza (similar a una VPN de acceso remoto tradicional).
* **Split DNS y Global Nameservers:** Optimizaremos la resolución de nombres dentro de la red mediante la integración de DNS internos, facilitando el acceso a servicios mediante FQDNs en lugar de direcciones IP estáticas.

## Subnet Router

Un **Subnet Router** es un nodo de nuestra red que actúa como pasarela, permitiendo que el resto de los dispositivos de la VPN "salten" a una red local física (por ejemplo, la red de tu oficina o de tu casa). Cualquier nodo Linux en el que ya tengas Tailscale funcionando puede servir como Subnet Router.

El escenario desde el que partimos es el siguiente:

```
docker exec headscale headscale nodes list
ID | Hostname | Name    | MachineKey | NodeKey | User | Tags | IP addresses                  | Ephemeral | Last seen           | Expiration          | Connected | Expired
1  |  nodo1   | nodo1   | [qatKd]    | [fMe1N] | vpn1 |      | 100.64.0.1, fd7a:115c:a1e0::1 | false     | 2026-02-13 18:09:45 | N/A                 | online    | no     
2  |  nodo2   | nodo2   | [G1VUT]    | [9wBm+] | vpn1 |      | 100.64.0.2, fd7a:115c:a1e0::2 | false     | 2026-02-13 18:30:17 | 0001-01-01 00:00:00 | online    | no     
3  |  nodo3   | nodo3   | [asFdw]    | [8qDba] | vpn1 |      | 100.64.0.3, fd7a:115c:a1e0::3 | false     | 2026-02-13 18:35:17 | 0001-01-01 00:00:00 | online    | no     
```

<!--more-->

Vamos a suponer que el `nodo2` es el **Subnet Router**. Para configurar este nodo lo primero es habilitar el reenvío de paquetes en ese nodo, para ello activamos el bit de forwarding en `nodo2`:

```
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Anuncio de las rutas de encaminamiento

A continuación, el `nodo2` tiene que **anunciar la ruta**, suponemos que la red local a la que nos da acceso el `nodo2` es la `192.168.18.0/24`. Para anunciar la ruta de encaminamiento que permita a los otros nodos acceder a dicha red, ejecutamos en `nodo2`:

```
sudo tailscale up --login-server https://vpn.example.org --advertise-routes=192.168.18.0/24
```

Si el nodo ya estaba iniciado:

```
sudo tailscale set --advertise-routes=192.168.18.0/24
```

Podemos comprobar que el nodo está anunciando nuevas rutas desde el servidor Headscale, ejecutando:

```
docker exec headscale headscale nodes list-routes
ID | Hostname | Approved        | Available       | Serving (Primary)
2  | nodo2    | 192.168.18.0/24 | 192.168.18.0/24 |   
```

### Aprobación de las rutas de encaminamiento

Por seguridad, Headscale no permite que un nodo "inyecte" rutas en la red mesh sin permiso del administrador. Tenemos dos formas de aprobar la ruta anunciada: de forma manual o de forma automática.

La **forma automática** está pensada cuando tenemos pensado añadir muchos nodos o redes. Headscale permite definir reglas de "auto-aprobación" en su configuración, modificando el archivo de configuración `config.yml` como nos indica la [documentación](https://headscale.net/stable/ref/routes/#automatically-approve-routes-of-a-subnet-router).

En nuestro caso estudiaremos la **aprobación manual**. Desde el servidor Headscale, ejecutamos la siguiente instrucción para habilitar la ruta que se está anunciando:

```
docker exec headscale headscale nodes approve-routes --identifier 2 --routes 192.168.18.0/24
```

Si volvemos a ver las rutas desde el servidor, comprobamos que se ha aprobado:

```
docker exec headscale headscale nodes list-routes
ID | Hostname | Approved        | Available       | Serving (Primary)
2  | nodo2    | 192.168.18.0/24 | 192.168.18.0/24 | 192.168.18.0/24
```

### Configuración de la ruta de encaminamiento en el cliente

Una vez que la ruta está aprobada en el servidor, los clientes (nodos) de la VPN ya saben que esa red existe, pero los clientes Linux son precavidos y **no** la añadirán a su tabla de rutas local a menos que se lo pidas. Por ejemplo en el `nodo1` ejecutamos:

```
sudo tailscale up    --login-server=https://vpn.example.org
```

Si el cliente ya está iniciado, podemos ejecutar:

```
sudo tailscale set --accept-routes
```

En dispositivos en otros sistemas operativos, este paso no suele ser necesario, ya que el cliente oficial acepta las rutas del servidor automáticamente.

### Verificación de la conectividad

Desde el nodo `nodo1` hacemos ping a un dispositivo de la red local que **no** tenga Tailscale instalado:

```bash
ping 192.168.18.1  # La IP del router de tu casa
64 bytes from 192.168.18.1: icmp_seq=1 ttl=63 time=50.6 ms
```

Veamos donde se declara la ruta de encaminamiento. Tailscale crea una nueva tabla de encaminamiento para introducir las rutas que necesita, para ver las tablas de encaminamiento ejecutamos: `ip rule show`. Entre varias tablas que encontramos, tenemos que tener en cuenta que la tabla de encaminamiento por defecto se llama **main** y la tabla de encaminamiento de Tailscale es la llamada **52**. Por lo tanto si vemos las rutas de esta tabla, encontramos la ruta de encaminamiento que hemos aceptado:

```
ip route show table 52
... 
192.168.18.0/24 dev tailscale0 
```

## Exit Node

Por defecto, Tailscale solo encamina a través de la VPN el tráfico destinado a otros nodos de tu red. El resto del tráfico (tu navegación por internet) sale por la conexión local del dispositivo en el que estás.

Al configurar un **Exit Node**, puedes indicar a tus dispositivos que **todo** su tráfico de internet pase primero por un nodo específico de la VPN antes de salir a la red pública. Esto es ideal para:

* Navegar de forma segura desde redes Wi-Fi públicas sospechosas.
* Acceder a servicios que solo permiten IPs de un país determinado (si tienes el Exit Node allí).
* Centralizar el filtrado de tráfico en un solo punto.

### Anuncio del exit node

En nuestro ejemplo, vamos a configurar como **exit node** nuestro nodo `nodo3`. Lo primero activaremos el bit de forwarding en ese nodo:

```
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

Una vez preparado, le indicamos que se anuncie como nodo de salida:

```bash
sudo tailscale up --login-server https://vpn.example.org --advertise-exit-node
```

Si el nodo ya está funcionando, podemos ejecutar:

```
sudo tailscale set --advertise-exit-node
```

Podemos comprobar que el nodo está anunciando nuevas rutas desde el servidor Headscale, ejecutando:

```
docker exec headscale headscale nodes list-routes
ID | Hostname | Approved        | Available       | Serving (Primary)
2  | nodo2    | 192.168.18.0/24 | 192.168.18.0/24 | 192.168.18.0/24
3  | nodo3    | 0.0.0.0/0       | 0.0.0.0/0       |         
   |          | ::/0            | ::/0            |     
```

### Aprobación del exit node

Al igual que con los subnet routers, ahora debemos aprobar la ruta por defecto desde el servidor Headscale. A aunque podemos hacerlo de [forma automática](https://headscale.net/stable/ref/routes/#automatically-approve-an-exit-node-with-auto-approvers), vamos a ver el procedimiento manual. Para ello ejecutamos desde el servidor Headscale:

```
docker exec headscale headscale nodes approve-routes --identifier 3 --routes 0.0.0.0/0,::/0
```

Y volvemos a comprobar las rutas aprobadas:

```
docker exec headscale headscale nodes list-routes
ID | Hostname | Approved        | Available       | Serving (Primary)
2  | nodo2    | 192.168.18.0/24 | 192.168.18.0/24 | 192.168.18.0/24
3  | nodo3    | 0.0.0.0/0       | 0.0.0.0/0       | 0.0.0.0/0        
   |          | ::/0            | ::/0            | ::/0     
```

### Cómo usar el Exit Node desde los clientes

Una vez aprobado, el nodo de salida  **no se usa automáticamente**. Cada cliente debe elegir activarlo. Para empezar a navegar a través del nodo de salida, ejecutamos en el `nodo1`:

```
sudo tailscale up --exit-node=nodo3 --login-server https://vpn.example.org 
```

Si el nodo ya está funcionando, ejecutamos:

```
sudo tailscale set --exit-node nodo3
```

En las aplicaciones oficiales de otros sistemas operativos, aparecerá una nueva opción en el menú llamada **"Exit Node"**. Al pulsarla, verás una lista de los nodos disponibles que has aprobado en el paso anterior. Solo tienes que seleccionar uno.

### Verificación del nodo de salida

Para comprobar que realmente estás saliendo a internet a través de tu nodo de confianza, puedes usar cualquier servicio de geolocalización de IPs desde tu navegador o CLI:

```bash
curl ifconfig.me
```

La dirección IP devuelta debería ser la IP pública de tu **Exit Node**, no la de la red a la que estás conectado físicamente.
Además podemos ver que se ha creado una ruta por defecto en la tabla de encaminamiento **52**:

```
ip route show table 52
default dev tailscale0 
```

## DNS y MagicDNS

Hasta ahora, nos hemos comunicado entre nodos usando direcciones IP (como `100.64.0.1`). Pero, ¿no sería mejor acceder a nuestro servidor simplemente escribiendo su nombre? Aquí es donde entra **MagicDNS** y la configuración de DNS en Headscale.

MagicDNS es una función que registra automáticamente los nombres de tus dispositivos en un servidor DNS interno gestionado por Headscale. Si tienes un nodo llamado `servidor`, MagicDNS te permitirá hacerle un ping o acceder a su web usando un nombre de dominio.

### Configuración del DNS en Headscale

Para que esto funcione, debemos editar el archivo de configuración de nuestro servidor Headscale (`config/config.yaml`). Busca la sección `dns_config` y ajústala:

```yaml
dns_config:
  # El dominio base para tu red mesh
  magic_dns: true
  base_domain: vpn.example.org

  # Servidores DNS que usarán los nodos para resolver internet
  nameservers:
    - 1.1.1.1
    - 1.0.0.1
...
```

* **magic_dns: true**: Activa la resolución automática de nombres de nodos.
* **base_domain**: Es el nombre de dominio que vamos a usar. En nuestro caso `vpn.example.org`.
* **nameservers**: Servidores DNS que se usan para resolver otros dominios.

Tras cambiar el fichero, recuerda reiniciar el contenedor:
`docker-compose restart headscale`

Con esta configuración tenemos un servidor DNS en la dirección `100.100.100.100` que resolverá los nombres de nuestros nodos de la VPN usando el dominio configurado y que funciona como DNS forward para resolver otros nombres.

Podemos comprobar la configuración del servidor DNS de uno de nuestro nodos:

```
cat /etc/resolv.conf

nameserver 100.100.100.100
search vpn.example.org
```

Y podemos acceder a los nodos usando su nombre FQDN o hostname, ya que tenemos configurado el parámetro `search`:

```
ping nodo2
PING nodo2.vpn.example.org (100.64.0.2) 56(84) bytes of data.
64 bytes from nodo2.vpn.example.org (100.64.0.2): icmp_seq=1 ttl=64 time=17.7 ms

ping nodo2.vpn.example.org
PING nodo2.vpn.example.org (100.64.0.2) 56(84) bytes of data.
64 bytes from nodo2.vpn.example.org (100.64.0.2): icmp_seq=1 ttl=64 time=17.7 ms
```

### Split DNS (DNS dividido)

Esta es una de las funciones más potentes. Imagina que tienes un servidor DNS en tu red local que solo resuelve dominios internos (ej: `*.josedomingo.org`). Puedes decirle a Headscale que **solo** las consultas para ese dominio se envíen a ese servidor.

El **Split DNS** es la capacidad de Tailscale/Headscale para actuar como un "semáforo" de peticiones DNS. En lugar de enviar todas tus consultas a un único servidor DNS, el cliente decide a quién preguntar basándose en el **dominio** de la dirección que intentas resolver.

En nuestro ejemplo, vamos a configurar un Split DNS para que las consultas de `josedomingo.org` vayan al servidor `192.168.18.3`, Para ello en la configuración de Headscale, en el fichero `config.yaml`, en la sección `dns_config`:

```yaml
dns_config:
...
  split:
    josedomingo.org:
      - 192.168.18.3
```

Recuerda que para que el cliente pueda alcanzar la IP `192.168.18.3` (que es el servidor DNS), esa IP debe estar anunciada por algún **Subnet Router** en tu red y aprobada en Headscale.

Para comprobar el funcionamiento, podemos hacer una consulta desde el `nodo1`:

```
dig home.josedomingo.org +short
192.168.18.3
```

## Conclusión

La integración de **Subnet Routers**, **Exit Nodes** y **Split DNS** transforma una red mesh básica en una infraestructura de red corporativa completa y eficiente. Esta arquitectura permite consolidar topologías **Site-to-Site** para integrar dispositivos sin agente, centralizar el tráfico de salida bajo políticas de seguridad unificadas y optimizar la resolución de nombres mediante una gestión inteligente de consultas DNS. En conjunto, estas capacidades proporcionan una abstracción de capa 3 que garantiza una conectividad transparente, segura y escalable, eliminando la complejidad del enrutamiento tradicional en entornos híbridos.

