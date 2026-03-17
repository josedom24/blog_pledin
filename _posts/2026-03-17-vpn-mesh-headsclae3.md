---
title: 'Seguridad y control de acceso en una VPN tailscale/headscale: ACLs y Tags'
permalink: /2026/03/vpn-mesh-headscale-seguridad-control-acceso
tags:
  - VPN
  - Headscale
---

 ![vpn](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2026/03/headscale3.png)

Hasta ahora, nuestra red mesh ha funcionado bajo una confianza total: cualquier dispositivo que uníamos a nuestra red podía comunicarse con los demás. Sin embargo, en entornos educativos o profesionales, necesitamos aplicar el principio de **mínimo privilegio**. En este artículo aprenderemos a usar las **ACLs** y los **Tags** para crear una red donde los alumnos puedan acceder a los recursos del aula, pero estén aislados entre sí.

## Conceptos claves: ACLs y Tags

* Las **ACLs (Listas de Control de Acceso)** son un conjunto de reglas en formato JSON (o HuJSON) que definen quién puede hablar con quién. Si no hay una regla que permita la conexión, Headscale la denegará por defecto.
* Los **Tags** (etiquetas) nos permiten agrupar dispositivos por su función en lugar de por su nombre o usuario. Por ejemplo, podemos etiquetar un equipo como `tag:servidor` y otros como `tag:alumno`. Cuando un dispositivo se registra con un Tag, deja de "pertenecer" al usuario que lo registró y pasa a ser propiedad del sistema, lo que facilita la gestión de permisos globales.

## Caso práctico: El Aula Aislada

Para entender los conceptos de seguridad usando ACLs y Tags vamos a ver un ejemplo concreto. en este ejemplo vamos a estudiar dos aproximaciones distintas para tener un conjunto de clientes (en nuestro caso alumnos) que acceden a una red local (en nuestro caso una red de un aula). Los objetivos a cumplir son los siguientes:

1. Los alumnos se conectan a la VPN.
2. Existe un **Router** que anuncia la red local del aula (`192.168.100.0/24`).
3. Los alumnos **pueden** acceder a los equipos de la red local.
4. Los alumnos **NO pueden** verse ni hacerse ping entre ellos.

Para conseguir dichos objetivos, vamos a estudiar dos aproximaciones distintas:

* Estrategia 1: Red Unificada con Control por Etiquetas (Tags)
* Estrategia 2: Segmentación por Usuarios (Namespaces Aislados)

<!--more-->

## Estrategia 1: Red unificada con control por Etiquetas (Tags)

Esta estrategia se basa en mantener a todos los nodos dentro de un mismo espacio compartido (el mismo usuario), pero diferenciando sus capacidades mediante el uso de **etiquetas lógicas**. Al asignar un `tag:alumno` o `tag:router`, el motor de seguridad de Headscale deja de aplicar permisos basados en quién inició sesión y pasa a aplicar reglas estrictas definidas en el archivo de política: si una regla no autoriza explícitamente que un "alumno" hable con otro, el sistema bloquea esa comunicación de forma nativa. Es la opción más escalable y profesional, ya que permite gestionar cientos de dispositivos con apenas un par de líneas de configuración centralizada, manteniendo un control granular sobre puertos y protocolos.

Lo primero que tenemos que hacer es activar la configuración de las ACLs, para ello en el fichero de configuración indicamos el fichero donde vamos a escribir nuestras ACLs, para ello en tu `config.yaml`, añadimos el parámetro `path` y reiniciamos el servicio:

```yaml
policy:
  mode: file
  path: /etc/headscale/acl.hujson
```

Headscale utiliza un formato llamado **HuJSON** (JSON con comentarios y comas finales permitidas), lo que facilita mucho su mantenimiento. El archivo de políticas se divide en bloques lógicos que el motor de Headscale procesa de arriba hacia abajo para decidir si permite o bloquea un paquete:

* Grupos (`groups`): Permiten agrupar **usuarios reales** bajo un alias. Es muy útil para no repetir nombres de personas en las reglas.
* Propietarios de Etiquetas (`tagOwners`): Esta es una sección de **seguridad crítica**. Define qué usuarios tienen permiso para asignar qué etiquetas (`tags`) a sus dispositivos. Sin esto, cualquier usuario podría etiquetarse como "servidor" para saltarse las reglas.
* Reglas de Acceso (`acls`): Es el corazón del archivo. Cada regla define una **acción**, un **origen**, y un **destino**:
  * **Action:** Actualmente solo existe `accept`. Todo lo que no esté explícitamente aceptado, se deniega (**Deny por defecto**).
  * **Src (Source):** Quién origina la conexión. Puede ser un usuario, un grupo, un tag, una IP o `*` (todos).
  * **Dst (Destination):** A qué se intenta acceder. Se define como `objetivo:puerto`.

El funcionamiento general del sistema de seguridad es el siguiente:

1. **Denegación implícita:** Si no escribes ninguna regla, ningún nodo puede hablar con nadie.
2. **Unidireccionalidad:** Las reglas definen quién inicia la conexión. Si permites que `A` conecte con `B`, Tailscale gestiona automáticamente el tráfico de retorno, pero `B` no podrá iniciar una nueva conexión hacia `A` a menos que exista otra regla.
3. **Evaluación de Tags:** Cuando un dispositivo tiene un Tag, las reglas basadas en su "usuario original" dejan de aplicarse. El Tag tiene prioridad absoluta para el control de tráfico.

A continuación ya podemos escribir nuestras políticas de seguridad, para ello creamos el archivo `acl.hujson` en nuestra carpeta de configuración de Headscale (si estamos usando docker como en los artículos anteriores este fichero sería `config/acl.hujson`):

```json
{
  // Definimos los grupos y etiquetas
  "groups": {
    "group:profesores": ["admin"]
  },

  "tagOwners": {
    "tag:router-aula": ["group:profesores"],
    "tag:alumno": ["group:profesores"]
  },

  "acls": [
    // 1. Permitir que los alumnos accedan a la red local anunciada por el router
    {
      "action": "accept",
      "src":    ["tag:alumno"],
      "dst":    ["192.168.100.0/24:*"]
    },
    // 2. Permitir que el profesor tenga acceso total (opcional)
    {
      "action": "accept",
      "src":    ["group:profesores"],
      "dst":    ["*:*"]
    }
    // NOTA: Al no haber una regla que permita "src: tag:alumno" a "dst: tag:alumno",
    // el tráfico entre alumnos queda bloqueado automáticamente.
  ]
}

```

Esta política de seguridad utiliza un modelo de **confianza cero (Zero Trust)**. Siguiendo la sintaxis de Headscale, cada bloque cumple una función específica para garantizar que los alumnos estén aislados entre sí pero tengan acceso a los recursos necesarios.

Aquí tienes la explicación detallada de cada sección:

* **Definición de Roles (`groups`):** Se crea un grupo llamado `group:profesores` que incluye al usuario `admin`. Esto permite asignar permisos a un conjunto de personas sin tener que escribir sus nombres uno por uno en cada regla.
* **Control de Etiquetas (`tagOwners`):** Esta es la capa de seguridad de identidad. Establece que **solo** los miembros de `group:profesores` tienen autoridad para asignar las etiquetas `tag:router-aula` y `tag:alumno` a los dispositivos. Esto evita que un alumno malintencionado intente cambiarse de etiqueta para obtener más privilegios.
* **Acceso Restringido para Alumnos (`acls` - Regla 1):** Define que cualquier dispositivo etiquetado como `tag:alumno` puede iniciar conexiones hacia la subred física del aula (`192.168.100.0/24`) en cualquier puerto (`*`).
* **Privilegios de Administración (`acls` - Regla 2):** Se otorga al `group:profesores` acceso total a cualquier destino (`*:*`). Esto asegura que el personal docente pueda gestionar todos los nodos y recursos de la VPN sin restricciones.
* **Aislamiento Automático (Deny implícito):** Es la parte más importante del funcionamiento. Al no existir una regla que diga que `tag:alumno` puede conectar con `tag:alumno`, el tráfico entre los dispositivos de los estudiantes es **bloqueado por defecto**. Aunque estén en la misma VPN, son invisibles entre sí.
* **Tráfico Unidireccional:** Las reglas definen quién puede "abrir" la conexión. Los alumnos pueden acceder a la red local, pero los equipos de la red local no pueden iniciar conexiones hacia los alumnos (a menos que añadas una regla inversa).

Para que las reglas se apliquen, debemos usar los tags al conectar los equipos:

### En el Router de la red local

```bash
sudo tailscale up --login-server https://vpn.example.org \
  --advertise-routes=192.168.100.0/24 \
  --advertise-tags=tag:router-aula
```

Recuerda que en el servidor headscale habrá que aceptar la ruta anunciada, como estudiamos en el post: [Configuración del enrutamiento y DNS en una VPN tailscale/headscale](https://www.josedomingo.org/pledin/2026/02/vpn-mesh-headscale-rutas-dns/).

### En el equipo de cada Alumno

Para simplificar, puedes generar una **Pre-Auth Key** etiquetada para que los alumnos no tengan que hacer nada manual:

```bash
docker exec headscale headscale preauthkeys create --user vpn1 --reusable --tag tag:alumno
```

El alumno solo tendrá que ejecutar:

```bash
sudo tailscale up --login-server https://vpn.example.org --authkey hskey-auth-XXXXX
```

### Resultado final

El alumno ahora tiene una interfaz `tailscale0` que le permite llegar a `192.168.100.50` (un equipo del aula), pero si intenta hacer ping a la IP de la VPN de su compañero de al lado, el tráfico será descartado silenciosamente por el motor de filtrado de Tailscale.

## Estrategia 2: Segmentación por usuarios (Namespaces Aislados)

Esta estrategia aprovecha la arquitectura nativa de Headscale para crear **compartimentos estancos** mediante la creación de un usuario independiente para cada entidad (por ejemplo, uno por cada alumno). En este modelo, el aislamiento es el estado por defecto: los nodos de diferentes usuarios no pueden verse entre sí porque pertenecen a redes lógicas totalmente separadas. Para permitir el acceso a los recursos comunes, como el router del aula, se definen reglas de visibilidad transversales en las ACL que "perforan" estos muros de forma controlada. Es una solución muy intuitiva y robusta para escenarios donde se busca un **aislamiento total y sencillo**, ya que evita que un error en el etiquetado de un nodo pueda exponerlo accidentalmente al resto de la malla.

En este escenario, crearíamos `alumno1`, `alumno2`, `alumno3`, etc. El **Router** de la red local (donde están los recursos) se quedaría en un usuario administrativo, por ejemplo `infra`:

```bash
docker exec headscale headscale users create infra
docker exec headscale headscale users create alumno1
docker exec headscale headscale users create alumno2
```

A continuación, registramos el Router en el usuario `infra`, por lo tanto en el router (en el nodo que hace de pasarela a la red local (`192.168.100.0/24`)) ejecutamos:

```bash
sudo tailscale up --login-server https://vpn.example.org --advertise-routes=192.168.100.0/24
```
Recuerda que en el servidor Headscale habrá que aceptar la ruta anunciada, como estudiamos en el post: [Configuración del enrutamiento y DNS en una VPN tailscale/headscale](https://www.josedomingo.org/pledin/2026/02/vpn-mesh-headscale-rutas-dns/).

Configuramos la ACL para "romper" el aislamiento. Como cada alumno está en un usuario distinto, ahora mismo no pueden ver el Router (porque el Router está en `infra`). Necesitamos una regla en `acl.hujson` que permita este cruce:

```json
{
  "acls": [
    // Permitir que cualquier usuario (alumnos) acceda a la subred del router
    {
      "action": "accept",
      "src":    ["*"], 
      "dst":    ["192.168.100.0/24:*"]
    }
  ]
}
```

* Al usar `src: ["*"]`, permitimos que todos los usuarios de Headscale lleguen a esa red, pero como no hay ninguna regla que diga que `alumno1` puede hablar con `alumno2`, el aislamiento entre ellos se mantiene intacto.

Por último, cada usuario registra sus propios dispositivos usando el registro interactivo o usando una **Pre-Auth Key** y aceptando las rutas. 

```bash
# Para el alumno 1
sudo tailscale up --accept-routes --login-server https://vpn.example.org --authkey hskey-auth-XXXXX
```

Recuerda que en los clientes linux tenemos que aceptar las reglas de encaminamiento con el parámetro `--accept-routes`, como estudiamos en el post: [Configuración del enrutamiento y DNS en una VPN tailscale/headscale](https://www.josedomingo.org/pledin/2026/02/vpn-mesh-headscale-rutas-dns/).

### Resultado final

Al finalizar esta configuración, cada dispositivo se encuentra en una burbuja lógica definida por su usuario (Namespace). Un alumno conectado como `alumno1` podrá alcanzar cualquier servicio dentro de la red del aula `192.168.100.0/24` gracias a la regla de "cruce" que hemos definido en las ACL. Sin embargo, dado que no existe ninguna política que autorice el tráfico entre usuarios distintos, el aislamiento es absoluto: la red mesh se comporta como una estrella donde el centro son los recursos compartidos y las puntas son nodos totalmente independientes.

## Conclusiones

Hemos explorado dos formas de alcanzar un mismo objetivo: **seguridad y aislamiento**. Aunque ambas son eficaces, la elección dependerá de la complejidad y el propósito de tu red:

| Característica | Estrategia 1: Tags | Estrategia 2: Usuarios (Namespaces) |
| --- | --- | --- |
| **Escalabilidad** | Alta. Ideal para cientos de nodos. | Media. Tedioso si hay muchos usuarios. |
| **Control** | Granular (por puertos y protocolos). | Grueso (aislamiento total por defecto). |
| **Gestión** | Centralizada en un solo archivo JSON. | Descentralizada en la base de datos. |
| **Uso ideal** | Entornos profesionales y corporativos. | Entornos pequeños o laboratorios rápidos. |

La **Estrategia 1 (Tags)** es la que más se acerca al modelo **Zero Trust** moderno, ya que permite definir políticas basadas en la función del dispositivo y no en quién es su dueño. Es la opción que ofrece mayor flexibilidad a largo plazo, permitiéndote, por ejemplo, que un alumno acceda al servidor web del aula (puerto 80) pero no al SSH del router (puerto 22) con una simple modificación en las ACL.

Por otro lado, la **Estrategia 2 (Usuarios)** es perfecta por su robustez ante errores humanos; es casi imposible que un alumno acceda accidentalmente a otro dispositivo si están en usuarios distintos, lo que la convierte en una opción muy segura para configuraciones rápidas donde no queremos mantener un archivo de políticas complejo.

Independientemente del camino elegido, Headscale demuestra ser una herramienta extremadamente potente para gestionar la seguridad de red sin la rigidez de los firewalls tradicionales.
