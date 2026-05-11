# Maintainer: Lyra  <lyra@saturncorgi.com>

pkgbase=lyric-kernel
pkgver=7.0.6.arch1
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
sha256sums=('cba44440aa57affd7c21241dc5bc234b0df53c499f8ffc3ebc290dd3390a7523'
            'SKIP'
            'cf3f8e6dc3c71a25e3f76ede780d0653d73b3d13f224f52350eb6d2e51d1b6f4'
            'SKIP'
            '9fb185362b3b01ab71b8da11057bc0bd4b6e4526d6be770e62bf70eaf118232a'
            'e04e1a948ac0f43d0d44c60a684fd349115b2656f9c97ae87a84b08a81630b55'
            'SKIP'
            '7b1d4e783270d4abb5e443881744b5e92ff2c8dd772b911583cf4ccc423b4906'
            'SKIP'
            'f5bb4825c0175255911156bbbd9740da700fe856efe15f0406ea38781b7de872'
            'SKIP'
            'e6da66e7ae71266f9c67f2e2187990ba6bb30ecc517687f2c7bd971fcf95dfbf'
            'SKIP')
b2sums=('0e8640c77249b251b22f162b8eb21d062308c4a5d16e3942882fbfbbb50a3ac981ad14db8e5612fb9e0a26f8f3a2c6bb07f0309e26ea59323430f780d22b2821'
        'SKIP'
        '21900beb3994169ee9bc82842f4f663ee22cce0117a05c1ae8b4fb62372e7bf47c37ed7cbd289f919c4afd0182ca35d33d6f0c5aeb6663ce3034c97cc71c089c'
        'SKIP'
        '74d7d779f0762352fc681258feda68f725032c1ab5cf436f7ea6be699d60404d2fb7a985d22d95a45b2acf77eef08b3aa8d23088ffec0db4dd7a7661a29cf3bc'
        '7193cbbcb43fdddd7d19ba8e947d238b27bdf5a2e603286b0ab83e8a47a22af2d6a0f10c95cf469fd38ea9e97382809c27f14e9302bbef5acbcde7db5b79f097'
        'SKIP'
        '99973b8471c3a6b56fbf9d03c5d7b53fdff4a0038a07de96faa4f8c6777a22583e86920641eee790d164650988adc34185f67ab213c633a8053cb01c36e2b067'
        'SKIP'
        '2332aa371fbf17e2860bf96cde3c2897ad36b06c30d55a2e3fa04c919c86fd1ce3e88892d5a2e7d3dae69c31fb3e09aa5863189c202a3822180ee6420767eb0b'
        'SKIP'
        'f8d39cd36b7243fbac2803b0f9234d557d013fb971de26d53d1602c906ce513051c89903ad72c0adc746777dd149fc784d9211a77c599773ba3b8151ded4c2d9'
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
  patch  -Ri config.p --follow-symlinks
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
  make all -j16
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
  install -Dm744 -t "$pkgdir"/etc/pacman.d/hooks/ ../lyric.hook
  install -Dm744 -t "$pkgdir"/etc/pacman.d/hooks.bin/ ../lyric-hook.sh
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


