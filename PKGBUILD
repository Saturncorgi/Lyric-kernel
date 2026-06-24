# Maintainer: Lyra  <lyra@saturncorgi.com>

pkgbase=lyric-kernel
pkgver=7.0.12.arch1
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
sha256sums=('57edc9a41efc1ca6b797afa8f4a587a30da2af6bca7356eb56e1e1a4ada265da'
            'SKIP'
            'ce38af1268931b099993cf01c537d6c3b21007e08cad84d2f1e71f95cc5cb75b'
            'SKIP'
            'f185d06b050a8fd0608189f7d53786734d802872f2c1eefc74196174bca5d094'
            'e04e1a948ac0f43d0d44c60a684fd349115b2656f9c97ae87a84b08a81630b55'
            'SKIP'
            '278820951e152b8a294f48e46cdbc9777eaaa23f2d11ab380e2b56dcb819b9a9'
            'SKIP'
            'f5bb4825c0175255911156bbbd9740da700fe856efe15f0406ea38781b7de872'
            'SKIP'
            'db8f9a10459c76911ca046373f6457f599e8a25765c08f372167a3e0e97da842'
            'SKIP')
b2sums=('2c53f205a940b0f9f68653b92ef46d49f828cbef3cfa8cf94d050c8e6df05c4fcaa4f9b9681b9130b14e3c790d31208eb244d123249a93e35e8e6165f3d858c9'
        'SKIP'
        '26230d1a111b24fe9239273acdfacda37c5bf009f861c448ad25392dcca433514246d629a077ce5c66478c7e0f4e5477ce5f95c91d08b3a02cc87bb35b849bcf'
        'SKIP'
        '90dbd2917fac50d46a1bf3cd5c3997e3c4ae44cecafa042adeeae20c1b605ed1f0e5e85661bf9bc9b8320cdd477f147ee46109c8099d28bdaed900d894ce0a0d'
        '7193cbbcb43fdddd7d19ba8e947d238b27bdf5a2e603286b0ab83e8a47a22af2d6a0f10c95cf469fd38ea9e97382809c27f14e9302bbef5acbcde7db5b79f097'
        'SKIP'
        '4270ec08d803739f8ec36fb77e8041bebd79ca1ae06d6e7207c2c7a06cfb56c1373f7e4031aa0a15359a4c0f96a79993cff57472e0258a3a961827cf9b73889a'
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
  cp config $_srcname/.config.orig
  patch  -p0 -i config.p --follow-symlinks
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
  
  #nice make -j16
  KBUILD_BUILD_TIMESTAMP="Fri Jun 12 00:00:00 UTC 2026"  nice make -j16
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
  #install -Dt "$builddir/rust" -m644 rust/*.rmeta
  #install -Dt "$builddir/rust" rust/*.so

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


