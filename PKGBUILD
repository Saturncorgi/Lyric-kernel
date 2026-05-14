# Maintainer: Lyra  <lyra@saturncorgi.com>

pkgbase=lyric-kernel
pkgver=7.0.7.arch1
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
sha256sums=('c8e1fe86a3aaff2de6f7401383f959283510c389ff84c15ab711c8fbceb25df4'
            'SKIP'
            '4a5fa687751890e3850cdbce18728de631877d0c9290d8a3b2a4fd164cf12c63'
            'SKIP'
            'ca1fe1b2bea9c862ba9b2422e47dcae37b2fbd5f97b2fbd9fe8ff303e0126752'
            'e04e1a948ac0f43d0d44c60a684fd349115b2656f9c97ae87a84b08a81630b55'
            'SKIP'
            '78735cf9f5515751be8d90175624ca387e7e7aa46ab453bed786efc02b997c2f'
            'SKIP'
            'f5bb4825c0175255911156bbbd9740da700fe856efe15f0406ea38781b7de872'
            'SKIP'
            'db8f9a10459c76911ca046373f6457f599e8a25765c08f372167a3e0e97da842'
            'SKIP')
b2sums=('ae7214087a29d81c77b2351a4781ad248726f2e7b0a8ddb75790fd64825032d94ddb9526e979f0a41eb4b4da0bf76c63b1681e915c90f1706de7df0980c249f9'
        'SKIP'
        '26202ba5c3155fb045550a349c5f2d43b79848383bfc2052ba22157350327c1e4b8fd347adbe4f978820f26c49d078bdd438d3cf15ed6d8f6c304926dc086200'
        'SKIP'
        '9644c05ccef1e7d251462cb5b0b8579e39e892f72b1ec390a030fc9b36d5a2888adb3442b6e1700ff4ca0c983921230822b75f243a7e5db082a2140297d6da83'
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


