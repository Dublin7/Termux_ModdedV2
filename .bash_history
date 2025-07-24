qemu-img create -f qcow2 alpine.img 5g
qemu-system-x86_64 -hda alpine.img -cdrom alpine.iso -boot d -m 512
