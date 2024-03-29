#!/bin/sh

# Setup printer
# v 1.2
# last updated - 2019/09/19


# paths
# only works if file is not marked as downloaded quarantined ### xattr -r -d com.apple.quarantine ~/Downloads/ ### unlocks
# files/folders must be attached within Platypus - https://sveinbjorn.org/files/manpages/PlatypusDocumentation.html#how-do-i-get-the-path-to-my-application-and-or-bundled-files-from-within-the-script-
##parentdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
##parentdir="$parentdir/../../.." 

config=printer-settings.conf

# load config file`
PROGRESS:5\n
. "$config"


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
PROGRESS:10\n
echo ""
echo "Install print drivers"
for (( i=0; i<${#dmg[@]}; i++ ));
do
  installdiskimage "${dmg[$i]}" "${pkg[$i]}"
done


##install print queue
#
## show connected print ports
## lpstat -s
PROGRESS:60\n
echo ""
echo "Install print queues"
for (( i=0; i<${#pnam[@]}; i++ ));
do
  echo "${pnam[$i]}"
  queuename="${pnam[$i]// /_}" # replace spaces with underscores. -D argument renames print queue
  # https://www.cups.org/doc/man-lpadmin.html
  lpadmin -p "$queuename" -L "${locn[$i]}" -E -v ${conn[$i]} -P "/Library/Printers/PPDs/Contents/Resources/${drvr[$i]}" -o printer-is-shared=false
done

## set tray options for this printer - note bash does not support multidimensional arrays so different language may be needed
#
## show mode printer supports
## lpoptions -l -p $printname
PROGRESS:70\n
echo ""
echo "Set Printer Tray Options"
for (( i=0; i<${#pnam[@]}; i++ ));
do
  queuename="${pnam[$i]// /_}"
  if [ ! -z "${trayOpt1[$i]+x}" ]; then lpadmin -p "$queuename" -o "${trayOpt1[$i]}"; fi
  if [ ! -z "${trayOpt2[$i]+x}" ]; then lpadmin -p "$queuename" -o "${trayOpt2[$i]}"; fi
  if [ ! -z "${trayOpt3[$i]+x}" ]; then lpadmin -p "$queuename" -o "${trayOpt3[$i]}"; fi
  if [ ! -z "${trayOpt4[$i]+x}" ]; then lpadmin -p "$queuename" -o "${trayOpt4[$i]}"; fi
  if [ ! -z "${trayOpt5[$i]+x}" ]; then lpadmin -p "$queuename" -o "${trayOpt5[$i]}"; fi
  if [ ! -z "${trayOpt6[$i]+x}" ]; then lpadmin -p "$queuename" -o "${trayOpt6[$i]}"; fi
  if [ ! -z "${trayOpt7[$i]+x}" ]; then lpadmin -p "$queuename" -o "${trayOpt7[$i]}"; fi
  if [ ! -z "${trayOpt8[$i]+x}" ]; then lpadmin -p "$queuename" -o "${trayOpt8[$i]}"; fi
  if [ ! -z "${trayOpt9[$i]+x}" ]; then lpadmin -p "$queuename" -o "${trayOpt9[$i]}"; fi
done

## set custom options for this printer - note bash does not support multidimensional arrays so different language may be needed
PROGRESS:80\n
echo ""
echo "Set Default Options"
for (( i=0; i<${#pnam[@]}; i++ ));
do
  queuename="${pnam[$i]// /_}"
  if [ ! -z "${customOpt1[$i]+x}" ]; then lpadmin -p "$queuename" -o "${customOpt1[$i]}"; fi
  if [ ! -z "${customOpt2[$i]+x}" ]; then lpadmin -p "$queuename" -o "${customOpt2[$i]}"; fi
  if [ ! -z "${customOpt3[$i]+x}" ]; then lpadmin -p "$queuename" -o "${customOpt3[$i]}"; fi
  if [ ! -z "${customOpt4[$i]+x}" ]; then lpadmin -p "$queuename" -o "${customOpt4[$i]}"; fi
  if [ ! -z "${customOpt5[$i]+x}" ]; then lpadmin -p "$queuename" -o "${customOpt5[$i]}"; fi
  if [ ! -z "${customOpt6[$i]+x}" ]; then lpadmin -p "$queuename" -o "${customOpt6[$i]}"; fi
  if [ ! -z "${customOpt7[$i]+x}" ]; then lpadmin -p "$queuename" -o "${customOpt7[$i]}"; fi
  if [ ! -z "${customOpt8[$i]+x}" ]; then lpadmin -p "$queuename" -o "${customOpt8[$i]}"; fi
  if [ ! -z "${customOpt9[$i]+x}" ]; then lpadmin -p "$queuename" -o "${customOpt9[$i]}"; fi
done

## rename printers
PROGRESS:90\n
echo ""
echo "Rename print queues"
for (( i=0; i<${#pnam[@]}; i++ ));
do
  queuename="${pnam[$i]// /_}" # replace spaces with underscores. -D arguement renames print queue
  # https://www.cups.org/doc/man-lpadmin.html
  lpadmin -p "$queuename" -D "${pnam[$i]}"
done
