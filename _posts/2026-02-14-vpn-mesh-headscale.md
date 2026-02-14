---
title: 'Construcción de VPN mesh con tailscale/headscale'
permalink: /2026/02/vpn-mesh-headscale/
tags:
  - VPN
  - Headscale
  
---
![vpn](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2026/02/headscale.png){: .align-center }

**Tailscale** es una VPN de **red en malla (mesh)** basada en el protocolo **WireGuard**. A diferencia de las VPN tradicionales (donde todo el tráfico pasa por un servidor central), en una red mesh los dispositivos establecen conexiones directas **punto a punto ()** entre sí. Para lograr esto, utiliza técnicas de **NAT Traversal**, permitiendo que los nodos se comuniquen aunque estén detrás de firewalls o routers sin necesidad de abrir puertos manualmente.

La arquitectura de Tailscale se divide en dos capas:

* **Control Plane:** Es el "cerebro" de la red. No toca tus datos; su función es autenticar usuarios, intercambiar las llaves públicas de cifrado y distribuir la tabla de rutas a todos los nodos.
* **Data Plane:** Es el tráfico real cifrado que fluye directamente entre los dispositivos una vez que el Control Plane los ha "presentado".

Tailscale opera bajo un modelo **Open Core**: el software del cliente (lo que instalas en tus dispositivos) es de código abierto, pero el servidor de coordinación (Control Plane) es software propietario alojado en su nube.

**Headscale** es la alternativa libre y **autoalojable (self-hosted)** al Control Plane oficial. Es un proyecto de código abierto que implementa las mismas APIs, permitiéndote:

1. Mantener la soberanía total sobre tus metadatos y la gestión de la red.
2. Utilizar los **clientes oficiales de Tailscale** simplemente apuntándolos a tu propia instancia.
3. Eliminar los límites de usuarios o dispositivos de los planes comerciales.

## Instalación de Headscale

Para que Headscale pueda coordinar las conexiones entre todos tus dispositivos, necesitamos alojarlo en una máquina que actúe como punto de encuentro permanente. A diferencia de los nodos de la VPN, que pueden entrar y salir de la red o cambiar de ubicación, el servidor de Headscale debe ser el ancla de la infraestructura.

### Características de la máquina

El servidor donde instales Headscale (normalmente un VPS o un servidor dedicado) debe cumplir con tres condiciones fundamentales para garantizar la estabilidad de la red:

* **Accesibilidad Global:** La máquina debe tener una **IP pública estática** o un nombre de dominio (FQDN) asociado. Esto permite que cualquier nodo, esté donde esté, pueda localizar el Control Plane para solicitar instrucciones de conexión.
* **Seguridad mediante HTTPS:** Es obligatorio que el tráfico entre los clientes y Headscale viaje cifrado. Necesitarás un certificado SSL (puedes usar Let's Encrypt) para que la comunicación se realice de forma segura a través del puerto **443**.
* **Disponibilidad (Uptime):** Si el servidor de Headscale se apaga, los nodos nuevos no podrán unirse y los existentes no podrán actualizar sus tablas de rutas si hay cambios en la red.

Para una configuración básica y funcional, no es necesario complicar el firewall. Según la [documentación oficial de requisitos de Headscale](https://headscale.net/stable/setup/requirements/), solo necesitas asegurar la apertura de los siguientes puertos:

* **443/tcp**:Tráfico de control (API) y autenticación mediante **HTTPS**. 
* **80/tcp**: Generalmente usado para la validación de certificados (Let's Encrypt).

Headscale es extremadamente ligero. Para una red pequeña o mediana, una máquina con **1 vCPU y 1 GB de RAM** es más que suficiente para gestionar el panel de control.

<!--more-->

En la página anterior puedes encontrar distintos métodos de instalación, en este artículo utilizaremos un contenedor Docker para realizar la instalación, para ello y siguiendo la documentación [Running headscale in a container](https://headscale.net/stable/setup/install/container/):

```
mkdir -p ./headscale/{config,lib}
cd headscale
```

Bajamos el fichero de configuración por defecto según la versión con la que vamos a trabajar, podemos encontrar las instrucciones para descargarlo en la [documentación](https://headscale.net/stable/ref/configuration/). En este caso usamos la versión 0.28.0:

```
cd config
curl -o config.yaml https://raw.githubusercontent.com/juanfont/headscale/v0.28.0-beta.2/config-example.yaml
```

A continuación modificamos la configuración para que el servidor escuche en todos las direcciones, para ello en el fichero `config/config.yaml` modificamos el siguiente parámetro de la siguiente forma:

```
listen_addr: 0.0.0.0:8080
``` 

Ahora creamos el fichero `docker-compose.yaml`:

```
services:
  headscale:
    image: docker.io/headscale/headscale:${HEADSCALE_VERSION}
    restart: unless-stopped
    container_name: headscale
    read_only: true
    tmpfs:
      - /var/run/headscale
    ports:
      - "127.0.0.1:8080:8080"
      - "127.0.0.1:9090:9090"
    volumes:
      - ${HEADSCALE_PATH}/config:/etc/headscale:ro
      - ${HEADSCALE_PATH}/lib:/var/lib/headscale
    command: serve
    healthcheck:
        test: ["CMD", "headscale", "health"]
```

Y el fichero `.env`:

```
# La versión de headscale que deseas utilizar
HEADSCALE_VERSION=0.28.0

# La ruta absoluta a tu directorio de headscale
HEADSCALE_PATH=.
```

Iniciamos el contenedor y comprobamos que funciona:

```
 docker-compose up -d
Starting headscale ... done

curl http://127.0.0.1:8080/health
{"status":"pass"}
```

Ahora configuramos el proxy inverso, para ello tenemos ejemplos de configuración en [Running headscale behind a reverse proxy](https://headscale.net/stable/ref/integration/reverse-proxy/). Y comprobamos que funciona:

```
curl https://vpn.example.org/health
{"status":"pass"}
```

Finalmente cambiamos el parámetro de la configuración para indicar la url de acceso, para ello en el fichero `config/config.yaml` modificamos:

```
server_url: https://vpn.example.org
```

Reiniciamos el contenedor:

```
docker-compose restart
```

## Creación de usuarios

En Headscale, un **usuario** es una entidad lógica que agrupa un conjunto de dispositivos.

* Los dispositivos que pertenecen al mismo usuario pueden verse entre sí de forma predeterminada.
* Sirve para aislar entornos: puedes tener un usuario para tus dispositivos personales y otro para servidores de trabajo, manteniendo las redes separadas dentro de la misma instancia de Headscale.

No puedes registrar ningún nodo (dispositivo) en Headscale si no existe al menos un usuario al que asignárselo. Para crear tu primer usuario (por ejemplo, "mi-red"), utiliza el siguiente comando:

```
docker exec headscale headscale users create vpn1
User created

docker exec headscale headscale users list
ID | Name | Username | Email | Created            
1  |      | vpn1     |       | 2026-02-13 
``` 

Podemos eliminar un usuario ejecutando:

```
docker exec headscale headscale users destroy vpn1
```

En este caso se realiza una limpieza total de los recursos asociados a esa identidad:

* **Eliminación de Nodos**: Todos los dispositivos (nodos) registrados bajo ese usuario son expulsados de la red inmediatamente.
* **Revocación de Claves**: Las claves de cifrado y los certificados asociados a esos nodos quedan invalidados.

## Registro de Nodos: conectando tus dispositivos

Una vez que el servidor está listo y el usuario creado, el siguiente paso es registrar los dispositivos (nodos). Mientras que **Headscale** opera exclusivamente en el **Control Plane** (gestionando la lógica de red y la distribución de llaves), la conectividad efectiva requiere el despliegue del cliente oficial de **Tailscale** en cada nodo. Este cliente actúa en el **Data Plane**, integrándose con el stack de red del sistema operativo a través de una interfaz virtual **TUN** y gestionando el cifrado y encapsulamiento de paquetes mediante **WireGuard**.

Puedes instalar el cliente de Tailscale en prácticamente cualquier sistema operativo moderno (Windows, macOS, Android, iOS, etc.), cuyas descargas están disponibles en la [página oficial de Tailscale](https://tailscale.com/download).

Para este artículo, nos centraremos en **Linux**, donde la instalación es tan sencilla como ejecutar su script automatizado:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

Una vez que el cliente de Tailscale está instalado en el nodo, debemos vincularlo al **Control Plane** de Headscale. Existen dos **métodos de registro** principales para realizar esta tarea.

### Método interactivo

Este es el método estándar para estaciones de trabajo o dispositivos con intervención humana. El flujo se basa en un desafío-respuesta manual:

* **Solicitud de registro:** En el nodo cliente, se inicia la conexión apuntando a nuestra instancia:
* **Desafío:** El cliente no podrá autenticarse automáticamente y devolverá una URL de registro.
* **Autorización:** Al abrir esa URL, Headscale mostrará un comando preformateado que incluye la `nodekey`. Debes ejecutar ese comando en el **servidor Headscale** para validar el nodo y asignarlo a un usuario:

Veamos un ejemplo:

Desde el cliente solicitamos el registro:
``` 
sudo tailscale up --login-server https://vpn.example.org

To authenticate, visit:

        https://vpn.example.org/register/STqfQR4wnKr-eerDXam3_RYi
``` 

Abrimos el enlace en un navegador web y nos dará la instrucción (que incluye el `nodekey`) que tenemos que ejecutar en Headscale para autorizar el dispositivo:

```
headscale nodes register --key STqfQR4wnKr-eerDXam3_RYi --user USERNAME
``` 

En nuestro caso, ejecutamos:

```
docker exec headscale headscale nodes register --key STqfQR4wnKr-eerDXam3_RYi --user vpn1
Node registered
```

En headscale podemos ver los nodos registrados:

```
docker exec headscale headscale nodes list
ID | Hostname | Name    | MachineKey | NodeKey | User | Tags | IP addresses                  | Ephemeral | Last seen           | Expiration | Connected | Expired
1  | penguin  | nodo1  | [qatKd]    | [fMe1N] | vpn1 |      | 100.64.0.1, fd7a:115c:a1e0::1 | false     | 2026-02-13 18:09:45 | N/A        | online    | no     ``` 
```

Y podemos comprobar que el cliente tiene la ip asignada en la VPN:

```
ip addr show tailscale0
2: tailscale0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1280 qdisc pfifo_fast state UNKNOWN group default qlen 500
    link/none 
    inet 100.64.0.1/32 scope global tailscale0
       valid_lft forever preferred_lft forever
    inet6 fe80::c26f:e628:12cb:72c9/64 scope link stable-privacy 
       valid_lft forever preferred_lft forever
```

### Método no interactivo

Para despliegues automatizados, contenedores o servidores donde no queremos realizar una validación manual, Headscale permite el uso de **Pre-Auth Keys**.

* **Generación de la clave:** Primero, generamos un token de autorización en el servidor Headscale asociado a un usuario específico:
* **Registro automático:** Usamos esa clave en el nodo cliente para completar el registro en un solo paso, sin necesidad de confirmación manual en el servidor:

Veamos un ejemplo:

En primer lugar generamos la clave en el Control Plane:

```
docker exec headscale headscale preauthkeys create --user 1 --reusable
hskey-auth-Db1RF5n7gSk3-NzIu0vDgXi8yewFjq5w4rczR-uZD-J_RfYnUDSjCmrgRHKXnGaXj_HK3jJfvnhk0
``` 

Con el parámetro `--reusable` la clave se puede usar varias veces, si no se pone, la clave solo se puede usar una vez. 

Podemos usar el parámetro `--expiration 24h` para que la clave expire en 24 horas (por defecto, solo dura una hora), o `--ephemeral` para que la clave expire cuando el dispositivo se desconecte.

Con el parámetro `--user` debemos indicar el ID del usuario.

Y luego la usamos para conectar el cliente:

```
sudo tailscale up --login-server https://vpn.example.org --authkey hskey-auth-Db1RF5n7gSk3-NzIu0vDgXi8yewFjq5w4rczR-uZD-J_RfYnUDSjCmrgRHKXnGaXj_HK3jJfvnhk0
```

Y comprobamos que el cliente se ha conectado:

```
docker exec headscale headscale nodes list
ID | Hostname | Name    | MachineKey | NodeKey | User | Tags | IP addresses                  | Ephemeral | Last seen           | Expiration          | Connected | Expired
1  | penguin  | nodo1 | [qatKd]    | [fMe1N] | vpn1 |      | 100.64.0.1, fd7a:115c:a1e0::1 | false     | 2026-02-13 18:09:45 | N/A                 | online    | no     
2  | hoth     | nodo2 | [G1VUT]    | [9wBm+] | vpn1 |      | 100.64.0.2, fd7a:115c:a1e0::2 | false     | 2026-02-13 18:30:17 | 0001-01-01 00:00:00 | online    | no     
```

## Comprobación de la conectividad

Con los nodos registrados y visibles en el listado de Headscale, la red mesh ya está construida. Ahora debemos verificar que el tráfico fluye correctamente entre ellos utilizando las herramientas que proporciona el ecosistema de Tailscale.

### El comando `status` en el cliente

Desde cualquier nodo (por ejemplo, desde `nodo1`), podemos verificar cómo ve este a sus "pares" (peers) en la red:

```bash
tailscale status
tailscale status
100.64.0.1  nodo1  vpn1  linux  -                      
100.64.0.2  nodo2  vpn1  linux  idle, tx 468 rx 348 
```

Este comando te mostrará una lista de los demás dispositivos de tu usuario, su dirección IP interna y las características de la conexión.

### Prueba de latencia con `tailscale ping`

Aunque el `ping` tradicional funciona, Tailscale ofrece una herramienta especializada que nos indica cómo se está realizando la conexión:

```bash
tailscale ping nodo2
pong from nodo2 (100.64.0.2) via DERP(mad) in 777ms
pong from nodo2 (100.64.0.2) via DERP(mad) in 18ms
pong from nodo2 (100.64.0.2) via DERP(mad) in 16ms
pong from nodo2 (100.64.0.2) via 143.47.53.108:41641 in 13ms
```

A diferencia del ping estándar, este comando te informará si ha logrado establecer una **conexión directa P2P** (atravesando con éxito el NAT) o si está usando un servidor intermedio. Es la prueba definitiva de que el **Data Plane** está operando de forma óptima.

Cualquier servicio que levantes en el puerto 80, 22 o cualquier otro en `nodo2` será accesible desde `nodo1` (y viceversa) de forma totalmente cifrada y privada, como si estuvieran conectados al mismo switch físico.

## Conclusión

La implementación de **Headscale** como plano de control (*Control Plane*) independiente permite explotar todo el potencial del protocolo **WireGuard** sin las limitaciones de un modelo SaaS propietario. Al desacoplar la gestión de identidades y la distribución de rutas de la infraestructura de Tailscale, hemos consolidado una red mesh con **topología dinámica** capaz de garantizar comunicaciones **P2P cifradas** con una sobrecarga (*overhead*) mínima. Esta arquitectura no solo optimiza el rendimiento mediante la negociación directa de túneles tras entornos de NAT complejo, sino que establece un entorno de **Zero Trust** donde la soberanía de los metadatos y la integridad del tráfico permanecen bajo control absoluto del administrador.

