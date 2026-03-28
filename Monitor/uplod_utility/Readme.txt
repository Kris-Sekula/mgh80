

Z80pgmr.exe is a command line utility to upload Intel .HEX files to the Z80 Board

described here: https://sites.google.com/site/ericmklaus/projects-1/z80minisystem

This is a command line program (so simply clicking on it won't help much)

From a command window enter:  Z80pgmr {filename} {port#}
where {filename} is the name of an intel hex file and {port#} is the number 
from the COM port used by your USB-Serial adapter (find this in device manager)

NOTE: the {port#} paramater is just the number like "3" NOT "COM3"

Example:  Z80pgmr game1.hex 5
  this will upload the file game1.hex to the Z80 board using COM5

Z80pgmr.cbp is a CodeBlocks project file if you want to use the CodeBlocks
IDE to build the utility.  
 
