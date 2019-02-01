---
title: 'Kubernetes. configurando nuestras aplicaciones: variables de entornos, ConfigMap, Sectrets'
permalink: /2019/02/kubernetes-config-app/
tags:
  - Cloud Computing
  - kubernetes
---
## Configurando nuestras aplicaciones con variables de entorno

Para configurar las aplicaciones que vamos a desplegar usamos variables de entorno, por ejemplo podemos ver las variables de entorno que podemos definir para configurar la imagen docker de [MariaDB](https://hub.docker.com/_/mariadb/).

Podemos definir un `Deployment` que defina un contenedor configurado por medio de variables de entorno, [`mariadb-deployment.yaml`](https://github.com/josedom24/kubernetes/blob/master/ejemplos/mariadb/mariadb-deployment.yaml):

    apiVersion: apps/v1beta1
    kind: Deployment
    metadata:
      name: mariadb-deployment
      labels:
        app: mariadb
        type: database
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            app: mariadb
            type: database
        spec:
          containers:
            - name: mariadb
              image: mariadb
              ports:
                - containerPort: 3306
                  name: db-port
              env:
                - name: MYSQL_ROOT_PASSWORD
                  value: my-password

Y creamos el despliegue:

    kubectl create -f mariadb-deployment.yaml
    deployment.apps "mariadb-deployment" created

O directamente ejecutando:

    kubectl run mariadb --image=mariadb --env MYSQL_ROOT_PASSWORD=my-password

Veamos el pod creado:

    kubectl get pods -l app=mariadb
    NAME                                READY     STATUS    RESTARTS   AGE
    mariadb-deployment-fc75f956-f5zlt   1/1       Running   0          15s

Y probamos si podemos acceder, introduciendo la contraseña configurada:

    kubectl exec -it mariadb-deployment-fc75f956-f5zlt -- mysql -u root -p
    Enter password: 
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MariaDB connection id is 8
    Server version: 10.2.15-MariaDB-10.2.15+maria~jessie mariadb.org binary distribution

    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    MariaDB [(none)]> 

<!--more-->

## Configurando nuestras aplicaciones: ConfigMaps

[`ConfigMap`](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) te permite definir un diccionario (clave,valor) para guardar información que puedes utilizar para configurar una aplicación.

Al crear un `ConfigMap` los valores se pueden indicar desde un directorio, un fichero o un literal.

    kubectl create cm mariadb --from-literal=root_password=my-password \
                              --from-literal=mysql_usuario=usuario     \
                              --from-literal=mysql_password=password-user \
                              --from-literal=basededatos=test
    configmap "mariadb" created
    
    kubectl get cm
    NAME      DATA      AGE
    mariadb   4         15s
    
    kubectl describe cm mariadb
    Name:         mariadb
    Namespace:    default
    Labels:       <none>
    Annotations:  <none>

    Data
    ====
    mysql_usuario:
    ----
    usuario
    root_password:
    ----
    my-password
    basededatos:
    ----
    test
    mysql_password:
    ----
    password-user
    Events:  <none>

Ahora podemos configurar el fichero yaml que define el despliegue, [`mariadb-deployment-configmap.yaml`](https://github.com/josedom24/kubernetes/blob/master/ejemplos/mariadb/mariadb-deployment-configmap.yaml):

    apiVersion: apps/v1beta1
    kind: Deployment
    metadata:
      name: mariadb-deploy-cm
      labels:
        app: mariadb
        type: database
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            app: mariadb
            type: database
        spec:
          containers:
            - name: mariadb
              image: mariadb
              ports:
                - containerPort: 3306
                  name: db-port
              env:
                - name: MYSQL_ROOT_PASSWORD
                  valueFrom:
                    configMapKeyRef:
                      name: mariadb
                      key: root_password
                - name: MYSQL_USER
                  valueFrom:
                    configMapKeyRef:
                      name: mariadb
                      key: mysql_usuario
                - name: MYSQL_PASSWORD
                  valueFrom:
                    configMapKeyRef:
                      name: mariadb
                      key: mysql_password
                - name: MYSQL_DATABASE
                  valueFrom:
                    configMapKeyRef:
                      name: mariadb
                      key: basededatos

Creamos el despliegue y probamos el acceso:

    kubectl create -f mariadb-deployment-configmap.yaml
    deployment.apps "mariadb-deploy-cm" created
    
    kubectl get pods -l app=mariadb
    NAME                                 READY     STATUS    RESTARTS   AGE
    mariadb-deploy-cm-57f7b9c7d7-ll6pv   1/1       Running   0          15s
    
    kubectl exec -it mariadb-deploy-cm-57f7b9c7d7-ll6pv -- mysql -u usuario -p
    Enter password: 
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MariaDB connection id is 8
    Server version: 10.2.15-MariaDB-10.2.15+maria~jessie mariadb.org binary distribution

    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
   
    MariaDB [(none)]> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | test               |
    +--------------------+
    2 rows in set (0.00 sec)

## Configurando nuestras aplicaciones: Secrets

Los [`Secrets`](https://kubernetes.io/docs/concepts/configuration/secret/) nos permiten guardar información sensible que será codificada. Por ejemplo,nos permite guarda contraseñas, claves ssh, ...

Al crear un `Secret` los valores se pueden indicar desde un directorio, un fichero o un literal.

    kubectl create secret generic mariadb --from-literal=password=root
    secret "mariadb" created
    
    kubectl get secret
    NAME                  TYPE                                  DATA      AGE
    ...
    mariadb               Opaque                                1         15s
    
    kubectl describe secret mariadb
    Name:         mariadb
    Namespace:    default
    Labels:       <none>
    Annotations:  <none>

    Type:  Opaque

    Data
    ====
    password:  4 bytes

Los `Secrets` no son seguro, no están encriptados.

    kubectl get secret mariadb -o yaml
    apiVersion: v1
    data:
      password: cm9vdA==
    kind: Secret
    metadata:
      creationTimestamp: 2018-05-23T18:22:27Z
      name: mariadb
      namespace: default
      resourceVersion: "162405"
      selfLink: /api/v1/namespaces/default/secrets/mariadb
      uid: 3fa5e1ad-5eb6-11e8-ab66-fa163e99cb75
    type: Opaque
    
    echo 'cm9vdA==' | base64 --decode
    root

Podemos definir un `Deployment` que defina un contenedor configurado por medio de variables de entorno, [`mariadb-deployment-secret.yaml`](https://github.com/josedom24/kubernetes/blob/master/ejemplos/mariadb/mariadb-deployment-secret.yaml):

    apiVersion: apps/v1beta1
    kind: Deployment
    metadata:
      name: mariadb-deploy-secret
      labels:
        app: mariadb
        type: database
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            app: mariadb
            type: database
        spec:
          containers:
            - name: mariadb
              image: mariadb
              ports:
                - containerPort: 3306
                  name: db-port
              env:
                - name: MYSQL_ROOT_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: mariadb
                      key: password

Creamos el despliegue y probamos el acceso:

    kubectl create -f mariadb-deployment-secret.yaml
    deployment.apps "mariadb-deploy-secret" created
    
    kubectl get pods -l app=mariadb
    NAME                                    READY     STATUS    RESTARTS   AGE
    mariadb-deploy-secret-f946dddfd-kkmlb   1/1       Running   0          15s
        
    kubectl exec -it mariadb-deploy-secret-f946dddfd-kkmlb -- mysql -u root -p
    Enter password: 
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MariaDB connection id is 8
    Server version: 10.2.15-MariaDB-10.2.15+maria~jessie mariadb.org binary distribution

    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    MariaDB [(none)]> 

La empresa [Bitnami](https://bitnami.com/) ha desarrollado otro recurso de Kubernete llamado [`SealedSecrets`](https://github.com/bitnami-labs/sealed-secrets) que permite que un controlador gestione la encriptación de los datos sensibles.

{% include indice_kubernetes.html%}