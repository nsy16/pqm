# Setup printer

# paths
parentdir="../../.."
parentdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

config=printer-settings.conf

# load config file`
. "$parentdir/$config"


installdiskimage() {
  # install pkg from disk image
  diskimage=$1
  pkgfile=$2
  mkdir /tmp/install
  echo "$diskimage"
  hdiutil attach "$diskimage" -readonly -mountpoint /tmp/install -nobrowse
  echo "/tmp/install/$pkgfile"
  installer -verboseR -allowUntrusted -pkg "/tmp/install/$pkgfile" -target /
  hdiutil detach /tmp/install
  rmdir /tmp/install
}

installpkg() {
  # install pkg file directly
  echo installing "$1" ...
  installer -verboseR -allowUntrusted -pkg "$1" -target /
}



# install DMG
echo ""
echo "Install print drivers"
for (( i=0; i<${#dmg[@]}; i++ ));
do
  installdiskimage "$parentdir/${dmg[$i]}" "${pkg[$i]}"
done


##install print queue
echo ""
echo "Install print queues"
for (( i=0; i<${#pnam[@]}; i++ ));
do
  echo "${pnam[$i]}"
  queuename="${pnam[$i]// /_}" # replace spaces with underscores. -D arguement renames print queue
  # https://www.cups.org/doc/man-lpadmin.html
  lpadmin -p "$queuename" -L "${locn[$i]}" -E -v ipp://${ipad[$i]} -P "/Library/Printers/PPDs/Contents/Resources/${drvr[$i]}" -o printer-is-shared=false
done

## set tray options for this printer - note bash does not support multidimensional arrays so different language may be needed
echo ""
echo "Set Printer Tray Options"
for (( i=0; i<${#pnam[@]}; i++ ));
do
  queuename="${pnam[$i]// /_}"
  lpadmin -p "$queuename" -o "${trayOpt1[$i]}"
  lpadmin -p "$queuename" -o "${trayOpt2[$i]}"
  lpadmin -p "$queuename" -o "${trayOpt3[$i]}"
  lpadmin -p "$queuename" -o "${trayOpt4[$i]}"
  lpadmin -p "$queuename" -o "${trayOpt5[$i]}"
  lpadmin -p "$queuename" -o "${trayOpt6[$i]}"
  lpadmin -p "$queuename" -o "${trayOpt7[$i]}"
  lpadmin -p "$queuename" -o "${trayOpt8[$i]}"
  echo lpadmin -p "$queuename" -o "${trayOpt9[$i]}"
done

## set custom options for this printer - note bash does not support multidimensional arrays so different language may be needed
echo ""
echo "Set Default Options"
for (( i=0; i<${#pnam[@]}; i++ ));
do
  queuename="${pnam[$i]// /_}"
  lpadmin -p "$queuename" -o "${customOpt1[$i]}"
  lpadmin -p "$queuename" -o "${customOpt2[$i]}"
  lpadmin -p "$queuename" -o "${customOpt3[$i]}"
  lpadmin -p "$queuename" -o "${customOpt4[$i]}"
  lpadmin -p "$queuename" -o "${customOpt5[$i]}"
  lpadmin -p "$queuename" -o "${customOpt6[$i]}"
  lpadmin -p "$queuename" -o "${customOpt7[$i]}"
  lpadmin -p "$queuename" -o "${customOpt8[$i]}"
  echo lpadmin -p "$queuename" -o "${customOpt9[$i]}"
done

## rename printers
echo ""
echo "Rename print queues"
for (( i=0; i<${#pnam[@]}; i++ ));
do
  queuename="${pnam[$i]// /_}" # replace spaces with underscores. -D arguement renames print queue
  # https://www.cups.org/doc/man-lpadmin.html
  lpadmin -p "$queuename" -D "${pnam[$i]}"
done
