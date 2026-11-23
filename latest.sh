#!/bin/sh
# Makes every formula of the latest release of its project, the last that is no prerelease: with
# update.sh, which leaves alone a formula that is of it already. It asks GitHub with gh.
set -eu
cd "$(dirname "$0")"
for formula in Formula/*.rb; do
	name=$(basename "$formula" .rb)
	tag=$(gh api "repos/miguelangel-nubla/$name/releases/latest" --jq .tag_name)
	./update.sh "$name" "$tag"
done
