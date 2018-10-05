#!/bin/sh

# VolWheel - set the volume with your mousewheel
# Author : Olivier Duclos <olivier.duclos gmail.com>

cd `pwd`

PACKAGE=volwheel
VERSION=$(head -n1 ChangeLog | cut -d "v" -f2)
DIR=$HOME/$PACKAGE-$VERSION

mkdir $DIR
cp -R * $DIR/
rm $DIR/release.sh
rm -rf $DIR/*/.svn
rm -rf $DIR/*/*/.svn
cd ~
tar cvzf $PACKAGE-$VERSION.tar.gz $PACKAGE-$VERSION
rm -rf $DIR
