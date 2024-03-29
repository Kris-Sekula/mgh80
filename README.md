# mgh80 - "The Arduino of the 80s"

![picture of v1.4c](https://github.com/Kris-Sekula/mgh80/blob/main/pictures/1.4b_assembled.jpg)

This 5 chip Z80 single-board "computer", is a very simple Z80 based "controller" with 8255 for I/O plus a ["Z50Bus"](http://linc.no/products/z50bus/) expansion connector. I created it to kick-start my Z80 experiments - breadboarding is fun, but sometimes you want the basics to "just work" so you don't have to troubleshoot loose wires :) 

Features an option to use a local crystal-based oscillator or oscillator module. There is an onboard selector to choose between 27c256 EPROM and 28C256 EEPROM.

Onboard address decoder:
* ROM at 0000h - 7FFFh
* RAM at 8000h - FFFFh
* IO at 00h (IOPortA)
* IO at 01h (IOPortB)
* IO at 02h (IOPortC)
* IO at 03h (Control)

A few solder jumpers allow disconnecting various onboard options (if you for example want to provide an external address decoder)... In the basic configuration you should link (with a solder blob) the following:
* JP1 - enable internal CLK source
* JP2 - enable internal IO(8255) address decoder
* JP3 - enable internal ROM address decoder
* JP4 - enable internal RAM address decoder
* JP7 - set 8255 reset pin to GND (bypass R5)
* JP8 - enable onboard LED for port A0 on the 8255
* JP9 - enable onboard IO_WR singal

Simple "blinky" program source (.asm) included and a compiled hex files (.hex) for 27C256 EPROM (or my EPROM emulator). It will toggle all lines of port A a few times a second.

Get your PCBs from [PCBWAY](https://www.pcbway.com/project/shareproject/mgh80___the_Arduino_of_the_80s__simple_z80_based__microcontroller____sbc_.html)

A few component kits are listed on [eBay](https://www.ebay.com/sch/avr4sale/m.html?_nkw=&_armrs=1&_ipg=&_from=)

If you found this helpful and you like the work I do, why not buy me a coffee, thanks ! :)

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/R6R52KGCD)
