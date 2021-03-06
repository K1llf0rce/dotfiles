# k1f0's install file

> This File cotains some Info for inital Install of a new Arch-based System
>  
> Most Things in here are done as stated in the [ArchWiki](https://wiki.archlinux.org/title/Installation_guide)

# Pre-Install for Boot Media

```bash
# Load Key Layout
loadkeys de
# Make sure we have Internet
ip a
ping 1.1.1.1
nslookup archlinux.org
# WiFI Connection (if needed)
iwctl
> device list
> station device scan
> station [dev] get-networks
> station [dev] connect [ssid]
# Enable NTP
timedatectl set-ntp true
timedatectl status
```

# Disk Setup

## Preperation

```bash
# list all disks
fdisk -l
# edit a disk
fdisk [/dev/sdX] || [/dev/nvme0nX]
# fdisk commands
> d #delete partition
> t #change partition type
> w #write changes to disk
> g #create new GPT partition table
> q #quit WITHOUT saving
> m #print help
> n #add new partition
# We need a root and a boot (UEFI) Partition
# Swap Partition is optional, Swap File is prefered 
```

## Formatting and Mounting

```bash
# EXT4 for root
mkfs.ext4 [/dev/root_part]
# FAT32 for boot (UEFI)
mkfs.fat -F32 [/dev/boot_part]
# Mount boot (UEFI)
mkdir /boot/EFI
mount [/dev/boot_part] /boot/EFI
# Mount root
mount [/dev/root_part] /mnt
```

## Formatting and Mounting with Full Disk Encryption

```bash
# The result will look like this
#+-----------------------+------------------------+
#| Boot partition        | LUKS2 encrypted system |
#|                       | partition              |
#|                       |                        |
#| /boot                 | /                      |
#|                       |                        |
#|                       | /dev/mapper/root       |
#|                       |------------------------|
#| /dev/disk1            | /dev/disk2             |
#+-----------------------+------------------------+
# new LUKS for root
# Make sure to use a strong password
cryptsetup -y -v luksFormat [/dev/root_part]
cryptsetup open [/dev/root_part] root
# EXT4 for encrypted root
mkfs.ext4 /dev/mapper/root
# FAT32 for boot (UEFI)
mkfs.fat -F32 [/dev/boot_part]
# Mount boot (UEFI)
# We mount directly to /boot because the unencrypted
# boot partition will need to house our kernel
mount [/dev/boot_part] /boot
# Mount root
mount /dev/mapper/root /mnt
```

# Initial Setup of the New Filesystem

```bash
# Run pacstrap to install Base Packages
pacstrap /mnt base linux linux-headers linux-firmware nano git
# Generate initial fstab
genfstab -U /mnt >> /mnt/etc/fstab
# chroot into your New System
arch-chroot /mnt
```

# Configuring the New System

```bash
# Set a Password
passwd
# Set Timezone
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
# Enable NTP
timedatectl set-ntp true
timedatectl status
# Set Hardware Clock
hwclock --systohc
# Choose Locales
nano /etc/locale.gen
> en_US.UTF-8 UTF-8 #uncomment this f.E.
# Generate Locales
locale-gen
# Set Keymap
nano /etc/vconsole.conf
> KEYMAP=de-latin1-nodeadkeys
> FONT=eurlatgr
# Set Hostname
nano /etc/hostname            
> yourHostname
# Edit hosts file
nano /etc/hosts
> 127.0.0.1     localhost
> 127.0.1.1     hostname.localdomain    hostname
> ::1           localhost
# Network Setup
pacman -S networkmanager
systemctl enable NetworkManager
```

# Adding a New User

```bash
useradd -m [username]
passwd [username]
usermod -aG wheel,audio,video,network,uucp [username]
```

# Making "wheel" Members Superusers

```bash
# With doas
nano /etc/doas.conf
> permit persist :wheel
>
# With sudo
EDITOR=nano visudo
> %wheel ALL=(ALL) ALL #uncomment this
```

# Installing the Bootloader

## Normal

```bash
# Get a few extra packages
pacman -S grub efibootmgr dosfstools os-prober mtools
# Install GRUB
grub-install --target=x86_64-efi --bootloader-id=Archlinux --recheck
# Generate grub config
grub-mkconfig -o /boot/grub/grub.cfg
```

## With Full Disk Encryption

```bash
# Get a few extra packages
pacman -S grub efibootmgr dosfstools os-prober mtools
# Install GRUB
grub-install --target=x86_64-efi --bootloader-id=Archlinux --recheck
# Edit grub default
nano /etc/default/grub
> GRUB_CMDLINE_LINUX="cryptdevice=UUID=[UUID-of-root_part]:root root=/dev/mapper/root"
> GRUB_ENABLE_CRYPTODISK=y
# Generate grub config
grub-mkconfig -o /boot/grub/grub.cfg
```

# Finishing Up

```bash
# Exit chroot
exit
# Properly unmount the New System
umount -l /mnt
# If running encryted setup
cryptsetup close root
# Reboot
reboot
```
