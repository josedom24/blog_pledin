---
title: 'Listar imágenes Docker que no tienen contenedor asociado'
tags: 
  - Docker
  - Contenedor
---
Dejo por aquí un pequeño script bash que nos lista las imágenes Docker que no tienen ningún contenedor creado:

```bash
{% raw %}
#!/bin/bash

echo "Imágenes sin contenedores:"
docker images --format '{{.ID}} {{.Repository}}:{{.Tag}}' | while read img repo; do
    if ! docker ps --all --quiet --no-trunc | xargs docker inspect --format '{{.Image}}' | grep -q $img; then
        echo "- $repo"
    fi
done
{% endraw %}
```
