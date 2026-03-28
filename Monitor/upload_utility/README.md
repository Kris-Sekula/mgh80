# Simple upload utility

Here you will find a simple "command line" utility to upload Intel .HEX files to the MGH80 Board

This is a command line program (so simply clicking on it won't do much)

## How to use it:

### Windows executable:

From a command window prompt enter:  
```
mgh80load.exe {filename} {port#} {Y}
```

Where:

**{filename.hex}** - is the name of an intel hex file

**{port#}** - is the serial port number (number only, so put **3** instead of **COM3**) 

**{Y}** - this is optional parameter that will make the board automatically start executing code form address 0x8100h

Example:  
```
mgh80load.exe MGH80_blink.hex 3 Y
```

this will upload the file MGH80_blink.hex to the board using COM3 and start the program after upload


### Python script (linux or macOS):

Microsoft keeps making self compiled program execution more and more difficuilt. If you're having issues staring mgh80load.exe on your computer (or you want to run it on Linux machine)
Install python and run the python script, parameters are the same, here is an example:

From command prompt (or linux shell):

```
python mgh80load.py MGH80_blink.hex 3 Y
```

this will upload the file MGH80_blink.hex to the board using COM3 and start the program after upload

![upload example](https://github.com/Kris-Sekula/mgh80/blob/main/Monitor/upload_utility/upload_example.jpeg)

### Paste HEX file directly to the monitor:

You can also "paste" the content of the hex file into the the monitor window, but keep in mind the device has no flow controll so it is easy to overload it with text.
I succesfully used "TeraTerm" program on Windows, but added 20ms charater delay and 120ms line delay in serial settings. You only need to send data records, here is an example:

```
:1081000000003100913E80D3033E00D300CD1A81A0
:108110003EFFD300CD1A81C3098101010011003057
:0D8120001B7AB3C220810B78B1C21D81C94A
:00000001FF
```

Since we only need "data records" we can skip the last line:

```
:1081000000003100913E80D3033E00D300CD1A81A0
:108110003EFFD300CD1A81C3098101010011003057
:0D8120001B7AB3C220810B78B1C21D81C94A
```

Pasting this into TeraTerm window will "upload" into mgh80 (note there is no echo, for each line it only shows ":" for start of hex record and "*" to confirm the crc was correct for this line.

![upload example 2](https://github.com/Kris-Sekula/mgh80/blob/main/Monitor/upload_utility/TeraTerm.jpeg)

The last "g" command, starts execution.

This is originally based on work described here: https://sites.google.com/site/ericmklaus/projects-1/z80minisystem
