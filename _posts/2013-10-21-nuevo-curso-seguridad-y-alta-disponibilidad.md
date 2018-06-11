---
id: 794
title: 'Nuevo curso: Seguridad y Alta Disponibilidad'
date: 2013-10-21T10:01:14+00:00


guid: http://www.josedomingo.org/pledin/?p=794
permalink: /2013/10/nuevo-curso-seguridad-y-alta-disponibilidad/


tags:
  - Alta Disponibilidad
  - Cursos
  - Seguridad
---

El pasado mes de septiembre asistí a un curso sobre <strong>Seguridad y Alta Disponibilidad</strong> que impartieron mis compañero Alberto Molina (<a href="https://twitter.com/alberto_molina">@alberto_molina</a>) y José Ignacio Huertas (<a href="https://twitter.com/jihuefer">@jihuefer</a>) en el CEP de Lora del Río..

Puedes acceder a los contenidos del curso en el siguiente enlce: <a href="http://www.josedomingo.org/web/course/view.php?id=71">Curso de Seguridad y Alta Disponibilidad.</a>

Lo objetivos del curso son los siguientes:

* Aprender a desarrollar pruebas de intrusión para comprobar la fortaleza de los sistemas de seguridad y evaluar el nivel de resistencia a una intrusión no deseada.
* Aprender a instalar soluciones de Alta Disponibilidad con un alto grado de fiabilidad y de continuidad operativa.

Y los contenidos:

* Ataques en redes de datos.
  * Introducción a los ataques en redes. 
  * Ataques internos vs externos.
  * Test de intrusión. 
    * Recopilación de información 
      * Técnicas de footprinting: DNS, ICANN, Web search Servicios Web (Robtex, Netcraft...), Fuzzers, Spidering y Metadatos.
      * Técnicas de fingerprinting: nmap
    * Búsqueda de vulnerabilidades
        * Introducción a las vulnerabilidades
        * Expedientes de seguridad
        * Escáner de vulnerabilidades: Nessus, NeXpose
    * Explotación 
        * Introducción a los exploits
        * Búsqueda de exploits: CVEDetails
        * Metasploit Framework: introducción, configuración de exploits, ejecución de exploits.
        * Casos prácticos.
* Alta disponibilidad 
  * Introducción sistemas AD
  * Clúster sencillo de AD con Linux-HA (pacemaker, corosync)
  * Replicación de MySQL 
    * Configuración en modo master-slave
    * Configuración en modo master-master
    * Errores comunes
  * Balanceadores de carga 
    * Uso y función de los balanceadores
    * Comparativa de dos soluciones software: haproxy y ldirectord
    * Configuración de ldirectord en modo NAT
    * Configuración de haproxy
  * Clúster HA con Apache, PHP y Memcached. 
    * Aplicaciones del clúster: failover y balanceo
    * Replicación de ficheros con rsync
    * Replicación de sesiones con rsync y memcached
      
