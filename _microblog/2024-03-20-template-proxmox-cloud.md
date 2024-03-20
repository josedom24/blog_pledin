---
title: 'Template Proxmox desde una imagen cloud'
tags: 
  - Cloud
  - Proxmox
---
Script que nos permite, a partir de una imagen cloud de un sistema operativo, crear un template de Proxmox:

```
virt-customize --install qemu-guest-agent -a debian-12-genericcloud-amd64.qcow2
virt-customize --run-command \
    "sed -i 's\PasswordAuthentication no\PasswordAuthentication yes\g' /etc/ssh/sshd_config" \
    -a debian-12-genericcloud-amd64.qcow2
qm create 10000 --name debian12-cloud --memory 1024 --net0 virtio,bridge=vmbr0
qm importdisk 10000 debian-12-genericcloud-amd64.qcow2 local-lvm
qm set 10000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-10000-disk-0
qm set 10000 --ide2 local-lvm:cloudinit --boot c --bootdisk scsi0
qm set 10000 --serial0 socket --vga serial0
qm set 10000 --ipconfig0 ip=dhcp
qm set 10000 --ciuser=usuario
qm set 10000 --cipassword=usuario
qm resize 10000 scsi0 +10G
qm set 10000 --agent enabled=1
qm template 10000
```