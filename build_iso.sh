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
