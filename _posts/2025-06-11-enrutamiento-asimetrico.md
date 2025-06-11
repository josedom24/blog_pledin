---
title: 'El problema del enrutamiento asimétrico'
permalink: /2025/06/enrutamiento asimetrico/
tags:
  - Redes
---

De forma general, hablamos de **enrutamiento asimétrico** cuando se da la situación donde los paquetes de ida y vuelta entre dos dispositivos no siguen el mismo camino. En el enrutamiento asimétrico, el paquete de ida toma un camino y la respuesta toma otro **distinto**.
Recientemente me he encontrado un escenario concreto donde se presenta. Lo podemos ver gráficamente en el siguiente esquema:

![enrutamiento](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2025/06/asimetrico1.png){: .align-center }

No puedo acceder a un servidor web que tengo en mi red local porque no tengo acceso a la configuración del router y no puedo configurar las reglas DNAT para abrir los puertos de navegación Web.
  
![enrutamiento](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2025/06/asimetrico2.png){: .align-center }

La **solución** pasa por evitar el acceso directo al router local. En su lugar, accedemos a una máquina remota (VPS) con dirección IP pública. Esta máquina actúa como router intermedio, ya que le configuramos una regla DNAT que redirige los paquetes al servidor web local, conectado a la VPS a través de una VPN. Es decir, los paquetes entrantes llegan al servidor web por la interfaz de la VPN (tun0).
El **problema**: La ruta por defecto del servidor web está configurada para enviar el tráfico saliente a través del router físico local, no por la VPN. Como resultado, la respuesta no vuelve por el mismo camino, y el cliente no puede acceder correctamente al servidor web. Esto ocurre porque el router local no puede realizar el cambio de dirección de origen (SNAT) para paquetes que no vio llegar. Lo vemos claramente en este esquema:

![enrutamiento](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2025/06/asimetrico3.png){: .align-center }

Lo deseable sería que el **tráfico de respuesta también saliera por la VPN**, manteniendo la simetría en la ruta. Es decir, que tanto los paquetes de ida como los de vuelta pasen por el túnel VPN, como se muestra aquí:

![enrutamiento](https://www.josedomingo.org/pledin/assets/wp-content/uploads/2025/06/asimetrico4.png){: .align-center }

Veamos dos posibles soluciones a este problema:

<!--more-->

## Primera solución:  SNAT en la interfaz VPN

Cuando un cliente accede desde Internet a la **IP pública del VPS**, este reenvía el tráfico por la VPN al Servidor Web (192.168.100.2). Pero el servidor **responde a través de su ruta por defecto** (salida local, 192.168.0.1). Esto rompe la conexión porque:

* La IP de origen del cliente (pública) no puede ser alcanzada desde el servidor a través de su red local.
* El firewall/NAT intermedio puede bloquear la respuesta porque no corresponde al flujo original.

Para solucionar esto, en el VPS aplicamos **Source NAT (SNAT)** sobre el tráfico que se reenvía al servidor. Es decir, **modificamos la IP de origen del paquete antes de enviarlo por la VPN**, de modo que el servidor web **ve como origen la IP de la VPN del VPS**, en lugar de la IP real del cliente.

De esta forma, el servidor responde por la misma VPN (`tun0`), y la respuesta llega correctamente al cliente.

En este caso en la VPN tendríamos dos reglas NAT:

* Una **Destination NAT (DNAT)**: para redirigir el tráfico entrante (puertos 80 y 443) al servidor web local por la VPN.
* Otra **SNAT**:     para modificar la IP de origen del cliente por la IP VPN del VPS, asegurando así que el servidor devuelva la respuesta por la misma VPN.


```
iptables -A PREROUTING -i eth0 -p tcp -m multiport --dports 80,443 -j DNAT --to-destination 192.168.100.2
iptables -A POSTROUTING -s 192.168.100.0/24 -o tun0 -j MASQUERADE
```

El principal problema de esta solución es que al reescribe la dirección IP de origen del paquete para que parezca que viene del VPS, el Servidor Web no concoe la dirección IP del cliente real y esto puede causar problemas secundarios: el servidor web no puede registrar en los log las IP reales de los clientes, no puede aplicar restricciones por la IP de origen,...

## Segunda solución: Políticas de enrutamiento (Policy-Based Routing - PBR)

Para solucionar el problema de que le Servidor Web no conoce la dirección IP de los clientes reales, vamos a explorar otra solución. En este caso, asumimos que hemos borrado la regla SNAT que explicamos en el punto anterior.

Por defecto, Linux enruta según la tabla de rutas global (basada en destino). Pero con las políticas de enrutamiento, podemos definir rutas de este estilo: **"Si el tráfico viene desde cierto origen o llega por cierta interfaz, usa una tabla de rutas distinta."** De forma concreta en nuestro ejemplo: **"Si el tráfico viene de la VPN (192.168.100.0/24), responde por la VPN, no por la ruta por defecto."**

Esta configuración se tiene que realizar en el Servidor Web. Veamos los pasos que tenemos que seguir para conseguirlo:

1.  Vamos a crear una nueva tabla de enrutamiento que llamaremos **vpnroute**. Para ello editamos el fichero `/etc/iproute2/rt_tables` y añadimos la siguiente línea:

  ```
  100 vpnroute
  ```

2. Añadimos una ruta por defecto para esta tabla.Indicamos que para la tabla `vpnroute`, la salida por defecto es la interfaz VPN `tun0`:

  ```
  sudo ip route add default dev tun0 table vpnroute
  ```

3. Añadimos una regla de enrutamiento condicional. Configuramos la siguiente regla: **Si un paquete viene desde la IP de la VPN, usa la tabla `vpnroute`.**

  ```
  sudo ip rule add from 192.168.100.2 lookup vpnroute
  ```

4. Verificamos la configuración:

  ```
  ip rule
  ...
  32765:	from 192.168.98.2 lookup vpnroute

  ip route show table vpnroute
  default dev tun0 scope link 
  ```

Ya estaría funcionando, pero esta configuración no es persistente. Para hacer la persistente si estamos usando la configuración de red con la herramienta **ifupdown**, podríamos hacer un script ejecutable que guardaríamos en el directorio`/etc/network/if-up.d/` para que se ejecutase al levantar la interfaz. El fichero se puede llamar `/etc/network/if-up.d/policy-routing-vpn` con el siguiente contenido:

```sh
#!/bin/sh

# Solo ejecutar si la interfaz es tun0
[ "$IFACE" = "tun0" ] || exit 0

# Añadir ruta por defecto en la tabla 'vpnroute'
ip route add default dev tun0 table vpnroute 2>/dev/null

# Añadir regla de enrutamiento si no existe
ip rule list | grep -q "from 192.168.100.2 lookup vpnroute" || \
  ip rule add from 192.168.100.2 lookup vpnroute

exit 0

```

Y finalmente, le damos permiso de ejecución:

```
sudo chmod +x /etc/network/if-up.d/policy-routing-vpn
```

## Conclusión

Aunque podríamos explorar otras soluciones, como instalar un **proxy inverso** en el VPS o modificar directamente la **ruta por defecto** del servidor web (lo cual podría afectar otras comunicaciones), con esta descripción queda claro cuáles son las **dos soluciones principales** al problema del enrutamiento asimétrico en este escenario concreto.

* Por un lado, la solución basada en **SNAT** es sencilla de implementar y permite resolver el problema de forma rápida, aunque con la **limitación de perder la IP real del cliente**.
* Por otro, la solución mediante **enrutamiento por políticas (policy-based routing)** es más limpia y preserva la información del cliente, pero requiere mayor control sobre el sistema y una configuración algo más avanzada.

Elegir una u otra dependerá de las necesidades específicas del entorno: si prima la simplicidad o si es esencial mantener la trazabilidad de los clientes.

En definitiva, entender cómo funciona el enrutamiento asimétrico y cómo corregirlo es fundamental en redes modernas, especialmente cuando combinamos **VPNs, NAT y servicios web expuestos** desde redes locales a través de máquinas intermedias como VPS.

