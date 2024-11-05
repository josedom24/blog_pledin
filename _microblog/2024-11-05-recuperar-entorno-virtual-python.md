---
title: 'Recuperar entornos virtuales de Python'
tags: 
  - python
  
---
En ocasiones, quizás porque hayamos actualizado el sistema y ha cambiado la versión de Python, al trabajar con un entorno virtual obtenemos el siguiente error:

```
(entorno)$ pip3 list
Traceback (most recent call last):
  File "/home/jose/virtualenv/flask_temperaturas/bin/pip3", line 5, in <module>
    from pip._internal.cli.main import main
ModuleNotFoundError: No module named 'pip'
```

Este error ocurre porque el entorno virtual no tiene correctamente instalado `pip`. Para solucionarlo:
```
(entorno)$ python3 -m ensurepip --upgrade
```

Y si queremos podemos actualizar `pip` ejecutando:
```
(entorno)$ python -m pip install --upgrade pip
```