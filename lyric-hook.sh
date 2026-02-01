#!/bin/bash
echo "Updating PKGBUILD to new version"
LOCATION="$(cat /etc/lyric-kernel/path.txt)"
cd "$LOCATION"|| exit
cd ..
cp PKGBUILD PKGBUILD.old
rm PKGBUILD
curl https://raw.githubusercontent.com/Saturncorgi/Lyric-kernel/refs/heads/main/PKGBUILD > PKGBUILD
chmod 666 PKGBUILD
count=0;
for str in $(curl https://api.github.com/repos/archlinux/linux/tags -s|grep name); do
	if [ "$count" = "1" ];then
		version=$(echo "$str"|sed "s/\"//g"|sed "s/,//g"|sed "s/-/./"|sed "s/v//";)
	fi; 
	count=$((count+1));done
cat PKGBUILD|sed -r "s/^pkgver.*/pkgver=$version/" > temp.tmp
cp temp.tmp PKGBUILD
rm temp.tmp
diff PKGBUILD.old PKGBUILD
echo "Starting build..."
USER="$(cat /etc/lyric-kernel/user.txt)" 
find .  -not -name '*PKGBUILD*' -not -path '*.git*' -not -name '.' -not -name 'src' -not -name 'sign.sh' -print0|xargs -0 rm --
sudo -u "$USER" updpkgsums
sudo -u "$USER" makepkg -C -fcs
