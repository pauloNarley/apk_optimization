#!/bin/bash
# APK Optimization Tool created by luca020400 and modified by Pizza_Dox

#vars
ver="2.1"
apktool="java -jar bin/apktool.jar"
signapk="java -jar bin/signapk.jar bin/testkey.x509.pem bin/testkey.pk8"
zipalign="./bin/zipalign"
opt_sign=0
opt_zipalign=0
opt_spec_apk=0

usage()
{
    echo ""
    echo "Usage :"
    echo "  optimize.sh [options]"
    echo ""
    echo "  Default :"
    echo "    Optimize the APKs"
    echo ""
    echo "  Options :"
    echo "    -f Allow Specifing APK/APKs"
    echo "    -s Sign the APK/APKs"
    echo "    -z Zipalign and Sign the APK/APKs"
    echo "    -h Show this help dialog"
    echo ""
    echo "  Example :"
    echo "    ./optimize.sh -z"
    echo ""
    exit 1
}

while getopts "f:hsz" opt; do
    case $opt in
        f) opt_spec_apk=1 && fapks="$OPTARG" ;;
        s) opt_sign=1 ;;
        z) opt_zipalign=1 ;;
        h|*) usage ;;
    esac
done
shift $((OPTIND-1))

apk_check(){
if [ ! -e *.apk ]; then
    echo "There isn't any .apk to optimize"
    exit 1
fi

if [ $opt_spec_apk -eq 1 ]; then
    for apk in "$fapks"; do
        apks=$(echo -e "$apks\n$apk")
    done
    apks=$(echo $apks | sed "s/.apk//g")
else
    apks=`ls *.apk | sed "s/.apk//g"`
fi
}

optimize_apk(){
for apk in $apks; do
    echo "Optimizing $apk.apk"
    $apktool d -s $apk.apk >/dev/null 2>&1
        for png in `find $1 | grep png | sed "s/mipmap//g"`; do
            ./bin/pngquant $apk/$png >/dev/null 2>&1
        done
    $apktool b -f $apk >/dev/null 2>&1
    mv $apk/dist/$apk.apk "$apk"-optimized.apk
    rm -rf $apk
    if [ $opt_sign -eq 1 ] || [ $opt_zipalign -eq 1 ]; then
        echo "Signing $apk.apk"
        $signapk "$apk"-optimized.apk "$apk"-optimized-signed.apk
    fi
    if [ $opt_zipalign -eq 1 ]; then
        echo "Zipaligning $apk.apk"
    	$zipalign -f 4 "$apk"-optimized-signed.apk "$apk"-optimized-signed-zipaligned.apk
    fi
    echo "$apk.apk optimized!"
done
}

#session behaviour
echo "APK Optimizer v$ver"
echo "by luca020400 & Pizza-Dox"
sleep 1;
apk_check #check for apks
optimize_apk #optimize apks
echo "Done !"
