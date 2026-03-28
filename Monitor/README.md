# Simple machine code monitor for MGH80

This is a simple machine code monitor with bit-banged serial port. You can use it on mgh80 by connecting USB-TTL serial adapter as follows:

 External Signal | MGH80 J5
--- | ---
RX | PC3
TX | PC4

** The code is optimised for 4MHz clock frequency **

Example:

![connect pcb 1.5](https://github.com/Kris-Sekula/mgh80/blob/main/Monitor/Connect_1.5.jpeg)

If you use PCB v 1.7, I added a port for connectivity:


![connect pcb 1.7](https://github.com/Kris-Sekula/mgh80/blob/main/Monitor/Connect_1.7.jpeg)


I'll shorty share the PCB 1.7 desing files, but for now you can find Gerbers on [PcbWay](https://www.pcbway.com/project/shareproject/mgh80___the_Arduino_of_the_80s__simple_z80_based__microcontroller____sbc_.html)

The monitor offers various commands, hitting "m" displays the full menu:

```
  *** MGH80 - Started ***

>m
 ****** MGH80 Monitor   ***  *** [V8.3mgh 01/2026]  ******
 d  Dump Memory(16 bytes)  D  Dump Memory(256 bytes)
 S  Set Memory             T  ASCI bytes to Memory
 L  LIST                   A  ASSEMBLE
 G  Run from address       g  Run from 8100H
 B  Start BASIC            C  Clear Screen
 O  Write I/O Port         I  Read I/O Port
 f  Flash LEDs 10x         t  Beep Test
 @  Sync                   M/m  Main Menu
 :  Get iHEX Rec.(no echo)
 ;  Send iHEX Rec.(no echo)

>
```

The code includes also BASIC


This is originally based on work of Eric M. Klaus as described here: https://sites.google.com/site/ericmklaus/projects-1/z80minisystem
