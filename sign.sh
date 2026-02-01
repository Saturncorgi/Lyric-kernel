updpkgsums
rm -rf src
for str in $(ls -1 |grep -v sig|grep -v linux|grep -v PKGBUILD); do
echo "Signing: $str"
gpg -u lyra --batch --yes --output "$str.sig" --detach-sig $str
done