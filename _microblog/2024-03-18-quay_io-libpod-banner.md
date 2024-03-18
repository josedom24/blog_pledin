---
title: 'Imagen OCI quay.io/libpod/banner'
tags: 
  - Docker
  - Podman
  - Contenedor
---
Si estás haciendo pruebas con Docker o Podman puedes usar la imagen `quay.io/libpod/banner`, que nos proporciona un servidor web de pruebas. Es una imagen muy pequeña, sólo ocupa 1.7 MB. La podemos ejecutar:

```
podman run -d --name miweb -p 8080:80 quay.io/libpod/banner
```

Y podemos acceder al contenedor:

![ ]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2024/03/banner.png){: .align-center}