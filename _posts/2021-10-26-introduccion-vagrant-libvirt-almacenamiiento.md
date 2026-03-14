---
title: 'Introducción al uso de vagrant + libvirt + QEMU/KVM. Almacenamiento.'
permalink: /2021/10/introduccion-vagrant-libvirt-almacenamiento/
tags:
  - Vagrant
  - libvirt
  - kvm
  - Virtualización
---

![redes]({{ site.url }}{{ site.baseurl }}/assets/wp-content/uploads/2021/10/vagrant-kvm3.png){: .align-center }

Para terminar esta serie de entradas donde hemos estudiado el uso de vagrant utilizando como hypervisor de máquinas virtuales QEMU/KVM, vamos a tratar la forma de configurar el almacenamiento en nuestras máquinas.

## Crear una máquina y añadirle un nuevo disco

Para ello, en el `Vagrantfile`, podemos indicar los discos extras que va a tener la máquina, para ello indicamos tantos bloques `libvirt.storage` como discos queramos conectar:

```ruby
  ...
  config.vm.provider :libvirt do |libvirt|
    libvirt.storage :file, :size => '20G'
  end
  ...
```

Ademas del tamaño (`size`) podemos indicar otros [parámetros](https://github.com/vagrant-libvirt/vagrant-libvirt#additional-disks).

Podemos observar que se ha creado un nuevo volumen:

```bash
$ virsh -c qemu:///system vol-list default
 Nombre                                    Ruta
----------------------------------------------------------------------------------------------------------
 ...
 ej1_default-vdb.qcow2                     /var/lib/libvirt/images/ej1_default-vdb.qcow2
...
```

Cuando eliminamos el escenario, el volumen también se borrará.

## Crear una máquina y añadirle un disco ya existente

Si tenemos un volumen creado también lo podemos usar para crear la nueva máquina, en esta ocasión la definición en el fichero `Vagrantfile` sería:

```ruby
  ...
  config.vm.provider :libvirt do |libvirt|
    libvirt.storage :file, 
      :path => 'new_disk.qcow2', 
      :allow_existing => true,  
      :type => 'qcow2'
  end
  
  ...
```

En este caso, no se crea un nuevo volumen, se utiliza uno que ya tenemos creado `new_disk.qcow2`, por lo que al eliminar el escenario, ese volumen no se borrará.

## Conclusiones

Esta entrada ha quedado menos extensa que otras anteriores, pero se ha presentado los fundamentos para configurar el almacenamiento en nuestras máquinas virtuales creadas con Vagrant. Como siempre para seguir profundizando hat que estudiar la [documentación](https://github.com/vagrant-libvirt/vagrant-libvirt#additional-disks) del plugin.