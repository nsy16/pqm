# pqm
printqueuemanager

Define printer settings in printer-settings.conf. Use Install Printer app to quickly deploy printers to your end users.

How to compile a dmg for end users

Open Platypus. Select Script and point it at install-printers.sh. Change interface to Progress Bar.

Tick Run with root privileges.
 
Untick Remain running after execution.

Drop your driver folder and printer-settings.conf into Bundled Files.

Click Create App.

Create a folder with site name, eg school-printers. Move the newly created binary install-printers.app here and any pdf or documents for the end user into the folder. Drop this folder into DropDMG.

DropDMG will generate a dmg which can be downloaded and distributed to users. The install-printers.app can be run directly from here. Note you will have to right click > Open to allow the unsigned install-printers.app to run.
