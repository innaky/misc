function mount-iso () {
    mount -o loop iso mount-iso-dir
}

function extract-iso () {
    rsync -a -H --exclude=TRANS.TBL mount-iso-dir point-to-extract
    umount mount-iso-dir
}
