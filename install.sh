

# get list of disk devices
DISK_DEVICES=$(lsblk -d -n -p -o NAME,SIZE,TYPE | grep disk | awk '{print $1}')

# select disk device
echo "Available disk devices:"
echo "$DISK_DEVICES"
echo "Please select a disk device to install the system on (e.g., /dev/sda):"
read -r DISK_DEVICE

# check if the selected disk device is valid
if [[ ! "$DISK_DEVICES" =~ "$DISK_DEVICE" ]]; then
    echo "Invalid disk device selected. Exiting."
    exit 1
fi
# check if the selected disk device is mounted
if mount | grep "$DISK_DEVICE" > /dev/null; then
    echo "The selected disk device is mounted. Please unmount it before proceeding."
    exit 1
fi

# create partitions
echo "Creating partitions on $DISK_DEVICE..."

parted "$DISK_DEVICE" --script mklabel gpt
parted "$DISK_DEVICE" --script mkpart primary 1MiB 512MiB

# set labels
mkfs.fat -F32 -n EFI "$DISK_DEVICE"1
mkfs.ext4 -L nixos "$DISK_DEVICE"2

# mount partitions
echo "Mounting partitions..."
mount "$DISK_DEVICE"2 /mnt
mkdir -p /mnt/boot
mount "$DISK_DEVICE"1 /mnt/boot

# install NixOS
nixos-generate-config --root /mnt


