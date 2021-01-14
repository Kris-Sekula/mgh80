EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "mgh80_protoBoard"
Date "2021-01-02"
Rev "1.0"
Comp "MyGeekyHobby.com"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L power:GND #PWR02
U 1 1 5F856D6B
P 6000 5800
F 0 "#PWR02" H 6000 5550 50  0001 C CNN
F 1 "GND" H 6005 5627 50  0000 C CNN
F 2 "" H 6000 5800 50  0001 C CNN
F 3 "" H 6000 5800 50  0001 C CNN
	1    6000 5800
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR01
U 1 1 5F859A95
P 5750 4600
F 0 "#PWR01" H 5750 4450 50  0001 C CNN
F 1 "VCC" H 5767 4773 50  0000 C CNN
F 2 "" H 5750 4600 50  0001 C CNN
F 3 "" H 5750 4600 50  0001 C CNN
	1    5750 4600
	1    0    0    -1  
$EndComp
Wire Wire Line
	6000 5800 6000 5650
Connection ~ 6000 5650
Connection ~ 5750 4650
Wire Wire Line
	5750 4600 5750 4650
Wire Wire Line
	5500 4650 5750 4650
$Comp
L Mechanical:MountingHole_Pad H1
U 1 1 60A5CEED
P 10450 6200
F 0 "H1" H 10550 6203 50  0001 L CNN
F 1 "MountingHole_Pad" H 10550 6158 50  0001 L CNN
F 2 "MountingHole:MountingHole_3mm_Pad_Via" H 10450 6200 50  0001 C CNN
F 3 "~" H 10450 6200 50  0001 C CNN
	1    10450 6200
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H2
U 1 1 60A5DE42
P 10650 6200
F 0 "H2" H 10750 6203 50  0001 L CNN
F 1 "MountingHole_Pad" H 10750 6158 50  0001 L CNN
F 2 "MountingHole:MountingHole_3mm_Pad_Via" H 10650 6200 50  0001 C CNN
F 3 "~" H 10650 6200 50  0001 C CNN
	1    10650 6200
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H3
U 1 1 60A5DF22
P 10850 6200
F 0 "H3" H 10950 6203 50  0001 L CNN
F 1 "MountingHole_Pad" H 10950 6158 50  0001 L CNN
F 2 "MountingHole:MountingHole_3mm_Pad_Via" H 10850 6200 50  0001 C CNN
F 3 "~" H 10850 6200 50  0001 C CNN
	1    10850 6200
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole_Pad H4
U 1 1 60A5E154
P 11050 6200
F 0 "H4" H 11150 6203 50  0001 L CNN
F 1 "MountingHole_Pad" H 11150 6158 50  0001 L CNN
F 2 "MountingHole:MountingHole_3mm_Pad_Via" H 11050 6200 50  0001 C CNN
F 3 "~" H 11050 6200 50  0001 C CNN
	1    11050 6200
	1    0    0    -1  
$EndComp
Wire Wire Line
	11050 6300 10850 6300
Connection ~ 10650 6300
Wire Wire Line
	10650 6300 10450 6300
Connection ~ 10850 6300
Wire Wire Line
	10850 6300 10650 6300
$Comp
L power:GND #PWR03
U 1 1 60A7DCB8
P 10650 6300
F 0 "#PWR03" H 10650 6050 50  0001 C CNN
F 1 "GND" H 10655 6127 50  0000 C CNN
F 2 "" H 10650 6300 50  0001 C CNN
F 3 "" H 10650 6300 50  0001 C CNN
	1    10650 6300
	1    0    0    -1  
$EndComp
Text Notes 10450 6000 0    50   ~ 0
Mounting Holes
Connection ~ 5500 4650
Connection ~ 5500 5650
$Comp
L Connector:TestPoint TP1
U 1 1 5FBC285C
P 4750 4650
F 0 "TP1" H 4808 4722 50  0001 L CNN
F 1 "5V VCC" H 4808 4677 50  0001 L CNN
F 2 "TestPoint:TestPoint_THTPad_D1.5mm_Drill0.7mm" H 4950 4650 50  0001 C CNN
F 3 "~" H 4950 4650 50  0001 C CNN
	1    4750 4650
	1    0    0    -1  
$EndComp
$Comp
L Connector:TestPoint TP3
U 1 1 5FBC3F67
P 5050 4650
F 0 "TP3" H 5108 4722 50  0001 L CNN
F 1 "5V VCC" H 5108 4677 50  0001 L CNN
F 2 "TestPoint:TestPoint_THTPad_D1.5mm_Drill0.7mm" H 5250 4650 50  0001 C CNN
F 3 "~" H 5250 4650 50  0001 C CNN
	1    5050 4650
	1    0    0    -1  
$EndComp
Connection ~ 5050 4650
$Comp
L Connector:TestPoint TP2
U 1 1 5FBC5640
P 4750 5650
F 0 "TP2" H 4808 5722 50  0001 L CNN
F 1 "GND" H 4808 5677 50  0001 L CNN
F 2 "TestPoint:TestPoint_THTPad_D1.5mm_Drill0.7mm" H 4950 5650 50  0001 C CNN
F 3 "~" H 4950 5650 50  0001 C CNN
	1    4750 5650
	-1   0    0    1   
$EndComp
$Comp
L Connector:TestPoint TP4
U 1 1 5FBC5DA8
P 5050 5650
F 0 "TP4" H 5108 5722 50  0001 L CNN
F 1 "GND" H 5108 5677 50  0001 L CNN
F 2 "TestPoint:TestPoint_THTPad_D1.5mm_Drill0.7mm" H 5250 5650 50  0001 C CNN
F 3 "~" H 5250 5650 50  0001 C CNN
	1    5050 5650
	-1   0    0    1   
$EndComp
Connection ~ 5050 5650
Text Notes 4700 5900 0    50   ~ 0
Test Points
Text Notes 4700 4450 0    50   ~ 0
Test Points
$Comp
L power:PWR_FLAG #FLG02
U 1 1 5FBB975B
P 5500 5700
F 0 "#FLG02" H 5500 5775 50  0001 C CNN
F 1 "PWR_FLAG" H 5500 5873 50  0000 C CNN
F 2 "" H 5500 5700 50  0001 C CNN
F 3 "~" H 5500 5700 50  0001 C CNN
	1    5500 5700
	-1   0    0    1   
$EndComp
Wire Wire Line
	5500 5700 5500 5650
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5FF346DB
P 5500 4500
F 0 "#FLG01" H 5500 4575 50  0001 C CNN
F 1 "PWR_FLAG" H 5500 4673 50  0000 C CNN
F 2 "" H 5500 4500 50  0001 C CNN
F 3 "~" H 5500 4500 50  0001 C CNN
	1    5500 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5500 4500 5500 4650
$Comp
L Device:C C5
U 1 1 60597685
P 6250 5150
F 0 "C5" H 6300 5250 50  0000 L CNN
F 1 "100nF" H 6250 5000 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 6288 5000 50  0001 C CNN
F 3 "~" H 6250 5150 50  0001 C CNN
	1    6250 5150
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 60597446
P 6000 5150
F 0 "C4" H 6050 5250 50  0000 L CNN
F 1 "100nF" H 6000 5000 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 6038 5000 50  0001 C CNN
F 3 "~" H 6000 5150 50  0001 C CNN
	1    6000 5150
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 60596AF0
P 5750 5150
F 0 "C3" H 5800 5250 50  0000 L CNN
F 1 "100nF" H 5750 5000 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 5788 5000 50  0001 C CNN
F 3 "~" H 5750 5150 50  0001 C CNN
	1    5750 5150
	1    0    0    -1  
$EndComp
Wire Wire Line
	6000 5300 6000 5650
Wire Wire Line
	5750 4650 6000 4650
Connection ~ 6000 4650
Wire Wire Line
	6000 5000 6000 4650
Wire Wire Line
	5500 5300 5500 5650
Wire Wire Line
	5500 5000 5500 4650
$Comp
L Device:C C2
U 1 1 604B19F1
P 5500 5150
F 0 "C2" H 5550 5250 50  0000 L CNN
F 1 "100nF" H 5500 5000 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 5538 5000 50  0001 C CNN
F 3 "~" H 5500 5150 50  0001 C CNN
	1    5500 5150
	1    0    0    -1  
$EndComp
Wire Wire Line
	6000 4650 6250 4650
Wire Wire Line
	6250 4650 6250 5000
Wire Wire Line
	6000 5650 6250 5650
Wire Wire Line
	6250 5650 6250 5300
Wire Wire Line
	5500 5650 5750 5650
Wire Wire Line
	5750 5650 6000 5650
Connection ~ 5750 5650
Wire Wire Line
	5750 5300 5750 5650
Wire Wire Line
	5750 5000 5750 4650
Text Label 8950 3400 2    50   ~ 0
PB7
Text Label 8100 3400 0    50   ~ 0
PB6
Text Label 8950 3300 2    50   ~ 0
PB5
Text Label 8100 3300 0    50   ~ 0
PB4
Text Label 8950 3200 2    50   ~ 0
PB3
Text Label 8100 3200 0    50   ~ 0
PB2
Text Label 8950 3100 2    50   ~ 0
PB1
Text Label 8100 3100 0    50   ~ 0
PB0
Text Label 8950 2500 2    50   ~ 0
PC1
Text Label 8950 2800 2    50   ~ 0
PC7
Text Label 8100 2800 0    50   ~ 0
PC6
Text Label 8950 2700 2    50   ~ 0
PC5
Text Label 8100 2700 0    50   ~ 0
PC4
Text Label 8950 2600 2    50   ~ 0
PC3
Text Label 8100 2600 0    50   ~ 0
PC2
Text Label 8100 2500 0    50   ~ 0
PC0
Text Label 8950 2200 2    50   ~ 0
PA7
Text Label 8100 2200 0    50   ~ 0
PA6
Text Label 8950 2100 2    50   ~ 0
PA5
Text Label 8100 2100 0    50   ~ 0
PA4
Text Label 8950 2000 2    50   ~ 0
PA3
Text Label 8100 2000 0    50   ~ 0
PA2
Text Label 8950 1900 2    50   ~ 0
PA1
Text Label 8100 1900 0    50   ~ 0
PA0
$Comp
L Connector_Generic:Conn_02x17_Odd_Even J5
U 1 1 5FEA24BE
P 8450 2600
F 0 "J5" H 8500 3450 50  0000 C CNN
F 1 "Conn_02x15_Odd_Even" H 8500 3700 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x17_P2.54mm_Vertical" H 8450 2600 50  0001 C CNN
F 3 "~" H 8450 2600 50  0001 C CNN
	1    8450 2600
	1    0    0    -1  
$EndComp
Text Label 3600 3350 2    50   ~ 0
~ROM_CS
Text Label 1950 3250 0    50   ~ 0
~RAM_CS
Text Label 3600 3250 2    50   ~ 0
~IO_CS
Wire Wire Line
	3600 1350 3250 1350
Wire Wire Line
	3600 1450 3250 1450
Wire Wire Line
	3250 1550 3600 1550
Wire Wire Line
	3250 1750 3600 1750
Wire Wire Line
	3600 1850 3250 1850
Wire Wire Line
	3250 1950 3600 1950
Wire Wire Line
	3600 2050 3250 2050
Wire Wire Line
	3250 2150 3600 2150
Wire Wire Line
	3250 2350 3600 2350
Wire Wire Line
	3600 2450 3250 2450
Wire Wire Line
	3250 2550 3600 2550
Wire Wire Line
	3600 2650 3250 2650
Wire Wire Line
	3250 2750 3600 2750
Wire Wire Line
	3600 2850 3250 2850
Wire Wire Line
	3250 2950 3600 2950
Wire Wire Line
	3600 3050 3250 3050
Wire Wire Line
	2250 3650 1750 3650
Wire Wire Line
	2250 3550 1750 3550
Wire Wire Line
	2250 3450 1750 3450
Wire Wire Line
	1750 3050 2250 3050
Wire Wire Line
	1750 2950 2250 2950
Wire Wire Line
	1750 2850 2250 2850
Wire Wire Line
	1750 2750 2250 2750
Wire Wire Line
	1750 2650 2250 2650
Wire Wire Line
	1750 2550 2250 2550
Wire Wire Line
	1750 2450 2250 2450
Wire Wire Line
	1750 2350 2250 2350
Wire Wire Line
	1750 2250 2250 2250
Wire Wire Line
	1750 2150 2250 2150
Wire Wire Line
	1750 2050 2250 2050
Wire Wire Line
	1750 1950 2250 1950
Wire Wire Line
	1750 1850 2250 1850
Wire Wire Line
	1750 1750 2250 1750
Wire Wire Line
	1750 1650 2250 1650
Wire Wire Line
	1750 1550 2250 1550
Wire Wire Line
	1750 1450 2250 1450
Wire Wire Line
	2250 1350 1750 1350
Text Label 3600 2450 2    50   ~ 0
~INT
Text Label 3600 2350 2    50   ~ 0
~RESET
Text Label 1950 3450 0    50   ~ 0
~NMI
Text Label 1950 3550 0    50   ~ 0
~Wait
Text Label 1950 3650 0    50   ~ 0
~BusRQ
Text Label 3600 3650 2    50   ~ 0
~BusACK
Text Label 3600 3550 2    50   ~ 0
~HALT
Text Label 3600 3450 2    50   ~ 0
~RFSH
Text Label 2000 2350 0    50   ~ 0
~M1
Text Label 2000 2450 0    50   ~ 0
CLK
Text Label 2000 1350 0    50   ~ 0
A15
Text Label 3550 1350 2    50   ~ 0
A14
Text Label 2000 1450 0    50   ~ 0
A13
Text Label 3550 1450 2    50   ~ 0
A12
Text Label 2000 1550 0    50   ~ 0
A11
Text Label 3550 1550 2    50   ~ 0
A10
Text Label 2000 1650 0    50   ~ 0
A9
Text Label 2000 1750 0    50   ~ 0
A7
Text Label 3550 1750 2    50   ~ 0
A6
Text Label 2000 1850 0    50   ~ 0
A5
Text Label 3550 1850 2    50   ~ 0
A4
Text Label 2000 1950 0    50   ~ 0
A3
Text Label 3550 1950 2    50   ~ 0
A2
Text Label 2000 2050 0    50   ~ 0
A1
Text Label 3550 2050 2    50   ~ 0
A0
Text Label 2000 3050 0    50   ~ 0
D7
Text Label 3600 3050 2    50   ~ 0
D6
Text Label 2000 2950 0    50   ~ 0
D5
Text Label 3600 2950 2    50   ~ 0
D4
Text Label 2000 2850 0    50   ~ 0
D3
Text Label 3600 2850 2    50   ~ 0
D2
Text Label 2000 2750 0    50   ~ 0
D1
Text Label 3600 2750 2    50   ~ 0
D0
Text Label 2000 2650 0    50   ~ 0
~IORQ
Text Label 2000 2550 0    50   ~ 0
~MREQ
Text Label 3600 2650 2    50   ~ 0
~RD
Text Label 3600 2550 2    50   ~ 0
~WR
$Comp
L mgh-symbols:Z80Bus J1
U 1 1 5F8CF698
P 2700 2550
F 0 "J1" H 2750 3975 50  0000 C CNN
F 1 "Z80Bus" H 2750 3884 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x25_P2.54mm_Horizontal" H 2200 2100 50  0001 C CNN
F 3 "" H 2400 2100 50  0001 C CNN
	1    2700 2550
	1    0    0    -1  
$EndComp
Text Notes 5950 4600 0    50   ~ 0
100nF Decoupling Capacitors.
Wire Wire Line
	5050 5650 5200 5650
Wire Wire Line
	5200 5650 5500 5650
Connection ~ 5200 5650
Wire Wire Line
	5200 5250 5200 5650
Wire Wire Line
	5050 4650 5200 4650
Wire Wire Line
	5200 4650 5500 4650
Connection ~ 5200 4650
Wire Wire Line
	5200 4650 5200 5050
$Comp
L Device:CP_Small C1
U 1 1 5F9BC7E8
P 5200 5150
F 0 "C1" H 5250 5050 50  0000 L CNN
F 1 "10uF" H 5250 4950 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D6.3mm_P2.50mm" H 5200 5150 50  0001 C CNN
F 3 "~" H 5200 5150 50  0001 C CNN
	1    5200 5150
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 5650 5050 5650
Wire Wire Line
	4750 4650 5050 4650
$Comp
L Connector_Generic:Conn_01x17 J4
U 1 1 60564BB8
P 7550 2600
F 0 "J4" H 7468 3617 50  0000 C CNN
F 1 "Conn_01x17" H 7468 3526 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x17_P2.54mm_Vertical" H 7550 2600 50  0001 C CNN
F 3 "~" H 7550 2600 50  0001 C CNN
	1    7550 2600
	-1   0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x17 J6
U 1 1 605676CF
P 9550 2600
F 0 "J6" H 9630 2642 50  0000 L CNN
F 1 "Conn_01x17" H 9630 2551 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x17_P2.54mm_Vertical" H 9550 2600 50  0001 C CNN
F 3 "~" H 9550 2600 50  0001 C CNN
	1    9550 2600
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x25 J2
U 1 1 6056ACC0
P 1550 2550
F 0 "J2" H 1468 3967 50  0000 C CNN
F 1 "Conn_01x25" H 1468 3876 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x25_P2.54mm_Vertical" H 1550 2550 50  0001 C CNN
F 3 "~" H 1550 2550 50  0001 C CNN
	1    1550 2550
	-1   0    0    -1  
$EndComp
Wire Wire Line
	8750 1900 9350 1900
Wire Wire Line
	8750 2000 9350 2000
Wire Wire Line
	8750 2100 9350 2100
Wire Wire Line
	8750 2200 9350 2200
Wire Wire Line
	8750 2300 9350 2300
Wire Wire Line
	8750 2500 9350 2500
Wire Wire Line
	8750 2600 9350 2600
Wire Wire Line
	8750 2700 9350 2700
Wire Wire Line
	8750 2800 9350 2800
Wire Wire Line
	8750 3100 9350 3100
Wire Wire Line
	8750 3200 9350 3200
Wire Wire Line
	8750 3300 9350 3300
Wire Wire Line
	8750 3400 9350 3400
Wire Wire Line
	7750 1900 8250 1900
Wire Wire Line
	7750 2000 8250 2000
Wire Wire Line
	7750 2100 8250 2100
Wire Wire Line
	7750 2200 8250 2200
Wire Wire Line
	7750 2300 8250 2300
Wire Wire Line
	7750 2500 8250 2500
Wire Wire Line
	7750 2600 8250 2600
Wire Wire Line
	7750 2700 8250 2700
Wire Wire Line
	7750 2800 8250 2800
Wire Wire Line
	7750 2900 8250 2900
Wire Wire Line
	7750 3100 8250 3100
Wire Wire Line
	7750 3200 8250 3200
Wire Wire Line
	7750 3300 8250 3300
Wire Wire Line
	7750 3400 8250 3400
Wire Wire Line
	8750 2900 9350 2900
Wire Wire Line
	3250 3650 3600 3650
Wire Wire Line
	3600 3550 3250 3550
Wire Wire Line
	3250 3450 3600 3450
Wire Wire Line
	3250 3350 3600 3350
Wire Wire Line
	3250 3250 3600 3250
$Comp
L Connector_Generic:Conn_01x25 J3
U 1 1 605691E2
P 3800 2550
F 0 "J3" H 3880 2592 50  0000 L CNN
F 1 "Conn_01x25" H 3880 2501 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x25_P2.54mm_Vertical" H 3800 2550 50  0001 C CNN
F 3 "~" H 3800 2550 50  0001 C CNN
	1    3800 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	3600 1650 3250 1650
Text Label 3550 1650 2    50   ~ 0
A8
Wire Wire Line
	3250 3150 3600 3150
Wire Wire Line
	3250 3750 3600 3750
Wire Wire Line
	3250 2250 3600 2250
Text Label 3600 2250 2    50   ~ 0
VCC
Text Label 3600 2150 2    50   ~ 0
GND
Text Label 2000 2150 0    50   ~ 0
GND
Text Label 2000 2250 0    50   ~ 0
VCC
Wire Wire Line
	2250 3750 1750 3750
Wire Wire Line
	2250 3350 1750 3350
Wire Wire Line
	1750 3250 2250 3250
Wire Wire Line
	2250 3150 1750 3150
Text Label 4800 5650 0    50   ~ 0
GND
Text Label 4800 4650 0    50   ~ 0
VCC
Text Label 8250 3000 2    50   ~ 0
VCC
Text Label 8250 2400 2    50   ~ 0
VCC
Text Label 8250 1800 2    50   ~ 0
VCC
Text Label 8950 1800 2    50   ~ 0
GND
Text Label 8950 2400 2    50   ~ 0
GND
Text Label 8950 3000 2    50   ~ 0
GND
Wire Wire Line
	8750 3000 9350 3000
Wire Wire Line
	8750 2400 9350 2400
Wire Wire Line
	8750 1800 9350 1800
Wire Wire Line
	7750 3000 8250 3000
Wire Wire Line
	7750 2400 8250 2400
Wire Wire Line
	7750 1800 8250 1800
$EndSCHEMATC
