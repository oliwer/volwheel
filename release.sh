#!/bin/sh -eu

# VolWheel - set the volume with your mousewheel
# Author : Olivier Duclos <olivier.duclos gmail.com>

cd "$(dirname $0)"

PACKAGE=volwheel
VERSION=$(head -n1 ChangeLog | cut -d "v" -f2)
DIR=$HOME/$PACKAGE-$VERSION

rm -rf $DIR
mkdir $DIR
cp -R * $DIR/
rm $DIR/release.sh
cd ~
tar cvzf $PACKAGE-$VERSION.tar.gz $PACKAGE-$VERSION
rm -rf $DIR
