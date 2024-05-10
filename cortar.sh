#!/bin/bash

# Directorio de origen y destino
directorio_origen="_drafts"
directorio_destino="_posts"

# Iterar sobre los archivos en el directorio de origen
for archivo in "$directorio_origen"/*; do
    # Verificar si es un archivo regular
    if [ -f "$archivo" ]; then
        # Obtener el nombre del archivo sin la ruta
        nombre_archivo=$(basename "$archivo")
        # Extraer el año del nombre del archivo
        year=$(echo "$nombre_archivo" | grep -oE '^[0-9]{4}')
        
        # Verificar si el año está fuera del rango de 2010 a 2023
	if [ "$year" -ge 2010 ] && [ "$year" -le 2023 ]; then
            # Crear el nombre de archivo de destino
            nuevo_nombre="$directorio_destino/$nombre_archivo"
	    echo "$archivo"
echo "$nuevo_nombre"            
            # Eliminar líneas a partir de la segunda aparición de "---"
            awk '/---/{if (++n == 2) {print;exit}}; {print}' "$archivo" > "$nuevo_nombre"
            
            echo "Se ha procesado $archivo y guardado en $nuevo_nombre"
        fi
    fi
done
