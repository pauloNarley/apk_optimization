#!/bin/bash
# APK Optimization Tool created by luca020400 and modified by Pizza_Dox

#vars
ver="1.0"
apktool="java -jar bin/apktool.jar"
signapk="java -jar bin/signapk.jar bin/testkey.x509.pem bin/testkey.pk8"
zipalign="./bin/zipalign"

function optimize_apk(){
for apk in `ls *.apk | sed "s/.apk//"`; do
    echo "Optimizing $apk.apk"
    $apktool d -s $apk.apk >/dev/null 2>&1
        for png in `find $1 | grep png`; do
	    ./bin/pngquant $apk/$png >/dev/null 2>&1
        done
    $apktool b -f $apk >/dev/null 2>&1
    mv $apk/dist/$apk.apk "$apk"-optimized.apk
    rm -rf $apk
    $signapk "$apk"-optimized.apk "$apk"-optimized-signed.apk
    $zipalign -f 4 "$apk"-optimized-signed.apk "$apk"-optimized-signed-zipaligned.apk
    echo "$apk.apk optimized"
done
}

#session behaviour
echo "APK Optimizer v$ver"
echo "by luca020400 & Pizza-Dox"
sleep 1;
echo "Press enter to begin..."
read enterkey
sleep 1;
optimize_apk #call optimization function
echo "done!"
