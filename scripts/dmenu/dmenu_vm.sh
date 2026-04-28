#!/bin/bash

# QEMU VM Launcher with dmenu
# Lists available virtual machines and lets you select one to launch

# Configuration
VM_DIR="$HOME/doc/Vms"
DMENU_CMD="dmenu -l 20 -p 'Select VM:'"

# Find available VM disk images
list_vms() {
    find "$VM_DIR" -type f -not -path "$VM_DIR/ISO/*" -not -path "$VM_DIR/scripts/*" -not -path "$VM_DIR/doc/*" -printf "%f\n" | sort
}

# Launch selected VM
launch_vm() {
    local vm_name="$1"
    local vm_path="$VM_DIR/$vm_name"
    notify-send "Launching $vm_name machine" "Please wait 😊"

    if [ $vm_name = "TempleOS" ]; then
        cd /home/duarte/app/TempleOs-pywal-colors
        python3 generate_theme.py
        ./update.sh ~/doc/Vms/TempleOS ~/doc/Vms/mnt
        sleep 1s
		qemu-system-x86_64 \
			-audiodev pa,id=audio0 \
			-machine pc,pcspk-audiodev=audio0 \
			-m 512M \
			-enable-kvm \
			-drive file="$VM_DIR/TempleOS",format=qcow2 \
			-boot order=d \
			-display gtk,zoom-to-fit=on,show-menubar=off || {
			notify-send "VM Launch Failed" "QEMU failed to start" --urgency=critical
			return 1
		}
    elif [ $vm_name = "XubuntuSIO" ]; then
        qemu-system-x86_64 \
            -drive file="$VM_DIR/XubuntuSIO",format=qcow2 \
            -m 8192 \
            -enable-kvm \
            -cpu host \
            -smp $(nproc) \
            -vga virtio \
            -device virtio-gpu-pci \
			-display gtk,show-menubar=off \
            -virtfs local,path=$HOME/doc/Personal/UA/3ºAno/SIO/P,mount_tag=hostshare,security_model=passthrough,id=hostshare || {
            notify-send "VM Launch Failed" "QEMU failed to start" --urgency=critical
            return 1
        }
    fi
	#else
	#fi
}

# Main script
selected_vm=$(list_vms | eval "$DMENU_CMD")

if [ -n "$selected_vm" ]; then
    launch_vm "$selected_vm"
fi
