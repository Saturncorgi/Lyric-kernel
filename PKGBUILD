# Maintainer: Lyra  <lyra@saturncorgi.com>

pkgbase=lyric-kernel
pkgver=7.0.8.arch1
pkgrel=1
pkgdesc='Linux but tux is trans'
url='https://github.com/Saturncorgi/Lyric-kernel'
arch=(x86_64)
license=(GPL-2.0-only)
makedepends=(
  bc
  cpio
  gettext
  libelf
  pahole
  perl
  python
  rust
  rust-bindgen
  rust-src
  tar
  xz
  distcc
  ccache
  # htmldocs
  graphviz
  imagemagick
  python-sphinx
  python-yaml
  texlive-latexextra
)
options=(
  !debug
  !strip
)
_srcname=linux-${pkgver%.*}
_srctag=v${pkgver%.*}-${pkgver##*.}
source=(
  https://cdn.kernel.org/pub/linux/kernel/v${pkgver%%.*}.x/${_srcname}.tar.{xz,sign}
  https://github.com/archlinux/linux/releases/download/$_srctag/linux-$_srctag.patch.zst{,.sig}
  https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/raw/main/config.x86_64  # the main kernel config file
  https://raw.githubusercontent.com/Saturncorgi/Lyric-kernel/refs/heads/main/logo.patch{,.sig}
  https://raw.githubusercontent.com/Saturncorgi/Lyric-kernel/refs/heads/main/config.p{,.sig}
  https://raw.githubusercontent.com/Saturncorgi/Lyric-kernel/refs/heads/main/lyric.hook{,.sig}
  https://raw.githubusercontent.com/Saturncorgi/Lyric-kernel/refs/heads/main/lyric-hook.sh{,.sig}
)
validpgpkeys=(
  ABAF11C65A2970B130ABE3C479BE3E4300411886  # Linus Torvalds
  647F28654894E3BD457199BE38DBBDC86092693E  # Greg Kroah-Hartman
  83BC8889351B5DEBBB68416EB8AC08600F108CDF  # Jan Alexander Steffens (heftig)
  96244C1D0A5FDD46A331BC86779AF29DE2EA127E  # Lyra
)
# https://www.kernel.org/pub/linux/kernel/v6.x/sha256sums.asc
sha256sums=('1945afb22c9f4f7c78d971210f3bbb7deb09f5d8c41a38bfac772de25f6dcb22'
            'SKIP'
            'e2d13dc37abdd8ddb6b3e2767d2b8310c2342b56458d2cc73c414a9b50d767ab'
            'SKIP'
            '3861f45a8f5803f2dd901e1c2293296b78f0142c802139040a5f0d040eefa594'
            'e04e1a948ac0f43d0d44c60a684fd349115b2656f9c97ae87a84b08a81630b55'
            'SKIP'
            '78735cf9f5515751be8d90175624ca387e7e7aa46ab453bed786efc02b997c2f'
            'SKIP'
            'f5bb4825c0175255911156bbbd9740da700fe856efe15f0406ea38781b7de872'
            'SKIP'
            'db8f9a10459c76911ca046373f6457f599e8a25765c08f372167a3e0e97da842'
            'SKIP')
b2sums=('f608ac413f686d3d84ca7bb3d42fa96802e05a7fe8dd8ad6671bb26a8bd5202595cdbbaaee142f94fd9028ed2de832205523766673719960e20b5c0daebdae4b'
        'SKIP'
        '4d64f226336e535c04579cc41386c534ff71ff3653eee725c91ce2e7fc9e4e679b128ed9c40f6d63c85fc8345c7426f974ecb470413fa434507783c783e3ac7a'
        'SKIP'
        'c6260a3252fc2ffbefbb93389d03ee938e399be986eda24d00992b3834d7242e3866f05a3a07dde1da5c641fe737e0b0ff25159d1f31035b50e3923b4a671b4f'
        '7193cbbcb43fdddd7d19ba8e947d238b27bdf5a2e603286b0ab83e8a47a22af2d6a0f10c95cf469fd38ea9e97382809c27f14e9302bbef5acbcde7db5b79f097'
        'SKIP'
        '4a6f5fc064dda0bad30d8b64fe7e1242e4704f5d5bf0437f382a125a3ec71f1dd7e0be9649c65599a76204b73afb49a185e86057f02dcf935797d80edcc7d87e'
        'SKIP'
        '2332aa371fbf17e2860bf96cde3c2897ad36b06c30d55a2e3fa04c919c86fd1ce3e88892d5a2e7d3dae69c31fb3e09aa5863189c202a3822180ee6420767eb0b'
        'SKIP'
        'ab0d9d7b74e2b45a265577446179350692542d9c1638aa8bb62d57de9b0bfcaf8c1f66fa49617cf9c7a643143e71e921f64a2250f348ae5b20e78469ac99e06a'
        'SKIP')

export KBUILD_BUILD_HOST=archlinux
export KBUILD_BUILD_USER=$pkgbase
export KBUILD_BUILD_TIMESTAMP="$(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})"

prepare() {
  whoami > user.txt
  echo $PWD > path.txt
  mv config.x86_64 config
  cd $_srcname
  echo "Setting version..."
  echo "-$pkgrel" > localversion.10-pkgrel
  echo "${pkgbase#linux}" > localversion.20-pkgname
  local src
  for src in "${source[@]}"; do
    src="${src%%::*}"
    src="${src##*/}"
    src="${src%.zst}"
    [[ $src = *.patch ]] || continue
    echo "Applying patch $src..."
    patch -Np1 < "../$src"
  done
  cd ..
  echo "Applying patching config"
  patch  -i config.p --follow-symlinks
  cd $_srcname
  echo "Setting config..."
  cp ../config .config
  make olddefconfig
  diff -u ../config .config || :
  make -s kernelrelease > version
  echo "Prepared $pkgbase version $(<version)"
}

build() {
  cd $_srcname
  
  CCACHE_PREFIX="distcc" KBUILD_BUILD_TIMESTAMP="Mon Oct 13 00:00:00 UTC 2025" nice make CC="ccache cc" all -j25
  make -C tools/bpf/bpftool vmlinux.h feature-clang-bpf-co-re=1 -j16
}

_package() {
  pkgdesc="The $pkgdesc kernel and modules"
  depends=(
    coreutils
    initramfs
    kmod
  )
  optdepends=(
    'linux-firmware: firmware images needed for some devices'
    'scx-scheds: to use sched-ext schedulers'
    'wireless-regdb: to set the correct wireless channels of your country'
  )
  provides=(
    KSMBD-MODULE
    NTSYNC-MODULE
    VIRTUALBOX-GUEST-MODULES
    WIREGUARD-MODULE
  )
  replaces=(
    virtualbox-guest-modules-arch
    wireguard-arch
  )
  install -Dm644 -t "$pkgdir"/etc/$pkgbase user.txt
  install -Dm644 -t "$pkgdir"/etc/$pkgbase path.txt
  #Install hooks
  #install -Dm744 -t "$pkgdir"/etc/pacman.d/hooks/ ../lyric.hook
  #install -Dm744 -t "$pkgdir"/etc/pacman.d/hooks.bin/ ../lyric-hook.sh
  cd $_srcname
  local modulesdir="$pkgdir/usr/lib/modules/$(<version)"

  echo "Installing boot image..."
  # systemd expects to find the kernel here to allow hibernation
  # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
  install -Dm644 "$(make -s image_name)" "$modulesdir/vmlinuz"

  # Used by mkinitcpio to name the kernel
  echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir/pkgbase"

  echo "Installing modules..."
  ZSTD_CLEVEL=19 make INSTALL_MOD_PATH="$pkgdir/usr" INSTALL_MOD_STRIP=1 \
    DEPMOD=/doesnt/exist modules_install  # Suppress depmod

  # remove build link
  rm "$modulesdir"/build
}

_package-headers() {
  pkgdesc="Headers and scripts for building modules for the $pkgdesc kernel"
  depends=(pahole)

  cd $_srcname
  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  echo "Installing build files..."
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map \
    localversion.* version vmlinux tools/bpf/bpftool/vmlinux.h
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/x86" -m644 arch/x86/Makefile
  cp -t "$builddir" -a scripts
  ln -srt "$builddir" "$builddir/scripts/gdb/vmlinux-gdb.py"

  # required when STACK_VALIDATION is enabled
  install -Dt "$builddir/tools/objtool" tools/objtool/objtool

  # required when DEBUG_INFO_BTF_MODULES is enabled
  install -Dt "$builddir/tools/bpf/resolve_btfids" tools/bpf/resolve_btfids/resolve_btfids

  echo "Installing headers..."
  cp -t "$builddir" -a include
  cp -t "$builddir/arch/x86" -a arch/x86/include
  install -Dt "$builddir/arch/x86/kernel" -m644 arch/x86/kernel/asm-offsets.s

  install -Dt "$builddir/drivers/md" -m644 drivers/md/*.h
  install -Dt "$builddir/net/mac80211" -m644 net/mac80211/*.h

  # https://bugs.archlinux.org/task/13146
  install -Dt "$builddir/drivers/media/i2c" -m644 drivers/media/i2c/msp3400-driver.h

  # https://bugs.archlinux.org/task/20402
  install -Dt "$builddir/drivers/media/usb/dvb-usb" -m644 drivers/media/usb/dvb-usb/*.h
  install -Dt "$builddir/drivers/media/dvb-frontends" -m644 drivers/media/dvb-frontends/*.h
  install -Dt "$builddir/drivers/media/tuners" -m644 drivers/media/tuners/*.h

  # https://bugs.archlinux.org/task/71392
  install -Dt "$builddir/drivers/iio/common/hid-sensors" -m644 drivers/iio/common/hid-sensors/*.h

  echo "Installing KConfig files..."
  find . -name 'Kconfig*' -exec install -Dm644 {} "$builddir/{}" \;

  echo "Installing Rust files..."
  install -Dt "$builddir/rust" -m644 rust/*.rmeta
  install -Dt "$builddir/rust" rust/*.so

  echo "Installing unstripped VDSO..."
  make INSTALL_MOD_PATH="$pkgdir/usr" vdso_install \
    link=  # Suppress build-id symlinks

  echo "Removing unneeded architectures..."
  local arch
  for arch in "$builddir"/arch/*/; do
    [[ $arch = */x86/ ]] && continue
    echo "Removing $(basename "$arch")"
    rm -r "$arch"
  done

  echo "Removing documentation..."
  rm -r "$builddir/Documentation"

  echo "Removing broken symlinks..."
  find -L "$builddir" -type l -printf 'Removing %P\n' -delete

  echo "Removing loose objects..."
  find "$builddir" -type f -name '*.o' -printf 'Removing %P\n' -delete

  echo "Stripping build tools..."
  local file
  while read -rd '' file; do
    case "$(file -Sib "$file")" in
      application/x-sharedlib\;*)      # Libraries (.so)
        strip -v $STRIP_SHARED "$file" ;;
      application/x-archive\;*)        # Libraries (.a)
        strip -v $STRIP_STATIC "$file" ;;
      application/x-executable\;*)     # Binaries
        strip -v $STRIP_BINARIES "$file" ;;
      application/x-pie-executable\;*) # Relocatable binaries
        strip -v $STRIP_SHARED "$file" ;;
    esac
  done < <(find "$builddir" -type f -perm -u+x ! -name vmlinux -print0)

  echo "Stripping vmlinux..."
  strip -v $STRIP_STATIC "$builddir/vmlinux"

  echo "Adding symlink..."
  mkdir -p "$pkgdir/usr/src"
  ln -sr "$builddir" "$pkgdir/usr/src/$pkgbase"
}

_package-docs() {
  pkgdesc="Documentation for the $pkgdesc kernel"

  cd $_srcname
  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  echo "Installing documentation..."
  local src dst
  while read -rd '' src; do
    dst="${src#Documentation/}"
    dst="$builddir/Documentation/${dst#output/}"
    install -Dm644 "$src" "$dst"
  done < <(find Documentation -name '.*' -prune -o ! -type d -print0)

  echo "Adding symlink..."
  mkdir -p "$pkgdir/usr/share/doc"
  ln -sr "$builddir/Documentation" "$pkgdir/usr/share/doc/$pkgbase"
}

pkgname=(
  "$pkgbase"
  "$pkgbase-headers"
)
for _p in "${pkgname[@]}"; do
  eval "package_$_p() {
    $(declare -f "_package${_p#$pkgbase}")
    _package${_p#$pkgbase}
  }"
done


