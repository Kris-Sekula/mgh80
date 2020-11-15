EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Z80 Single-board Computer"
Date "2020-11-14"
Rev "1.1"
Comp "MyGeekyHobby.com"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L mgh-symbols:HM62256B U3
U 1 1 5F83EB4D
P 5450 1950
F 0 "U3" H 5525 2915 50  0000 C CNN
F 1 "HM62256B" H 5550 2800 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm_Socket_LongPads" H 5450 1950 50  0001 C CNN
F 3 "" H 5450 1950 50  0001 C CNN
	1    5450 1950
	1    0    0    -1  
$EndComp
$Comp
L Memory_EPROM:27C256 U4
U 1 1 5F8421C6
P 7250 2150
F 0 "U4" H 7400 3350 50  0000 C CNN
F 1 "27C256" H 7500 3250 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm_Socket_LongPads" H 7250 2150 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0014.pdf" H 7250 2150 50  0001 C CNN
	1    7250 2150
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U1
U 1 1 5F842ED6
P 1650 6050
F 0 "U1" H 1650 6375 50  0000 C CNN
F 1 "74HC00" H 1650 6284 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 1650 6050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 1650 6050 50  0001 C CNN
	1    1650 6050
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U1
U 2 1 5F8453F8
P 2750 5950
F 0 "U1" H 2750 6275 50  0000 C CNN
F 1 "74HC00" H 2750 6184 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 2750 5950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 2750 5950 50  0001 C CNN
	2    2750 5950
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U1
U 3 1 5F846746
P 7750 5800
F 0 "U1" H 7750 6125 50  0000 C CNN
F 1 "74HC00" H 7750 6034 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 7750 5800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 7750 5800 50  0001 C CNN
	3    7750 5800
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC00 U1
U 4 1 5F848457
P 8800 5700
F 0 "U1" H 8800 6025 50  0000 C CNN
F 1 "74HC00" H 8800 5934 50  0000 C CNN
F 2 "Package_DIP:DIP-14_W7.62mm_Socket_LongPads" H 8800 5700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 8800 5700 50  0001 C CNN
	4    8800 5700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5F849849
P 1600 6350
F 0 "R1" V 1700 6300 50  0000 C CNN
F 1 "470k" V 1800 6350 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 1530 6350 50  0001 C CNN
F 3 "~" H 1600 6350 50  0001 C CNN
	1    1600 6350
	0    1    1    0   
$EndComp
$Comp
L Device:R R2
U 1 1 5F84A31C
P 2250 6450
F 0 "R2" H 2180 6404 50  0000 R CNN
F 1 "2.2k" H 2180 6495 50  0000 R CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 2180 6450 50  0001 C CNN
F 3 "~" H 2250 6450 50  0001 C CNN
	1    2250 6450
	-1   0    0    1   
$EndComp
$Comp
L Device:C C1
U 1 1 5F84BAF9
P 950 7050
F 0 "C1" H 835 7004 50  0000 R CNN
F 1 "22pF" H 835 7095 50  0000 R CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 988 6900 50  0001 C CNN
F 3 "~" H 950 7050 50  0001 C CNN
	1    950  7050
	-1   0    0    1   
$EndComp
$Comp
L Device:C C2
U 1 1 5F84C4A3
P 2250 7050
F 0 "C2" H 2365 7096 50  0000 L CNN
F 1 "22pF" H 2365 7005 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 2288 6900 50  0001 C CNN
F 3 "~" H 2250 7050 50  0001 C CNN
	1    2250 7050
	1    0    0    -1  
$EndComp
$Comp
L Interface:8255A U5
U 1 1 5F84D0AE
P 9100 2550
F 0 "U5" H 9400 4150 50  0000 C CNN
F 1 "8255A" H 9450 4050 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_Socket_LongPads" H 9100 2850 50  0001 C CNN
F 3 "http://aturing.umcs.maine.edu/~meadow/courses/cos335/Intel8255A.pdf" H 9100 2850 50  0001 C CNN
	1    9100 2550
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D1
U 1 1 5F852F7C
P 4200 7100
F 0 "D1" V 4147 7178 50  0000 L CNN
F 1 "LED" V 4238 7178 50  0000 L CNN
F 2 "LED_THT:LED_D3.0mm" H 4200 7100 50  0001 C CNN
F 3 "~" H 4200 7100 50  0001 C CNN
	1    4200 7100
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C5
U 1 1 5F854DB2
P 4400 5250
F 0 "C5" H 4515 5296 50  0000 L CNN
F 1 "1uF" H 4515 5205 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D5.0mm_P2.50mm" H 4438 5100 50  0001 C CNN
F 3 "~" H 4400 5250 50  0001 C CNN
	1    4400 5250
	1    0    0    -1  
$EndComp
$Comp
L Device:R R4
U 1 1 5F855541
P 4400 4700
F 0 "R4" H 4470 4746 50  0000 L CNN
F 1 "10k" H 4470 4655 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 4330 4700 50  0001 C CNN
F 3 "~" H 4400 4700 50  0001 C CNN
	1    4400 4700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR013
U 1 1 5F856A3C
P 4150 5650
F 0 "#PWR013" H 4150 5400 50  0001 C CNN
F 1 "GND" H 4155 5477 50  0000 C CNN
F 2 "" H 4150 5650 50  0001 C CNN
F 3 "" H 4150 5650 50  0001 C CNN
	1    4150 5650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR016
U 1 1 5F856D6B
P 5300 7550
F 0 "#PWR016" H 5300 7300 50  0001 C CNN
F 1 "GND" H 5305 7377 50  0000 C CNN
F 2 "" H 5300 7550 50  0001 C CNN
F 3 "" H 5300 7550 50  0001 C CNN
	1    5300 7550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR04
U 1 1 5F85749E
P 950 7250
F 0 "#PWR04" H 950 7000 50  0001 C CNN
F 1 "GND" H 955 7077 50  0000 C CNN
F 2 "" H 950 7250 50  0001 C CNN
F 3 "" H 950 7250 50  0001 C CNN
	1    950  7250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR09
U 1 1 5F857C8A
P 2250 7250
F 0 "#PWR09" H 2250 7000 50  0001 C CNN
F 1 "GND" H 2255 7077 50  0000 C CNN
F 2 "" H 2250 7250 50  0001 C CNN
F 3 "" H 2250 7250 50  0001 C CNN
	1    2250 7250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR012
U 1 1 5F8583EB
P 3650 4200
F 0 "#PWR012" H 3650 3950 50  0001 C CNN
F 1 "GND" H 3655 4027 50  0000 C CNN
F 2 "" H 3650 4200 50  0001 C CNN
F 3 "" H 3650 4200 50  0001 C CNN
	1    3650 4200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR025
U 1 1 5F858C87
P 9100 4300
F 0 "#PWR025" H 9100 4050 50  0001 C CNN
F 1 "GND" H 9105 4127 50  0000 C CNN
F 2 "" H 9100 4300 50  0001 C CNN
F 3 "" H 9100 4300 50  0001 C CNN
	1    9100 4300
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR015
U 1 1 5F859A95
P 5050 6350
F 0 "#PWR015" H 5050 6200 50  0001 C CNN
F 1 "VCC" H 5067 6523 50  0000 C CNN
F 2 "" H 5050 6350 50  0001 C CNN
F 3 "" H 5050 6350 50  0001 C CNN
	1    5050 6350
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR014
U 1 1 5F85AB75
P 4400 4450
F 0 "#PWR014" H 4400 4300 50  0001 C CNN
F 1 "VCC" H 4417 4623 50  0000 C CNN
F 2 "" H 4400 4450 50  0001 C CNN
F 3 "" H 4400 4450 50  0001 C CNN
	1    4400 4450
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR011
U 1 1 5F85AE98
P 3650 900
F 0 "#PWR011" H 3650 750 50  0001 C CNN
F 1 "VCC" H 3667 1073 50  0000 C CNN
F 2 "" H 3650 900 50  0001 C CNN
F 3 "" H 3650 900 50  0001 C CNN
	1    3650 900 
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR019
U 1 1 5F85BFCD
P 6050 950
F 0 "#PWR019" H 6050 800 50  0001 C CNN
F 1 "VCC" H 6067 1123 50  0000 C CNN
F 2 "" H 6050 950 50  0001 C CNN
F 3 "" H 6050 950 50  0001 C CNN
	1    6050 950 
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR021
U 1 1 5F85C5F9
P 7250 900
F 0 "#PWR021" H 7250 750 50  0001 C CNN
F 1 "VCC" H 7267 1073 50  0000 C CNN
F 2 "" H 7250 900 50  0001 C CNN
F 3 "" H 7250 900 50  0001 C CNN
	1    7250 900 
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR024
U 1 1 5F85CEED
P 9100 800
F 0 "#PWR024" H 9100 650 50  0001 C CNN
F 1 "VCC" H 9117 973 50  0000 C CNN
F 2 "" H 9100 800 50  0001 C CNN
F 3 "" H 9100 800 50  0001 C CNN
	1    9100 800 
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR03
U 1 1 5F85D84A
P 950 5800
F 0 "#PWR03" H 950 5650 50  0001 C CNN
F 1 "VCC" H 967 5973 50  0000 C CNN
F 2 "" H 950 5800 50  0001 C CNN
F 3 "" H 950 5800 50  0001 C CNN
	1    950  5800
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR08
U 1 1 5F85E6A2
P 2250 5800
F 0 "#PWR08" H 2250 5650 50  0001 C CNN
F 1 "VCC" H 2267 5973 50  0000 C CNN
F 2 "" H 2250 5800 50  0001 C CNN
F 3 "" H 2250 5800 50  0001 C CNN
	1    2250 5800
	1    0    0    -1  
$EndComp
$Comp
L Device:R R3
U 1 1 5F85EE2A
P 4200 6700
F 0 "R3" H 4270 6746 50  0000 L CNN
F 1 "330R" H 4270 6655 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P7.62mm_Horizontal" V 4130 6700 50  0001 C CNN
F 3 "~" H 4200 6700 50  0001 C CNN
	1    4200 6700
	1    0    0    -1  
$EndComp
Wire Wire Line
	9100 4150 9100 4300
Wire Wire Line
	4200 6950 4200 6850
Wire Wire Line
	4200 6400 4200 6550
Wire Wire Line
	9100 950  9100 800 
Wire Wire Line
	7250 1050 7250 900 
Wire Wire Line
	5950 1250 6050 1250
Wire Wire Line
	6050 1250 6050 950 
Wire Wire Line
	3650 1000 3650 900 
Wire Wire Line
	7450 5700 7300 5700
Wire Wire Line
	7300 5700 7300 5800
Wire Wire Line
	7300 5900 7450 5900
Wire Wire Line
	9250 5700 9100 5700
Text Label 6250 1500 2    50   ~ 0
~RAM_CS
Wire Wire Line
	6250 1500 5950 1500
Text Label 6500 3050 0    50   ~ 0
~MREQ
Wire Wire Line
	6500 3050 6850 3050
Text Label 6250 1400 2    50   ~ 0
~WR
Wire Wire Line
	6250 1400 5950 1400
Text Label 8200 1750 0    50   ~ 0
~WR
Text Label 8200 1650 0    50   ~ 0
~RD
Text Label 7300 4550 0    50   ~ 0
~IORQ
Wire Wire Line
	8400 1550 8200 1550
Wire Wire Line
	8400 1650 8200 1650
Wire Wire Line
	8400 1750 8200 1750
$Comp
L power:GND #PWR023
U 1 1 5F86BCD7
P 8250 1250
F 0 "#PWR023" H 8250 1000 50  0001 C CNN
F 1 "GND" V 8255 1122 50  0000 R CNN
F 2 "" H 8250 1250 50  0001 C CNN
F 3 "" H 8250 1250 50  0001 C CNN
	1    8250 1250
	0    1    1    0   
$EndComp
Wire Wire Line
	8400 1250 8250 1250
Wire Wire Line
	6850 2950 6500 2950
Text Label 6250 1600 2    50   ~ 0
~MREQ
Wire Wire Line
	6250 1600 5950 1600
Wire Wire Line
	8050 5800 8500 5800
Text Label 8300 5600 0    50   ~ 0
A15
Wire Wire Line
	8500 5600 8300 5600
Text Label 6900 5800 0    50   ~ 0
~MREQ
Wire Wire Line
	6900 5800 7300 5800
Connection ~ 7300 5800
Wire Wire Line
	7300 5800 7300 5900
Wire Wire Line
	4400 4850 4400 4950
Wire Wire Line
	4400 5400 4400 5550
Wire Wire Line
	4400 5550 4150 5550
Wire Wire Line
	4150 5650 4150 5550
Wire Wire Line
	5050 6750 5050 6400
Wire Wire Line
	5050 7050 5050 7400
Wire Wire Line
	5050 7400 5300 7400
Wire Wire Line
	5550 7400 5550 7050
Wire Wire Line
	5300 7550 5300 7400
Connection ~ 5300 7400
Wire Wire Line
	5300 7400 5550 7400
Wire Wire Line
	950  7250 950  7200
Wire Wire Line
	2250 7250 2250 7200
Wire Wire Line
	1950 6050 2050 6050
Wire Wire Line
	2250 6050 2250 6300
Wire Wire Line
	2250 6600 2250 6800
Wire Wire Line
	2250 6800 1750 6800
Connection ~ 2250 6800
Wire Wire Line
	2250 6800 2250 6900
Wire Wire Line
	1450 6800 950  6800
Wire Wire Line
	950  6800 950  6900
Wire Wire Line
	950  6800 950  6150
Wire Wire Line
	950  6150 1150 6150
Connection ~ 950  6800
$Comp
L Device:Crystal Y1
U 1 1 5F84AE99
P 1600 6800
F 0 "Y1" H 1600 6550 50  0000 C CNN
F 1 "4MHz" H 1600 6450 50  0000 C CNN
F 2 "Crystal:Crystal_HC18-U_Horizontal_1EP_style2" H 1600 6800 50  0001 C CNN
F 3 "~" H 1600 6800 50  0001 C CNN
	1    1600 6800
	1    0    0    -1  
$EndComp
Wire Wire Line
	1750 6350 2050 6350
Wire Wire Line
	2050 6350 2050 6050
Connection ~ 2050 6050
Wire Wire Line
	2050 6050 2250 6050
Wire Wire Line
	1450 6350 1150 6350
Wire Wire Line
	1150 6350 1150 6150
Connection ~ 1150 6150
Wire Wire Line
	1150 6150 1350 6150
Wire Wire Line
	2450 6050 2250 6050
Connection ~ 2250 6050
Wire Wire Line
	2250 5850 2250 5800
Wire Wire Line
	1350 5950 950  5950
Wire Wire Line
	950  5950 950  5800
Text Label 3500 5950 2    50   ~ 0
CLK
Wire Wire Line
	3100 5950 3050 5950
Text Label 2700 1600 0    50   ~ 0
CLK
Wire Wire Line
	2950 1600 2700 1600
Text Label 5050 4950 2    50   ~ 0
~RESET
Wire Wire Line
	5050 4950 4750 4950
Connection ~ 4400 4950
Wire Wire Line
	4400 4950 4400 5100
Text Label 2700 1300 0    50   ~ 0
~RESET
Wire Wire Line
	2950 1300 2700 1300
$Comp
L power:GND #PWR022
U 1 1 5F8AE107
P 7250 3400
F 0 "#PWR022" H 7250 3150 50  0001 C CNN
F 1 "GND" H 7255 3227 50  0000 C CNN
F 2 "" H 7250 3400 50  0001 C CNN
F 3 "" H 7250 3400 50  0001 C CNN
	1    7250 3400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7250 3400 7250 3250
$Comp
L power:GND #PWR017
U 1 1 5F8B1F53
P 6000 2850
F 0 "#PWR017" H 6000 2600 50  0001 C CNN
F 1 "GND" H 6005 2677 50  0000 C CNN
F 2 "" H 6000 2850 50  0001 C CNN
F 3 "" H 6000 2850 50  0001 C CNN
	1    6000 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	5950 2650 6000 2650
Wire Wire Line
	6000 2650 6000 2850
Wire Wire Line
	3650 4200 3650 4000
Text Label 2700 3200 0    50   ~ 0
~MREQ
Text Label 2700 3100 0    50   ~ 0
~WR
Text Label 2700 3000 0    50   ~ 0
~RD
Wire Wire Line
	2950 3000 2700 3000
Wire Wire Line
	2950 3100 2700 3100
Wire Wire Line
	2950 3200 2700 3200
Text Label 2700 3300 0    50   ~ 0
~IORQ
Wire Wire Line
	2950 3300 2700 3300
Text Label 7800 1250 2    50   ~ 0
D0
Text Label 7800 1350 2    50   ~ 0
D1
Text Label 7800 1450 2    50   ~ 0
D2
Text Label 7800 1550 2    50   ~ 0
D3
Text Label 7800 1650 2    50   ~ 0
D4
Text Label 7800 1750 2    50   ~ 0
D5
Text Label 7800 1850 2    50   ~ 0
D6
Text Label 7800 1950 2    50   ~ 0
D7
Wire Wire Line
	7800 1250 7650 1250
Wire Wire Line
	7800 1350 7650 1350
Wire Wire Line
	7800 1450 7650 1450
Wire Wire Line
	7800 1550 7650 1550
Wire Wire Line
	7800 1650 7650 1650
Wire Wire Line
	7800 1750 7650 1750
Wire Wire Line
	7800 1850 7650 1850
Wire Wire Line
	7800 1950 7650 1950
Text Label 8250 2450 0    50   ~ 0
D0
Text Label 8250 2550 0    50   ~ 0
D1
Text Label 8250 2650 0    50   ~ 0
D2
Text Label 8250 2750 0    50   ~ 0
D3
Text Label 8250 2850 0    50   ~ 0
D4
Text Label 8250 2950 0    50   ~ 0
D5
Text Label 8250 3050 0    50   ~ 0
D6
Text Label 8250 3150 0    50   ~ 0
D7
Wire Wire Line
	8250 3150 8400 3150
Wire Wire Line
	8250 3050 8400 3050
Wire Wire Line
	8250 2950 8400 2950
Wire Wire Line
	8250 2850 8400 2850
Wire Wire Line
	8250 2750 8400 2750
Wire Wire Line
	8250 2650 8400 2650
Wire Wire Line
	8250 2550 8400 2550
Wire Wire Line
	8250 2450 8400 2450
Text Label 4500 3000 2    50   ~ 0
D0
Text Label 4500 3100 2    50   ~ 0
D1
Text Label 4500 3200 2    50   ~ 0
D2
Text Label 4500 3300 2    50   ~ 0
D3
Text Label 4500 3400 2    50   ~ 0
D4
Text Label 4500 3500 2    50   ~ 0
D5
Text Label 4500 3600 2    50   ~ 0
D6
Text Label 4500 3700 2    50   ~ 0
D7
Wire Wire Line
	4500 3700 4350 3700
Wire Wire Line
	4500 3600 4350 3600
Wire Wire Line
	4500 3500 4350 3500
Wire Wire Line
	4500 3400 4350 3400
Wire Wire Line
	4500 3300 4350 3300
Wire Wire Line
	4500 3200 4350 3200
Wire Wire Line
	4500 3100 4350 3100
Wire Wire Line
	4500 3000 4350 3000
Text Label 6100 2500 2    50   ~ 0
D0
Text Label 6100 2400 2    50   ~ 0
D1
Text Label 6100 2300 2    50   ~ 0
D2
Text Label 6100 2200 2    50   ~ 0
D3
Text Label 6100 2100 2    50   ~ 0
D4
Text Label 6100 2000 2    50   ~ 0
D5
Text Label 6100 1900 2    50   ~ 0
D6
Wire Wire Line
	6100 1800 5950 1800
Wire Wire Line
	6100 1900 5950 1900
Wire Wire Line
	6100 2000 5950 2000
Wire Wire Line
	6100 2100 5950 2100
Wire Wire Line
	6100 2200 5950 2200
Wire Wire Line
	6100 2300 5950 2300
Wire Wire Line
	6100 2400 5950 2400
Wire Wire Line
	6100 2500 5950 2500
Text Label 6100 1800 2    50   ~ 0
D7
Text Label 4900 1250 0    50   ~ 0
A14
Text Label 4900 1350 0    50   ~ 0
A13
Text Label 4900 1450 0    50   ~ 0
A12
Text Label 4900 1550 0    50   ~ 0
A11
Text Label 4900 1650 0    50   ~ 0
A10
Text Label 4900 1750 0    50   ~ 0
A9
Text Label 4900 1850 0    50   ~ 0
A8
Text Label 4900 1950 0    50   ~ 0
A7
Text Label 4900 2050 0    50   ~ 0
A6
Text Label 4900 2150 0    50   ~ 0
A5
Text Label 4900 2250 0    50   ~ 0
A4
Text Label 4900 2350 0    50   ~ 0
A3
Text Label 4900 2450 0    50   ~ 0
A2
Text Label 4900 2550 0    50   ~ 0
A1
Text Label 4900 2650 0    50   ~ 0
A0
Wire Wire Line
	5100 2650 4900 2650
Wire Wire Line
	5100 2550 4900 2550
Wire Wire Line
	5100 2450 4900 2450
Wire Wire Line
	5100 2350 4900 2350
Wire Wire Line
	5100 2250 4900 2250
Wire Wire Line
	5100 2150 4900 2150
Wire Wire Line
	5100 2050 4900 2050
Wire Wire Line
	5100 1950 4900 1950
Wire Wire Line
	5100 1850 4900 1850
Wire Wire Line
	5100 1750 4900 1750
Wire Wire Line
	5100 1650 4900 1650
Wire Wire Line
	4900 1550 5100 1550
Wire Wire Line
	5100 1450 4900 1450
Wire Wire Line
	5100 1350 4900 1350
Wire Wire Line
	5100 1250 4900 1250
Text Label 4550 2700 2    50   ~ 0
A14
Text Label 4550 2600 2    50   ~ 0
A13
Text Label 4550 2500 2    50   ~ 0
A12
Text Label 4550 2400 2    50   ~ 0
A11
Text Label 4550 2300 2    50   ~ 0
A10
Text Label 4550 2200 2    50   ~ 0
A9
Text Label 4550 2100 2    50   ~ 0
A8
Text Label 4550 2000 2    50   ~ 0
A7
Text Label 4550 1900 2    50   ~ 0
A6
Text Label 4550 1800 2    50   ~ 0
A5
Text Label 4550 1700 2    50   ~ 0
A4
Text Label 4550 1600 2    50   ~ 0
A3
Text Label 4550 1500 2    50   ~ 0
A2
Text Label 4550 1400 2    50   ~ 0
A1
Text Label 4550 1300 2    50   ~ 0
A0
Wire Wire Line
	4350 1300 4550 1300
Wire Wire Line
	4350 1400 4550 1400
Wire Wire Line
	4350 1500 4550 1500
Wire Wire Line
	4350 1600 4550 1600
Wire Wire Line
	4350 1700 4550 1700
Wire Wire Line
	4350 1800 4550 1800
Wire Wire Line
	4350 1900 4550 1900
Wire Wire Line
	4350 2000 4550 2000
Wire Wire Line
	4350 2100 4550 2100
Wire Wire Line
	4350 2200 4550 2200
Wire Wire Line
	4350 2300 4550 2300
Wire Wire Line
	4550 2400 4350 2400
Wire Wire Line
	4350 2500 4550 2500
Wire Wire Line
	4350 2600 4550 2600
Wire Wire Line
	4350 2700 4550 2700
Text Label 4550 2800 2    50   ~ 0
A15
Wire Wire Line
	4350 2800 4550 2800
Text Label 6150 3650 2    50   ~ 0
A14
Text Label 6650 2550 0    50   ~ 0
A13
Text Label 6650 2450 0    50   ~ 0
A12
Text Label 6650 2350 0    50   ~ 0
A11
Text Label 6650 2250 0    50   ~ 0
A10
Text Label 6650 2150 0    50   ~ 0
A9
Text Label 6650 2050 0    50   ~ 0
A8
Text Label 6650 1950 0    50   ~ 0
A7
Text Label 6650 1850 0    50   ~ 0
A6
Text Label 6650 1750 0    50   ~ 0
A5
Text Label 6650 1650 0    50   ~ 0
A4
Text Label 6650 1550 0    50   ~ 0
A3
Text Label 6650 1450 0    50   ~ 0
A2
Text Label 6650 1350 0    50   ~ 0
A1
Text Label 6650 1250 0    50   ~ 0
A0
Wire Wire Line
	6850 1250 6650 1250
Wire Wire Line
	6850 1350 6650 1350
Wire Wire Line
	6850 1450 6650 1450
Wire Wire Line
	6850 1550 6650 1550
Wire Wire Line
	6850 1650 6650 1650
Wire Wire Line
	6850 1750 6650 1750
Wire Wire Line
	6850 1850 6650 1850
Wire Wire Line
	6850 1950 6650 1950
Wire Wire Line
	6850 2050 6650 2050
Wire Wire Line
	6850 2150 6650 2150
Wire Wire Line
	6850 2250 6650 2250
Wire Wire Line
	6650 2350 6850 2350
Wire Wire Line
	6850 2450 6650 2450
Wire Wire Line
	6850 2550 6650 2550
Text Label 8200 2150 0    50   ~ 0
A1
Text Label 8200 2050 0    50   ~ 0
A0
Wire Wire Line
	8400 2050 8200 2050
Wire Wire Line
	8400 2150 8200 2150
$Comp
L mgh-symbols:Z80Bus J1
U 1 1 5F8CF698
P 1500 2400
F 0 "J1" H 1550 3825 50  0000 C CNN
F 1 "Z80Bus" H 1550 3734 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x25_P2.54mm_Horizontal" H 1000 1950 50  0001 C CNN
F 3 "" H 1200 1950 50  0001 C CNN
	1    1500 2400
	1    0    0    -1  
$EndComp
Text Label 2350 2400 2    50   ~ 0
~WR
Text Label 2350 2500 2    50   ~ 0
~RD
Text Label 800  2400 0    50   ~ 0
~MREQ
Text Label 800  2500 0    50   ~ 0
~IORQ
$Comp
L power:VCC #PWR010
U 1 1 5F8D4647
P 2350 2100
F 0 "#PWR010" H 2350 1950 50  0001 C CNN
F 1 "VCC" V 2368 2227 50  0000 L CNN
F 2 "" H 2350 2100 50  0001 C CNN
F 3 "" H 2350 2100 50  0001 C CNN
	1    2350 2100
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR02
U 1 1 5F8D4DDD
P 850 2100
F 0 "#PWR02" H 850 1950 50  0001 C CNN
F 1 "VCC" V 868 2227 50  0000 L CNN
F 2 "" H 850 2100 50  0001 C CNN
F 3 "" H 850 2100 50  0001 C CNN
	1    850  2100
	0    -1   -1   0   
$EndComp
Text Label 2350 2600 2    50   ~ 0
D0
Text Label 800  2600 0    50   ~ 0
D1
Text Label 2350 2700 2    50   ~ 0
D2
Text Label 800  2700 0    50   ~ 0
D3
Text Label 2350 2800 2    50   ~ 0
D4
Text Label 800  2800 0    50   ~ 0
D5
Text Label 2350 2900 2    50   ~ 0
D6
Text Label 800  2900 0    50   ~ 0
D7
Text Label 2350 1900 2    50   ~ 0
A0
Text Label 800  1900 0    50   ~ 0
A1
Text Label 2350 1800 2    50   ~ 0
A2
Text Label 800  1800 0    50   ~ 0
A3
Text Label 2350 1700 2    50   ~ 0
A4
Text Label 800  1700 0    50   ~ 0
A5
Text Label 2350 1600 2    50   ~ 0
A6
Text Label 800  1600 0    50   ~ 0
A7
Text Label 2350 1500 2    50   ~ 0
A8
Text Label 800  1500 0    50   ~ 0
A9
Text Label 2350 1400 2    50   ~ 0
A10
Text Label 800  1400 0    50   ~ 0
A11
Text Label 2350 1300 2    50   ~ 0
A12
Text Label 800  1300 0    50   ~ 0
A13
Text Label 2350 1200 2    50   ~ 0
A14
Text Label 800  1200 0    50   ~ 0
A15
$Comp
L power:GND #PWR07
U 1 1 5F8D6243
P 2200 2000
F 0 "#PWR07" H 2200 1750 50  0001 C CNN
F 1 "GND" V 2200 1800 50  0000 C CNN
F 2 "" H 2200 2000 50  0001 C CNN
F 3 "" H 2200 2000 50  0001 C CNN
	1    2200 2000
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR01
U 1 1 5F8D6A45
P 850 2000
F 0 "#PWR01" H 850 1750 50  0001 C CNN
F 1 "GND" V 850 1800 50  0000 C CNN
F 2 "" H 850 2000 50  0001 C CNN
F 3 "" H 850 2000 50  0001 C CNN
	1    850  2000
	0    1    1    0   
$EndComp
Text Label 800  2300 0    50   ~ 0
CLK
Text Label 800  2200 0    50   ~ 0
~M1
Text Label 2400 3300 2    50   ~ 0
~RFSH
Text Label 2400 3400 2    50   ~ 0
~HALT
Text Label 2400 3500 2    50   ~ 0
~BusACK
Text Label 750  3500 0    50   ~ 0
~BusRQ
Text Label 2650 3600 0    50   ~ 0
~BusRQ
Text Label 2650 3700 0    50   ~ 0
~BusACK
Text Label 2700 2600 0    50   ~ 0
~HALT
Text Label 750  3400 0    50   ~ 0
~Wait
Text Label 2700 2500 0    50   ~ 0
~Wait
Text Label 2700 2400 0    50   ~ 0
~RFSH
Text Label 750  3300 0    50   ~ 0
~NMI
Text Label 2700 1900 0    50   ~ 0
~NMI
Text Label 2350 2200 2    50   ~ 0
~RESET
Text Label 2350 2300 2    50   ~ 0
~INT
$Comp
L CPU:Z80CPU U2
U 1 1 5F83CE91
P 3650 2500
F 0 "U2" H 3950 4000 50  0000 C CNN
F 1 "Z80CPU" H 4050 3900 50  0000 C CNN
F 2 "Package_DIP:DIP-40_W15.24mm_Socket_LongPads" H 3650 2900 50  0001 C CNN
F 3 "www.zilog.com/manage_directlink.php?filepath=docs/z80/um0080" H 3650 2900 50  0001 C CNN
	1    3650 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	1050 1200 800  1200
Wire Wire Line
	800  1300 1050 1300
Wire Wire Line
	800  1400 1050 1400
Wire Wire Line
	800  1500 1050 1500
Wire Wire Line
	800  1600 1050 1600
Wire Wire Line
	800  1700 1050 1700
Wire Wire Line
	800  1800 1050 1800
Wire Wire Line
	800  1900 1050 1900
Wire Wire Line
	850  2000 1050 2000
Wire Wire Line
	850  2100 1050 2100
Wire Wire Line
	800  2200 1050 2200
Wire Wire Line
	800  2300 1050 2300
Wire Wire Line
	800  2400 1050 2400
Wire Wire Line
	800  2500 1050 2500
Wire Wire Line
	800  2600 1050 2600
Wire Wire Line
	800  2700 1050 2700
Wire Wire Line
	800  2800 1050 2800
Wire Wire Line
	800  2900 1050 2900
Wire Wire Line
	1050 3300 750  3300
Wire Wire Line
	1050 3400 750  3400
Wire Wire Line
	1050 3500 750  3500
Wire Wire Line
	2050 3500 2400 3500
Wire Wire Line
	2400 3400 2050 3400
Wire Wire Line
	2050 3300 2400 3300
Wire Wire Line
	2350 2900 2050 2900
Wire Wire Line
	2050 2800 2350 2800
Wire Wire Line
	2350 2700 2050 2700
Wire Wire Line
	2050 2600 2350 2600
Wire Wire Line
	2350 2500 2050 2500
Wire Wire Line
	2050 2400 2350 2400
Wire Wire Line
	2350 2300 2050 2300
Wire Wire Line
	2050 2200 2350 2200
Wire Wire Line
	2350 2100 2050 2100
Wire Wire Line
	2050 2000 2200 2000
Wire Wire Line
	2350 1900 2050 1900
Wire Wire Line
	2050 1800 2350 1800
Wire Wire Line
	2350 1700 2050 1700
Wire Wire Line
	2050 1600 2350 1600
Wire Wire Line
	2350 1500 2050 1500
Wire Wire Line
	2050 1400 2350 1400
Wire Wire Line
	2350 1300 2050 1300
Wire Wire Line
	2350 1200 2050 1200
Wire Wire Line
	2950 3700 2650 3700
Wire Wire Line
	2650 3600 2950 3600
Wire Wire Line
	2950 2600 2700 2600
Wire Wire Line
	2700 2500 2950 2500
Wire Wire Line
	2700 2400 2950 2400
Text Label 2700 2300 0    50   ~ 0
~M1
Wire Wire Line
	2950 2300 2700 2300
Text Label 2700 2000 0    50   ~ 0
~INT
Wire Wire Line
	2950 2000 2700 2000
Wire Wire Line
	2950 1900 2700 1900
Wire Wire Line
	4200 7250 4200 7400
Connection ~ 5050 7400
Connection ~ 5050 6400
Wire Wire Line
	5050 6400 5300 6400
$Comp
L Connector_Generic:Conn_02x17_Odd_Even J5
U 1 1 5FEA24BE
P 10600 2550
F 0 "J5" H 10650 3400 50  0000 C CNN
F 1 "Conn_02x15_Odd_Even" H 10650 3650 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x17_P2.54mm_Vertical" H 10600 2550 50  0001 C CNN
F 3 "~" H 10600 2550 50  0001 C CNN
	1    10600 2550
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR026
U 1 1 5FEA5109
P 10350 1750
F 0 "#PWR026" H 10350 1600 50  0001 C CNN
F 1 "VCC" V 10450 1750 50  0000 C CNN
F 2 "" H 10350 1750 50  0001 C CNN
F 3 "" H 10350 1750 50  0001 C CNN
	1    10350 1750
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR030
U 1 1 5FEA56BD
P 11050 1750
F 0 "#PWR030" H 11050 1500 50  0001 C CNN
F 1 "GND" V 11150 1850 50  0000 R CNN
F 2 "" H 11050 1750 50  0001 C CNN
F 3 "" H 11050 1750 50  0001 C CNN
	1    11050 1750
	0    -1   -1   0   
$EndComp
Text Label 10000 1250 2    50   ~ 0
PA0
Text Label 10000 1350 2    50   ~ 0
PA1
Text Label 10000 1450 2    50   ~ 0
PA2
Text Label 10000 1550 2    50   ~ 0
PA3
Text Label 10000 1650 2    50   ~ 0
PA4
Text Label 10000 1750 2    50   ~ 0
PA5
Text Label 10000 1850 2    50   ~ 0
PA6
Text Label 10000 1950 2    50   ~ 0
PA7
Text Label 10000 2150 2    50   ~ 0
PB0
Text Label 10000 2250 2    50   ~ 0
PB1
Text Label 10000 2350 2    50   ~ 0
PB2
Text Label 10000 2450 2    50   ~ 0
PB3
Text Label 10000 2550 2    50   ~ 0
PB4
Text Label 10000 2650 2    50   ~ 0
PB5
Text Label 10000 2750 2    50   ~ 0
PB6
Text Label 10000 2850 2    50   ~ 0
PB7
Text Label 10000 3050 2    50   ~ 0
PC0
Text Label 10000 3150 2    50   ~ 0
PC1
Text Label 10000 3250 2    50   ~ 0
PC2
Text Label 10000 3350 2    50   ~ 0
PC3
Text Label 10000 3450 2    50   ~ 0
PC4
Text Label 10000 3550 2    50   ~ 0
PC5
Text Label 10000 3650 2    50   ~ 0
PC6
Text Label 10000 3750 2    50   ~ 0
PC7
Wire Wire Line
	10000 1250 9800 1250
Wire Wire Line
	10000 1350 9800 1350
Wire Wire Line
	10000 1450 9800 1450
Wire Wire Line
	9800 1550 10000 1550
Wire Wire Line
	10000 1650 9800 1650
Wire Wire Line
	9800 1750 10000 1750
Wire Wire Line
	10000 1850 9800 1850
Wire Wire Line
	9800 1950 10000 1950
Wire Wire Line
	10000 2150 9800 2150
Wire Wire Line
	9800 2250 10000 2250
Wire Wire Line
	10000 2350 9800 2350
Wire Wire Line
	9800 2450 10000 2450
Wire Wire Line
	10000 2550 9800 2550
Wire Wire Line
	9800 2650 10000 2650
Wire Wire Line
	10000 2750 9800 2750
Wire Wire Line
	9800 2850 10000 2850
Wire Wire Line
	10000 3050 9800 3050
Wire Wire Line
	9800 3150 10000 3150
Wire Wire Line
	10000 3250 9800 3250
Wire Wire Line
	9800 3350 10000 3350
Wire Wire Line
	9800 3450 10000 3450
Wire Wire Line
	9800 3550 10000 3550
Wire Wire Line
	10000 3650 9800 3650
Wire Wire Line
	9800 3750 10000 3750
Text Label 10250 1850 0    50   ~ 0
PA0
Text Label 11100 1850 2    50   ~ 0
PA1
Text Label 10250 1950 0    50   ~ 0
PA2
Text Label 11100 1950 2    50   ~ 0
PA3
Text Label 10250 2050 0    50   ~ 0
PA4
Text Label 11100 2050 2    50   ~ 0
PA5
Text Label 10250 2150 0    50   ~ 0
PA6
Text Label 11100 2150 2    50   ~ 0
PA7
Text Label 10250 2450 0    50   ~ 0
PC0
Text Label 10250 2550 0    50   ~ 0
PC2
Text Label 11100 2550 2    50   ~ 0
PC3
Text Label 10250 2650 0    50   ~ 0
PC4
Text Label 11100 2650 2    50   ~ 0
PC5
Text Label 10250 2750 0    50   ~ 0
PC6
Text Label 11100 2750 2    50   ~ 0
PC7
Text Label 11100 2450 2    50   ~ 0
PC1
Text Label 10250 3050 0    50   ~ 0
PB0
Text Label 11100 3050 2    50   ~ 0
PB1
Text Label 10250 3150 0    50   ~ 0
PB2
Text Label 11100 3150 2    50   ~ 0
PB3
Text Label 10250 3250 0    50   ~ 0
PB4
Text Label 11100 3250 2    50   ~ 0
PB5
Text Label 10250 3350 0    50   ~ 0
PB6
Text Label 11100 3350 2    50   ~ 0
PB7
$Comp
L power:VCC #PWR027
U 1 1 601221FF
P 10350 2350
F 0 "#PWR027" H 10350 2200 50  0001 C CNN
F 1 "VCC" V 10450 2450 50  0000 C CNN
F 2 "" H 10350 2350 50  0001 C CNN
F 3 "" H 10350 2350 50  0001 C CNN
	1    10350 2350
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR031
U 1 1 60122D84
P 11050 2350
F 0 "#PWR031" H 11050 2100 50  0001 C CNN
F 1 "GND" V 11150 2400 50  0000 R CNN
F 2 "" H 11050 2350 50  0001 C CNN
F 3 "" H 11050 2350 50  0001 C CNN
	1    11050 2350
	0    -1   -1   0   
$EndComp
NoConn ~ 10400 2850
NoConn ~ 10900 2850
Wire Wire Line
	10250 1850 10400 1850
Wire Wire Line
	10250 1950 10400 1950
Wire Wire Line
	10250 2050 10400 2050
Wire Wire Line
	10900 1850 11100 1850
Wire Wire Line
	10900 1950 11100 1950
Wire Wire Line
	11100 2050 10900 2050
Wire Wire Line
	10400 2150 10250 2150
Wire Wire Line
	10400 2550 10250 2550
Wire Wire Line
	10900 2150 11100 2150
Wire Wire Line
	11100 2450 10900 2450
Wire Wire Line
	10900 2550 11100 2550
Wire Wire Line
	11100 2650 10900 2650
Wire Wire Line
	10250 2650 10400 2650
Wire Wire Line
	10400 2750 10250 2750
Wire Wire Line
	10900 2750 11100 2750
Wire Wire Line
	11050 2350 10900 2350
Wire Wire Line
	10400 2350 10350 2350
Wire Wire Line
	10250 3050 10400 3050
Wire Wire Line
	10400 3150 10250 3150
Wire Wire Line
	10250 3250 10400 3250
Wire Wire Line
	10900 3050 11100 3050
Wire Wire Line
	11100 3150 10900 3150
Wire Wire Line
	10900 3250 11100 3250
Wire Wire Line
	11100 3350 10900 3350
Wire Wire Line
	10400 3350 10250 3350
Wire Wire Line
	10400 1750 10350 1750
Wire Wire Line
	10900 1750 11050 1750
Wire Wire Line
	10250 2450 10400 2450
Wire Wire Line
	5550 6400 5550 6750
Wire Wire Line
	5050 6350 5050 6400
$Comp
L Device:C C4
U 1 1 604B19F1
P 4800 6900
F 0 "C4" H 4850 7000 50  0000 L CNN
F 1 "100nF" H 4800 6750 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 4838 6750 50  0001 C CNN
F 3 "~" H 4800 6900 50  0001 C CNN
	1    4800 6900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4800 6750 4800 6400
Wire Wire Line
	4800 7050 4800 7400
Wire Wire Line
	5300 6750 5300 6400
Wire Wire Line
	5300 7050 5300 7400
Connection ~ 5300 6400
Wire Wire Line
	5300 6400 5550 6400
Wire Wire Line
	4200 7400 4350 7400
Wire Wire Line
	4800 6400 5050 6400
Wire Wire Line
	4800 7400 5050 7400
Wire Wire Line
	5800 7400 5800 7050
Wire Wire Line
	5800 6400 5800 6750
Connection ~ 5550 6400
Wire Wire Line
	5550 6400 5800 6400
Connection ~ 5550 7400
Wire Wire Line
	5550 7400 5800 7400
$Comp
L Device:C C6
U 1 1 60596AF0
P 5050 6900
F 0 "C6" H 5100 7000 50  0000 L CNN
F 1 "100nF" H 5050 6750 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 5088 6750 50  0001 C CNN
F 3 "~" H 5050 6900 50  0001 C CNN
	1    5050 6900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C7
U 1 1 60597446
P 5300 6900
F 0 "C7" H 5350 7000 50  0000 L CNN
F 1 "100nF" H 5300 6750 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 5338 6750 50  0001 C CNN
F 3 "~" H 5300 6900 50  0001 C CNN
	1    5300 6900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C8
U 1 1 60597685
P 5550 6900
F 0 "C8" H 5600 7000 50  0000 L CNN
F 1 "100nF" H 5550 6750 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 5588 6750 50  0001 C CNN
F 3 "~" H 5550 6900 50  0001 C CNN
	1    5550 6900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C9
U 1 1 605977D6
P 5800 6900
F 0 "C9" H 5850 7000 50  0000 L CNN
F 1 "100nF" H 5800 6750 50  0001 L CNN
F 2 "Capacitor_THT:C_Disc_D4.7mm_W2.5mm_P5.00mm" H 5838 6750 50  0001 C CNN
F 3 "~" H 5800 6900 50  0001 C CNN
	1    5800 6900
	1    0    0    -1  
$EndComp
NoConn ~ 1050 3000
NoConn ~ 1050 3600
NoConn ~ 2050 3600
NoConn ~ 2050 3000
$Comp
L Connector:Screw_Terminal_01x02 J2
U 1 1 6067DC0B
P 3700 6950
F 0 "J2" H 3700 6700 50  0000 C CNN
F 1 "Screw_Terminal_01x02" H 3618 6716 50  0001 C CNN
F 2 "TerminalBlock:TerminalBlock_bornier-2_P5.08mm" H 3700 6950 50  0001 C CNN
F 3 "~" H 3700 6950 50  0001 C CNN
	1    3700 6950
	-1   0    0    1   
$EndComp
$Comp
L Device:D_Small_ALT D2
U 1 1 606A1EC1
P 6050 6900
F 0 "D2" V 6004 6968 50  0000 L CNN
F 1 "D" V 6095 6968 50  0000 L CNN
F 2 "Diode_THT:D_A-405_P7.62mm_Horizontal" H 6050 6900 50  0001 C CNN
F 3 "~" H 6050 6900 50  0001 C CNN
	1    6050 6900
	0    1    1    0   
$EndComp
Wire Wire Line
	5800 6400 6050 6400
Wire Wire Line
	6050 6400 6050 6800
Connection ~ 5800 6400
Wire Wire Line
	6050 7000 6050 7400
Wire Wire Line
	6050 7400 5800 7400
Connection ~ 5800 7400
Wire Wire Line
	3900 6850 3900 6400
Wire Wire Line
	3900 6400 4050 6400
Connection ~ 4200 6400
Wire Wire Line
	4200 7400 4050 7400
Wire Wire Line
	3900 7400 3900 6950
Connection ~ 4200 7400
$Comp
L Device:R_Network06 RN1
U 1 1 60A3AC8A
P 6200 5300
F 0 "RN1" V 5583 5300 50  0000 C CNN
F 1 "10k" V 5674 5300 50  0000 C CNN
F 2 "Resistor_THT:R_Array_SIP7" V 6775 5300 50  0001 C CNN
F 3 "http://www.vishay.com/docs/31509/csc.pdf" H 6200 5300 50  0001 C CNN
	1    6200 5300
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR020
U 1 1 60A3D11C
P 6400 4900
F 0 "#PWR020" H 6400 4750 50  0001 C CNN
F 1 "VCC" H 6417 5073 50  0000 C CNN
F 2 "" H 6400 4900 50  0001 C CNN
F 3 "" H 6400 4900 50  0001 C CNN
	1    6400 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6400 5000 6400 4900
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
L power:GND #PWR029
U 1 1 60A7DCB8
P 10650 6300
F 0 "#PWR029" H 10650 6050 50  0001 C CNN
F 1 "GND" H 10655 6127 50  0000 C CNN
F 2 "" H 10650 6300 50  0001 C CNN
F 3 "" H 10650 6300 50  0001 C CNN
	1    10650 6300
	1    0    0    -1  
$EndComp
Text Notes 10450 6000 0    50   ~ 0
Mounting Holes
$Comp
L Oscillator:CXO_DIP14 X1
U 1 1 60AE021D
P 1350 4750
F 0 "X1" H 1400 4500 50  0000 L CNN
F 1 "4MHz_DIP14" H 1400 4400 50  0000 L CNN
F 2 "Oscillator:Oscillator_DIP-14" H 1800 4400 50  0001 C CNN
F 3 "http://cdn-reichelt.de/documents/datenblatt/B400/OSZI.pdf" H 1250 4750 50  0001 C CNN
	1    1350 4750
	1    0    0    -1  
$EndComp
$Comp
L Oscillator:CXO_DIP8 X2
U 1 1 60AE1097
P 2500 4750
F 0 "X2" H 2550 4500 50  0000 L CNN
F 1 "4MHz_DIP8" H 2550 4400 50  0000 L CNN
F 2 "Oscillator:Oscillator_DIP-8" H 2950 4400 50  0001 C CNN
F 3 "http://cdn-reichelt.de/documents/datenblatt/B400/OSZI.pdf" H 2400 4750 50  0001 C CNN
	1    2500 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	1350 5050 1350 5150
Wire Wire Line
	1350 5150 1950 5150
Wire Wire Line
	2500 5150 2500 5050
Wire Wire Line
	1350 4450 1350 4350
Wire Wire Line
	1350 4350 1950 4350
Wire Wire Line
	2500 4350 2500 4450
NoConn ~ 1050 4750
NoConn ~ 2200 4750
Text Label 1850 4750 2    50   ~ 0
CLK
Text Label 3000 4750 2    50   ~ 0
CLK
Wire Wire Line
	1650 4750 1850 4750
Wire Wire Line
	2800 4750 3000 4750
$Comp
L power:VCC #PWR05
U 1 1 60BC4818
P 1950 4350
F 0 "#PWR05" H 1950 4200 50  0001 C CNN
F 1 "VCC" H 1967 4523 50  0000 C CNN
F 2 "" H 1950 4350 50  0001 C CNN
F 3 "" H 1950 4350 50  0001 C CNN
	1    1950 4350
	1    0    0    -1  
$EndComp
Connection ~ 1950 4350
Wire Wire Line
	1950 4350 2500 4350
$Comp
L power:GND #PWR06
U 1 1 60BC4DC7
P 1950 5150
F 0 "#PWR06" H 1950 4900 50  0001 C CNN
F 1 "GND" H 1955 4977 50  0000 C CNN
F 2 "" H 1950 5150 50  0001 C CNN
F 3 "" H 1950 5150 50  0001 C CNN
	1    1950 5150
	1    0    0    -1  
$EndComp
Connection ~ 1950 5150
Wire Wire Line
	1950 5150 2500 5150
$Comp
L power:VCC #PWR028
U 1 1 60D7F944
P 10350 2950
F 0 "#PWR028" H 10350 2800 50  0001 C CNN
F 1 "VCC" V 10450 3050 50  0000 C CNN
F 2 "" H 10350 2950 50  0001 C CNN
F 3 "" H 10350 2950 50  0001 C CNN
	1    10350 2950
	0    -1   -1   0   
$EndComp
Wire Wire Line
	10400 2950 10350 2950
$Comp
L power:GND #PWR032
U 1 1 60DA1DD2
P 11050 2950
F 0 "#PWR032" H 11050 2700 50  0001 C CNN
F 1 "GND" V 11150 3000 50  0000 R CNN
F 2 "" H 11050 2950 50  0001 C CNN
F 3 "" H 11050 2950 50  0001 C CNN
	1    11050 2950
	0    -1   -1   0   
$EndComp
Wire Wire Line
	11050 2950 10900 2950
NoConn ~ 10900 2250
NoConn ~ 10400 2250
$Comp
L Device:Jumper_NC_Small JP1
U 1 1 60E0850E
P 3200 5950
F 0 "JP1" H 3200 6162 50  0000 C CNN
F 1 "INT_CLK_EN" H 3200 5800 50  0000 C CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Open_TrianglePad1.0x1.5mm" H 3200 5950 50  0001 C CNN
F 3 "~" H 3200 5950 50  0001 C CNN
	1    3200 5950
	1    0    0    -1  
$EndComp
Wire Wire Line
	3300 5950 3500 5950
Text Label 8200 1550 0    50   ~ 0
~IO_CS
Text Label 8050 4550 2    50   ~ 0
~IO_CS
$Comp
L Device:Jumper_NC_Small JP2
U 1 1 60E91872
P 7650 4550
F 0 "JP2" H 7550 4700 50  0000 C CNN
F 1 "IO_EN" H 7650 4450 50  0000 C CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Open_TrianglePad1.0x1.5mm" H 7650 4550 50  0001 C CNN
F 3 "~" H 7650 4550 50  0001 C CNN
	1    7650 4550
	1    0    0    -1  
$EndComp
Wire Wire Line
	7300 4550 7550 4550
Wire Wire Line
	7750 4550 8050 4550
Wire Wire Line
	2250 5850 2450 5850
Text Label 5700 5000 0    50   ~ 0
~NMI
Text Label 5700 5100 0    50   ~ 0
~INT
Text Label 5700 5200 0    50   ~ 0
~BusRQ
Text Label 5700 5300 0    50   ~ 0
~Wait
Text Label 2400 3100 2    50   ~ 0
~IO_CS
Text Label 9800 5700 2    50   ~ 0
~RAM_CS
Text Label 7300 4950 0    50   ~ 0
A15
Text Label 8050 4950 2    50   ~ 0
~ROM_CS
$Comp
L Device:Jumper_NC_Small JP3
U 1 1 6133342E
P 7650 4950
F 0 "JP3" H 7550 5050 50  0000 C CNN
F 1 "ROM_EN" H 7650 4850 50  0000 C CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Open_TrianglePad1.0x1.5mm" H 7650 4950 50  0001 C CNN
F 3 "~" H 7650 4950 50  0001 C CNN
	1    7650 4950
	1    0    0    -1  
$EndComp
$Comp
L Device:Jumper_NC_Small JP4
U 1 1 613336C8
P 9350 5700
F 0 "JP4" H 9350 5800 50  0000 C CNN
F 1 "RAM_CS_EN" H 9350 5600 50  0000 C CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Open_TrianglePad1.0x1.5mm" H 9350 5700 50  0001 C CNN
F 3 "~" H 9350 5700 50  0001 C CNN
	1    9350 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	7550 4950 7300 4950
Wire Wire Line
	7750 4950 8050 4950
Wire Wire Line
	9450 5700 9800 5700
Wire Wire Line
	6000 5000 5700 5000
Wire Wire Line
	6000 5100 5700 5100
Wire Wire Line
	6000 5200 5700 5200
Wire Wire Line
	6000 5300 5700 5300
Wire Wire Line
	2050 3100 2400 3100
Text Label 750  3100 0    50   ~ 0
~RAM_CS
Wire Wire Line
	1050 3100 750  3100
Text Label 2400 3200 2    50   ~ 0
~ROM_CS
Wire Wire Line
	2050 3200 2400 3200
$Comp
L Connector_Generic:Conn_01x05 J3
U 1 1 6165CF40
P 5750 3650
F 0 "J3" H 5750 4000 50  0000 C CNN
F 1 "EEPROM / EPROM selector" H 5500 3250 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x05_P2.54mm_Vertical" H 5750 3650 50  0001 C CNN
F 3 "~" H 5750 3650 50  0001 C CNN
	1    5750 3650
	-1   0    0    -1  
$EndComp
Text Label 6500 2950 0    50   ~ 0
~ROM_CS
Wire Wire Line
	6850 2850 6350 2850
Wire Wire Line
	6350 2850 6350 3750
Wire Wire Line
	6350 3750 5950 3750
Wire Wire Line
	5950 3550 6250 3550
Wire Wire Line
	6250 3550 6250 2650
Wire Wire Line
	6250 2650 6850 2650
Wire Wire Line
	6150 3650 5950 3650
Text Label 6150 3450 2    50   ~ 0
~WR
Wire Wire Line
	5950 3450 6150 3450
$Comp
L power:VCC #PWR018
U 1 1 61851225
P 6000 3850
F 0 "#PWR018" H 6000 3700 50  0001 C CNN
F 1 "VCC" V 6000 4100 50  0000 C CNN
F 2 "" H 6000 3850 50  0001 C CNN
F 3 "" H 6000 3850 50  0001 C CNN
	1    6000 3850
	0    1    1    0   
$EndComp
Wire Wire Line
	5950 3850 6000 3850
NoConn ~ 1050 3200
NoConn ~ 6000 5400
NoConn ~ 6000 5500
$Comp
L Device:CP_Small C3
U 1 1 5F9BC7E8
P 4500 6900
F 0 "C3" H 4550 6800 50  0000 L CNN
F 1 "10uF" H 4550 6700 50  0000 L CNN
F 2 "Capacitor_THT:CP_Radial_D6.3mm_P2.50mm" H 4500 6900 50  0001 C CNN
F 3 "~" H 4500 6900 50  0001 C CNN
	1    4500 6900
	1    0    0    -1  
$EndComp
Connection ~ 4800 6400
Wire Wire Line
	4500 6400 4500 6800
Connection ~ 4500 6400
Wire Wire Line
	4500 6400 4800 6400
Wire Wire Line
	4500 7000 4500 7400
Connection ~ 4500 7400
Wire Wire Line
	4500 7400 4800 7400
Connection ~ 4800 7400
Text Notes 5250 6350 0    50   ~ 0
5x 100nF IC Decoupling Capacitors
Wire Wire Line
	3800 4950 3800 5050
Wire Wire Line
	3800 5450 3800 5550
$Comp
L Switch:SW_Push SW1
U 1 1 5F855E91
P 3800 5250
F 0 "SW1" V 3846 5202 50  0000 R CNN
F 1 "RESET" V 3755 5202 50  0000 R CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 3800 5450 50  0001 C CNN
F 3 "~" H 3800 5450 50  0001 C CNN
	1    3800 5250
	0    -1   -1   0   
$EndComp
Connection ~ 4150 5550
Wire Wire Line
	4150 5550 3800 5550
Wire Wire Line
	4400 4450 4400 4550
Wire Wire Line
	3800 4950 4400 4950
$Comp
L Connector:TestPoint TP1
U 1 1 5FBC285C
P 4050 6400
F 0 "TP1" H 4108 6472 50  0001 L CNN
F 1 "5V VCC" H 4108 6427 50  0001 L CNN
F 2 "TestPoint:TestPoint_THTPad_D1.5mm_Drill0.7mm" H 4250 6400 50  0001 C CNN
F 3 "~" H 4250 6400 50  0001 C CNN
	1    4050 6400
	1    0    0    -1  
$EndComp
Connection ~ 4050 6400
Wire Wire Line
	4050 6400 4200 6400
$Comp
L Connector:TestPoint TP3
U 1 1 5FBC3F67
P 4350 6400
F 0 "TP3" H 4408 6472 50  0001 L CNN
F 1 "5V VCC" H 4408 6427 50  0001 L CNN
F 2 "TestPoint:TestPoint_THTPad_D1.5mm_Drill0.7mm" H 4550 6400 50  0001 C CNN
F 3 "~" H 4550 6400 50  0001 C CNN
	1    4350 6400
	1    0    0    -1  
$EndComp
Connection ~ 4350 6400
Wire Wire Line
	4350 6400 4500 6400
Wire Wire Line
	4200 6400 4350 6400
$Comp
L Connector:TestPoint TP2
U 1 1 5FBC5640
P 4050 7400
F 0 "TP2" H 4108 7472 50  0001 L CNN
F 1 "GND" H 4108 7427 50  0001 L CNN
F 2 "TestPoint:TestPoint_THTPad_D1.5mm_Drill0.7mm" H 4250 7400 50  0001 C CNN
F 3 "~" H 4250 7400 50  0001 C CNN
	1    4050 7400
	-1   0    0    1   
$EndComp
Connection ~ 4050 7400
Wire Wire Line
	4050 7400 3900 7400
$Comp
L Connector:TestPoint TP4
U 1 1 5FBC5DA8
P 4350 7400
F 0 "TP4" H 4408 7472 50  0001 L CNN
F 1 "GND" H 4408 7427 50  0001 L CNN
F 2 "TestPoint:TestPoint_THTPad_D1.5mm_Drill0.7mm" H 4550 7400 50  0001 C CNN
F 3 "~" H 4550 7400 50  0001 C CNN
	1    4350 7400
	-1   0    0    1   
$EndComp
Connection ~ 4350 7400
Wire Wire Line
	4350 7400 4500 7400
Text Notes 4000 7650 0    50   ~ 0
Test Points
Text Notes 4000 6200 0    50   ~ 0
Test Points
$Comp
L Device:Jumper_NC_Small JP5
U 1 1 5F8BD656
P 950 6050
F 0 "JP5" V 1050 6200 50  0000 C CNN
F 1 "Input_to_VCC" V 750 6200 50  0001 C CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Open_TrianglePad1.0x1.5mm" H 950 6050 50  0001 C CNN
F 3 "~" H 950 6050 50  0001 C CNN
	1    950  6050
	0    -1   -1   0   
$EndComp
Connection ~ 950  6150
Connection ~ 950  5950
$Comp
L Device:Jumper_NC_Small JP6
U 1 1 5F8BF684
P 2250 5950
F 0 "JP6" V 2300 6100 50  0000 C CNN
F 1 "Inpu_to_VCC" V 2000 5800 50  0001 C CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Open_TrianglePad1.0x1.5mm" H 2250 5950 50  0001 C CNN
F 3 "~" H 2250 5950 50  0001 C CNN
	1    2250 5950
	0    -1   -1   0   
$EndComp
Connection ~ 2250 5850
Connection ~ 6050 6400
Connection ~ 6050 7400
Wire Wire Line
	6050 6400 6550 6400
Wire Wire Line
	6050 7400 6550 7400
$Comp
L 74xx:74HC00 U1
U 5 1 5F8D13D9
P 6550 6900
F 0 "U1" H 6600 7350 50  0000 L CNN
F 1 "74HC00" H 6600 7250 50  0000 L CNN
F 2 "" H 6550 6900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74hc00" H 6550 6900 50  0001 C CNN
	5    6550 6900
	1    0    0    -1  
$EndComp
Text Notes 5550 5750 0    50   ~ 0
incuded 2x "spare" pull-ups, \nfor experimets :)
$Comp
L Connector:TestPoint TP5
U 1 1 5FB551EF
P 4650 4950
F 0 "TP5" H 4708 5022 50  0001 L CNN
F 1 "5V VCC" H 4708 4977 50  0001 L CNN
F 2 "TestPoint:TestPoint_THTPad_D1.5mm_Drill0.7mm" H 4850 4950 50  0001 C CNN
F 3 "~" H 4850 4950 50  0001 C CNN
	1    4650 4950
	1    0    0    -1  
$EndComp
Connection ~ 4650 4950
Wire Wire Line
	4650 4950 4400 4950
$Comp
L Connector:TestPoint TP6
U 1 1 5FB554F3
P 4750 4950
F 0 "TP6" H 4808 5022 50  0001 L CNN
F 1 "5V VCC" H 4808 4977 50  0001 L CNN
F 2 "TestPoint:TestPoint_THTPad_D1.5mm_Drill0.7mm" H 4950 4950 50  0001 C CNN
F 3 "~" H 4950 4950 50  0001 C CNN
	1    4750 4950
	1    0    0    -1  
$EndComp
Connection ~ 4750 4950
Wire Wire Line
	4750 4950 4650 4950
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5FBB975B
P 4800 7450
F 0 "#FLG01" H 4800 7525 50  0001 C CNN
F 1 "PWR_FLAG" H 4800 7623 50  0000 C CNN
F 2 "" H 4800 7450 50  0001 C CNN
F 3 "~" H 4800 7450 50  0001 C CNN
	1    4800 7450
	-1   0    0    1   
$EndComp
Wire Wire Line
	4800 7450 4800 7400
$EndSCHEMATC
