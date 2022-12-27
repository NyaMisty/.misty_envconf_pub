if [[ "$(uname -s)" =~ ^MSYS_NT.* ]]; then

# allow real symlink
export MSYS=winsymlinks:nativestrict
export MSYSTEM=MSYS

# complete hard drives in msys2
drives=$(mount | sed -rn 's#^[A-Z]: on /([a-z]).*#\1#p' | tr '\n' ' ')
zstyle ':completion:*' fake-files /: "/:$drives"
unset drives

fi
