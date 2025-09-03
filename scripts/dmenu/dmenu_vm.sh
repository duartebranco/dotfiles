#!/bin/bash

# QEMU VM Launcher with dmenu
# Lists available virtual machines and lets you select one to launch

# Configuration
VM_DIR="$HOME/doc/Vms"
DMENU_CMD="dmenu -l 20 -p 'Select VM:'"

# Find available VM disk images
list_vms() {
    find "$VM_DIR" -type f -not -path "$VM_DIR/ISO/*" -printf "%f\n" | sort
}

# Launch selected VM
launch_vm() {
    local vm_name="$1"
    local vm_path="$VM_DIR/$vm_name"

    if [ $vm_name = "temple" ]; then
        cd /home/duarte/app/TempleOs-pywal-colors
        python3 generate_theme.py
        ./update.sh ~/doc/Vms/temple ~/doc/Vms/mnt
        sleep 1s
        qemu-system-x86_64 -audiodev pa,id=audio0 -machine pc,pcspk-audiodev=audio0 -m 512M -enable-kvm -drive file="$VM_DIR/temple",format=qcow2 -boot order=d -display gtk,zoom-to-fit=on,show-menubar=off
    fi
    # elif [ $vm_name = "" ]; then
	# else
	# fi
}

# Main script
selected_vm=$(list_vms | eval "$DMENU_CMD")

if [ -n "$selected_vm" ]; then
    launch_vm "$selected_vm"
fi
