#!/bin/bash
echo "Updating PKGBUILD to new version"
LOCATION="$(cat /etc/lyric-kernel/path.txt)"
cd "$LOCATION"|| exit
cd ..
count=0;
for str in $(curl https://api.github.com/repos/archlinux/linux/tags -s|grep name); do
	if [ "$count" = "1" ];then
		version=$(echo "$str"|sed "s/\"//g"|sed "s/,//g"|sed "s/-/./"|sed "s/v//";)
	fi; 
	count=$((count+1));done
cp PKGBUILD PKGBUILD.old
cat PKGBUILD|sed -r "s/^pkgver.*/pkgver=$version/" > temp.tmp
cp temp.tmp PKGBUILD
rm temp.tmp
diff PKGBUILD.old PKGBUILD
echo "Starting build..."
USER="$(cat /etc/lyric-kernel/user.txt)"
sudo -u "$USER" makepkg -fs
