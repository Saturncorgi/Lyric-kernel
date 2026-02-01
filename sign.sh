updpkgsums
for str in $(ls -1 |grep -v sig|grep -v linux|grep -v PKGBUILD|grep -v src|grep -v pkg); do
echo "Signing: $str"
gpg -u lyra --batch --yes --output "$str.sig" --detach-sig $str
done