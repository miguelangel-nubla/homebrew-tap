#!/bin/sh
# Makes a formula of a version: its source is the one of the tag given, and its checksum that
# source's. The formulae build from source, so there is nothing else of a version in them.
#
#	./update.sh ipv6ddns v1.2.3
#
# The update workflow does it, for the latest release of each project.
set -eu
cd "$(dirname "$0")"
name=$1 tag=$2
formula=Formula/$name.rb

url="https://github.com/miguelangel-nubla/$name/archive/refs/tags/$tag.tar.gz"
sha=$(curl -fsSL "$url" | shasum -a 256 | cut -d' ' -f1)

# Each of the two lines, once: a formula that has them otherwise is not changed in part.
[ "$(grep -c '^  url "' "$formula")" = 1 ] && [ "$(grep -c '^  sha256 "' "$formula")" = 1 ] || {
	echo "update: $formula has not one url and one sha256" >&2
	exit 1
}
tmp=$(mktemp)
sed -E "s|^  url \".*\"\$|  url \"$url\"|; s|^  sha256 \".*\"\$|  sha256 \"$sha\"|" "$formula" >"$tmp"
cat "$tmp" >"$formula"
rm -f "$tmp"
echo "update: $formula is of $tag, $sha"
