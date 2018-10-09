#!/bin/bash

#sips -z  16 16   pic.png  --out tmp.iconset/icon_16x16.png

if [ ! -n "$1" ]
then
	echo "--------------------------------------------------------"
	echo "for example:generate speed.icns with speed.png"
	echo "	$0 speed.png speed.icns"
	echo "or default gen output.png"
	echo "	$0 speed.png "
	echo "--------------------------------------------------------"
	exit
fi

rm -rf tmp.iconset
mkdir tmp.iconset

echo "--------------------------------------------------------"
echo "generate icon_N*N.png  and icon_M*M@2.png"

for i in {16,32,64,128,256,512,1024}
do
	sips -z  $i $i   "$1"  --out "tmp.iconset/icon_${i}x${i}.png"
	if ((($i>16)&&($i<1024)))
	then
		pre=$[$i/2]
		sips -z $i $i   "$1"  --out "tmp.iconset/icon_${pre}x${pre}@2x.png"
	fi
done

echo "--------------------------------------------------------"
if [ ! -n "$2" ]
then
	echo "generate  output.icns"
	iconutil -c icns tmp.iconset  -o output.icns
else
	echo "generate  $2"
	iconutil -c icns tmp.iconset  -o "$2"
fi


rm -rf tmp.iconset



