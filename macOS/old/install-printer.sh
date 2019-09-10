# Setup printer

# paths
parentdir="../../.."

# print driver
#https://support.sharp.net.au/drivers/software_licence.asp?section=COP&filename=MXC52c_1906a_MacOS.dmg
dmg[0]="driver/MXC52c_1906a_MacOS.dmg"
pkg[0]="MX-C52.pkg"

# adobe acrobat (used to set preset)
dmg[1]="AcroRdrDC_1901220036_MUI.dmg"
pkg[1]="AcroRdrDC_1901220036_MUI.pkg"


# printqueue
printname="Workroom_Copier"
location="Head Office"
ip="172.16.3.1"
driver="SHARP MX-5050V.PPD.gz"

## show mode printer supports
#lpoptions -l -p $printname

# tray options
trayOpt[0]="Option1=SSFinisher"
trayOpt[1]="Option2=Installed"
trayOpt[2]="Option3=Installed"
trayOpt[3]="Option5=TandemTrayDrawer"

# custom defaults
# black and white default
customOpt[0]="ARCMode=CMBW"



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
for (( i=0; i<${#dmg[@]}; i++ ));
do
   echo $i
   installdiskimage "$parentdir/${dmg[$i]}" "${pkg[$i]}"
done


##install print queue
echo "Install print queue"
lpadmin -p $printname -L "$location" -E -v ipp://$ip -P "/Library/Printers/PPDs/Contents/Resources/$driver" -o printer-is-shared=false

## set tray options for this printer
echo "Set Printer Tray Options"
for (( i=0; i<${#trayOpt[@]}; i++ ));
do
  lpadmin -p "$printname" -o ${trayOpt[$i]}
done

## set custom options for this printer
echo "Set Default Options"
for (( i=0; i<${#customOpt[@]}; i++ ));
do
  lpadmin -p "$printname" -o ${customOpt[$i]}
done
