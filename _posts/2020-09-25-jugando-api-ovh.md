---
title: 'Jugando con la API de OVH'
permalink: /2020/09/jugando-api-ovh/
tags:
  - Python
  - Servicios web
---

![ovh]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/09/ovh1.png){: .align-center }

OVH es un proveedor de alojamiento web, computación en la nube y telecomunicaciones francés. Ofrece distintos servicios: VPS, dominios, Cloud Computing,... En este artículo voy a hacer una introducción al uso de la [API pública de OVH](https://api.ovh.com/) para gestionar los recursos que tengamos contratados en la empresa.

## Configuración de nuestro entorno de desarrollo

Vamos a utilizar el lenguaje Python para hacer programas que nos permitan interactuar con el servicio OVH para gestionar los recursos que tenemos contratados.

Vamos a usar una librería python que es un wrapper que nos facilita las llamadas a la API, para ello vamos a crear un entorno virtual:

    $ python3 -m venv ovh
    $ source ovh/bin/activate
    (ovh)# pip install ovh

<!--more-->

## Creación de una aplicación para el uso de la API

El siguiente paso es crear una aplicación para el uso de la API que nos proporcionará las credenciales necesarias para el acceso a los recursos de la API, para ello accedemos a la página web de la API de OVH en Europa: [https://eu.api.ovh.com/createApp/](https://eu.api.ovh.com/createApp/).

![ovh]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/09/ovh1.png){: .align-center }

En esta página nos logueamos con nuestro usuario de OVH, e indicamos un nombre y una descripción de nuestra aplicación. Una vez creada la aplicación nos devolverán las credenciales: la *Application Key* y la *Application Secret* que identifican nuestra aplicación y nuestro usuario.

![ovh]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/09/ovh2.png){: .align-center }

## Configurando el acceso 

La manera más fácil de configurar el acceso a la API es creando un fichero que llamamos `ovh.conf` en el mismo directorio donde vamos a ejecutar nuestro programa. Este fichero tendrá el siguiente contenido:

    [default]
    ; general configuration: default endpoint
    endpoint=ovh-eu

    [ovh-eu]
    ; configuration specific to 'ovh-eu' endpoint
    application_key=xxxxxxxxxxxxxxxx
    application_secret=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    ; uncomment following line when writing a script application
    ; with a single consumer key.
    ;consumer_key=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Como podemos comprobar indicamos el `endpoint`, en este caso al usar *OVh europe* será `ovh-eu` y indicamos nuestras credenciales: `application_key` y `application_secret`.

Nos faltaría la `consumer_key` para poder utilizar la API. En la siguiente sección vamos a realizar un script que nos devuelve dicho valor, y que posteriormente colocaremos en este fichero y descomentaremos la última línea.

## Solicitando la consumer_key

Para solicitar la clave de usuario `consumer_key` tenemos que autentificarnos como usuario de OVH en una página que nos devolverá el valor de esta clave. El programa `solicitar_consumer_key.py` es el responsable de generar la URL de está página y mostrarnos el valor de la clave:

    import ovh

    # create a client using configuration
    client = ovh.Client()

    # Request RO, /me API access
    ck = client.new_consumer_key_request()
    # Allow all GET, POST, PUT, DELETE on /* (full API)
    ck.add_recursive_rules(ovh.API_READ_WRITE, '/')

    # Request token
    validation = ck.request()

    print("Please visit %s to authenticate" % validation['validationUrl'])
    input("and press Enter to continue...")

    # Print nice welcome message
    print("Welcome", client.get('/me')['firstname'])
    print("Btw, your 'consumerKey' is '%s'" % validation['consumerKey'])

Veamos que hace cada instrucción:

* `client = ovh.Client()`: Crea el cliente que vamos a usar para hacer llamadas a la API. esta instrucción buscará nuestras credenciales en el fichero `ovh.conf`.
* `ck = client.new_consumer_key_request()`: Solicitamos la `consumer_key`.
* `ck.add_recursive_rules(ovh.API_READ_WRITE, '/')`: Indicamos la autorización que vamos a tener para usar los r3ecursos de la API. En este caso vamos a generar un `consumer_key` que será válido para hacer cualquier tipo de llamada HTTP (GET; POST, PUT, DELETE) (indicado con `ovh.API_READ_WRITE`) a todos loos recursos de la API (indicado con `/`). 
    * Si indicamos, por ejemplo: `ck.add_rules(ovh.API_READ_ONLY, "/me")` pues autorizaríamos sólo peticiones GET a la ruta de la API `/me`.
* validation = ck.request(): Solicitamos información sobre la solicitud de clave. En concreto en `validation['validationUrl']` tendremos el token que va a formar parte de la URL a la que tenemos que acceder para generar la clave..

Al ejecutar el programa, se nos indicará la URL a la que tenemos que acceder. En esa página nos tendremos que loguear e indicar la duración de validez del `consumer_key`. Volvemos a la consola pulsamos `Enter` y nos mostrará nuestro nombre (`client.get('/me')['firstname']`) y el valor que estamos buscando (`validation['consumerKey']`). El proceso sería el siguiente:


    $ python3 solicitar_consumer_key.py
    Please visit https://eu.api.ovh.com/auth/?credentialToken=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx to authenticate
    and press Enter to continue...

En este momento accedemos a la URL, nos logueamos e indicamos el tiempo de validez de la clave:ç

![ovh]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2020/09/ovh3.png){: .align-center }

Vovlemos al terminar, pulsamos `Enter` y terminará el programa:

    Welcome José Domingo
    Btw, your 'consumerKey' is 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

Una vez que tenemos el valor de la `consumer_key` lo indicamos en el fichero `ovh.conf`, descomentando la última línea e indicando el valor:

    consumer_key=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Ya estamos en disposición de estudiar las distintos objetos que nos ofrece la [API de OVH](https://api.ovh.com/console/), para crear programas que me permitan gestionar los recursos contratados. Veamos algunos ejemplos:

## Mostrar los servicios que tienes contratado en ovh

    import ovh
    import json
    client = ovh.Client()
    
    result = client.get('/services', 
        #orderBy='', # Order services by services.expanded.Service properties (type: string)
        #routes='', # Filter services by API route path (comma separated) (type: string)
        #sort='',# Sort results generated by 'orderBy' (type: string)
        ) 
    
    for prod in result:
        result2 = client.get('/services/%i'%prod)
        print (json.dumps(result2, indent=4))

## Obtener información de los VPS contratados

    import ovh
    import json
    client = ovh.Client()

    result = client.get('/vps')
    for vps in result:
        print(vps)
        result2 = client.get('/vps/%s/serviceInfos'%vps)
        print (json.dumps(result2, indent=4))


## Modificar el contacto técnico de un VPS

    import ovh
    import json
    client = ovh.Client()

    vps=input("Indica el nombre de un vps:")
    id=input("Indica el código del contacto técnico:")

    try:
        result2 = client.post('/vps/%s/changeContact'%vps, 
                contactAdmin=None, # The contact to set as admin contact (type: string)
                contactBilling=None, # The contact to set as billing contact (type: string)
                contactTech=id, # The contact to set as tech contact (type: string)
            )
    except:
        print("Error. Nombre o usuario incorrecto.")


## Conclusiones

Espero que este artículo pueda servir a aquellas personas que se quieren iniciar en el uso de la API pública de OVH utilizando python. Si quieres más información accede a estas páginas:

* [First Steps with the API](https://docs.ovh.com/gb/en/customer/first-steps-with-ovh-api/)
* [Wrappers on OVH API: python](https://github.com/ovh/python-ovh)
* [Exlore the OVH API](https://eu.api.ovh.com/console/)