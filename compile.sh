#!/bin/bash
nasm -f bin -o bootsect bootsect.asm
cat bootsect /dev/zero | dd of=floppyA bs=512 count=2880
qemu-system-x86_64 -boot a -fda floppyA