#################################################
#                                               #
#       Author: fluctlights                     #
#       Name: clean_disks.sh                    #
#       Purpose: fix unclean NTFS partitions    #
#                                               #
#################################################


#!/bin/bash

all_disks=""
disk=""
i=""

# Just in case, deleting the disks file
rm disks.txt >/dev/null 2>&1 &

# Program MUST be run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Installing dependencies
echo "Installing required dependencies"
apt install ntfs-3g -y

# Getting all disks and then setting newlines to do a batch ntfsfix
all_disks=$(blkid | grep -w 'TYPE="ntfs"' | grep -o '/dev/sd..')
disk=$(tr -s \  '\n' <<< "$all_disks" >> disks.txt)

# ntfsfix for each disk
while IFS= read -r line
do
   ntfsfix "$line"
done < "./disks.txt"

# removing the file created
rm disks.txt