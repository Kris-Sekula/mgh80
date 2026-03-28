# Simple upload utility

Here you will find a simple "command line" utility to upload Intel .HEX files to the MGH80 Board

This is a command line program (so simply clicking on it won't do much)

## How to use it:

### Windows executable:

From a command window prompt enter:  `mgh80load.exe {filename} {port#} {Y}`

Where: 
{filename.hex} is the name of an intel hex file

{port#} is the serial port number (number only, so put **3** instead of **COM3**) 

{Y} this is optional parameter that will make the board automatically start executing code form address 0x8100h

Example:  `mgh80load.exe MGH80_blink.hex 3 Y`

this will upload the file MGH80_blink.hex to the board using COM3 and start the program after upload


### Python script (linux or macOS):

Microsoft keeps making self compiled program execution more and more difficuilt. If you're having issues staring mgh80load.exe on your computer (or you want to run it on Linux machine)
Install python and run the python script, parameters are the same, here is an example:

From command prompt (or linux shell):

python mgh80load.py MGH80_blink.hex 3 Y

this will upload the file MGH80_blink.hex to the board using COM3 and start the program after upload

![picture of v1.4c](https://github.com/Kris-Sekula/mgh80/blob/main/Monitor/upload_utility/upload_example.jpeg)

 
This is originally based on work described here: https://sites.google.com/site/ericmklaus/projects-1/z80minisystem
