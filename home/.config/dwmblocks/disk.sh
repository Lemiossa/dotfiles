#!/bin/sh
ICON=""

ROOT_DEV=$(findmnt -n -o SOURCE /)

DISK=$(lsblk -no PKNAME "$ROOT_DEV" 2>/dev/null)

[ -z "$DISK" ] && echo "$ICON 0.0%" && exit 0

TOTAL=$(lsblk -b -dn -o SIZE "/dev/$DISK")

USED_ROOT=$(df -B1 / | awk 'NR==2 {print $3}')

USED_EFI=$(df -B1 /boot/efi 2>/dev/null | awk 'NR==2 {print $3}')
[ -z "$USED_EFI" ] && USED_EFI=0

USED_SWAP=$(lsblk -b -no NAME,TYPE,SIZE,PKNAME | awk -v d="$DISK" '
$2 == "part" && $4 == d {
  if (system("swapon --noheadings --raw | grep -q /dev/"$1) == 0)
    sum += $3
}
END { print sum+0 }
')

USED=$((USED_ROOT + USED_EFI + USED_SWAP))

awk -v u="$USED" -v t="$TOTAL" 'BEGIN {
  if (t > 0)
    printf "%.1f%%\n", (u/t)*100
  else
    print "0.0%"
}' | sed "s/^/$ICON /"
