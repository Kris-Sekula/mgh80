This is a serial expansion board using popular Motorola MC68B50. 

MGH80 + Expansion board is will run BASIC or "Monitor" style program. 

I use SCMonitor-v100-R3-RC2014-32k-ROM from RC2014 project written by Stephen C Cousins in the United Kingdom.

You can download the monitor from his website.

Note: For this board to work correctly with MGH80 you will need to:
1. Use a 7.3728MHz crystal.
2. Disable onboard IO decoder.
3. Disable onboard IO_WR.

Note: the IO_WR signla was added to MGH80 in PCB ver 1.5, if you are using 1.4 you 
will have to cut the WR link between the Z80 and the 8255, and run IO_WR 
from the 8255 to Z50Bus pin 41. This is only needed for 82C55-2 or
82C55-5 chips, standard CP82C55A works fine.
