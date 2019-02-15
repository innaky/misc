function mount-iso () {
    mount -o loop iso mount-iso-dir
}

function extract-iso () {
    rsync -a -H --exclude=TRANS.TBL mount-iso-dir point-to-extract
    umount mount-iso-dir
}

function mount-chroot () {
    for i in /etc/resolv.conf /etc/hosts /etc/hostname; do
	cp -pv $i localchroot/etc/
    done

    mount -t proc proc explained_iso/proc
    mount -t sysfs sysfs explained_iso/sys
    mount -o bind /dev explained_iso/dev
    mount -t devpts pts explained_iso/dev/pts
}

function iso-uefi () {
    md5sum $(find -follow -type f) > md5sum.txt
    xorriso -as mkisofs -iso-level 3 -full-iso9660-filenames \
	    -eltorito-boot isolinux/isolinux.bin \
	    -eltorito-catalog isolinux/boot.cat -no-emul-boot \
	    -boot-load-size 4 -boot-info-table \
	    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
	    -eltorito-alt-boot -e boot/grub/efi.img \
	    -no-emul-boot -isohybrid-gpt-basdat \
	    -output output_uefi.iso .
}

function iso-legacy () {
    md5sum $(find -follow -type f) > md5sum.txt
    xorriso -as mkisofs -R -r -J -joliet-long -l -cache-inodes \
	    -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -partition_offset 16 \
	    -A "Personal ISO GNU/Linux" -b isolinux/isolinux.bin -c isolinux/boot.cat \
	    -no-emul-boot -boot-load-size 4 -boot-info-table -o output.iso .
}
