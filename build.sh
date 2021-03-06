#!/bin/bash

# Capitaine cursors, macOS inspired cursors based on KDE Breeze
# Copyright (c) 2016 Keefer Rourke <keefer.rourke@gmail.com>

# generate pixmaps from svg source
SRC=$PWD/src

cd "$SRC"
mkdir -p x1 x1_25 x1_5 x2
cd "$SRC"/svg
# find . -name "*.svg" -type f -exec sh -c 'inkscape -z -e "../x1/${0%.svg}.png" -w 32 -h 32 $0' {} \;
# find . -name "*.svg" -type f -exec sh -c 'inkscape -z -e "../x1_25/${0%.svg}.png" -w 40 -w 40 $0' {} \;
# find . -name "*.svg" -type f -exec sh -c 'inkscape -z -e "../x1_5/${0%.svg}.png" -w 48 -w 48 $0' {} \;
# find . -name "*.svg" -type f -exec sh -c 'inkscape -z -e "../x2/${0%.svg}.png" -w 64 -w 64 $0' {} \;
for i in $(find . -name "*.svg" -type f)
do 
  convert -size 32x32 -background none $i  ../x1/${i/\.svg/.png}
  convert -size 40x40 -background none $i  ../x1_25/${i/\.svg/.png}
  convert -size 48x48 -background none $i  ../x1_5/${i/\.svg/.png}
  convert -size 64x64 -background none $i  ../x2/${i/\.svg/.png}
done

cd $SRC

# generate cursors
BUILD="$SRC"/../dist
OUTPUT="$BUILD"/cursors
ALIASES="$SRC"/cursorList

if [ ! -d "$BUILD" ]; then
    mkdir "$BUILD"
fi
if [ ! -d "$OUTPUT" ]; then
    mkdir "$OUTPUT"
fi

echo -ne "Generating cursor theme...\\r"
for CUR in config/*.cursor; do
	BASENAME="$CUR"
	BASENAME="${BASENAME##*/}"
	BASENAME="${BASENAME%.*}"
	
	xcursorgen "$CUR" "$OUTPUT/$BASENAME"
done
echo -e "Generating cursor theme... DONE"

cd "$OUTPUT"	

#generate aliases
echo -ne "Generating shortcuts...\\r"
while read ALIAS; do
	FROM="${ALIAS#* }"
	TO="${ALIAS% *}"

	if [ -e $TO ]; then
		continue
	fi
	ln -sr "$FROM" "$TO"
done < "$ALIASES"
echo -e "Generating shortcuts... DONE"

cd "$PWD"

echo -ne "Generating Theme Index...\\r"
INDEX="$OUTPUT/../index.theme"
if [ ! -e "$OUTPUT/../$INDEX" ]; then
	touch "$INDEX"
	echo -e "[Icon Theme]\nName=Capitaine Cursors\n" > "$INDEX"
fi
echo -e "Generating Theme Index... DONE"
