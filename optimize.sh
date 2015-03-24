#!/bin/bash

for apk in `ls *.apk | sed "s/.apk//"`; do
    java -jar bin/apktool.jar d -s $apk.apk >/dev/null 2>&1
        for png in `find $1 | grep png`; do
	    ./bin/pngquant $apk/$png >/dev/null 2>&1
        done
    java -jar bin/apktool.jar b -f $apk >/dev/null 2>&1
    mv $apk/dist/$apk.apk "$apk"-optimized.apk
    rm -rf $apk
    java -jar bin/signapk.jar bin/testkey.x509.pem bin/testkey.pk8 "$apk"-optimized.apk "$apk"-optimized-signed.apk
    ./bin/zipalign -f 4 "$apk"-optimized-signed.apk "$apk"-optimized-signed-zipaligned.apk
done
