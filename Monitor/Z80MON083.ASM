;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $Id: Z80MON083.ASM $   10/11/2025     V8.3 
; Z80 Monitor 9600 baud version With Assembler & Disassembler
; V8.0 - Added support for hardwired LED (PORTC-0) & Speaker(PORTC-1)
; V8.1 - Changed FLASHLED
; V8.2 - Improved SENDBYTE & GETBYTE 
; V8.3 - corrected SENDBYTE 
; V8.3mgh - adjusted for MGH80 hardware
; Command Line to Compile: 
; zmac.exe -c -n --oo hex,cim,lst Z80MON08.ASM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;********************* HARDWARE IO ADR ************************************
; PIO 82C55 I/O
PIO1A:       .EQU    0              ; (INPUT)  IN 1-8
PIO1B:       .EQU    1              ; (INPUT) 
PIO1C:       .EQU    2              ; (OUTPUT)  
PIO1CONT:    .EQU    3              ; CONTROL BYTE PIO 82C55

BDOS:	       .EQU	   0005H	        ;BDOS ENTRY POINT for EMULATOR ONLY
;********************* CONSTANTS ****************************************
RAMTOP:      .EQU    $FFFF          ; 32Kb RAM   8000H-FFFFH
TEMPSTACK    .EQU    $90A8          ; Top of BASIC line input buffer so is "free ram" when BASIC resets
END:         .EQU    $FF            ; Mark END OF TEXT

CT_BLINK:    .EQU    $8080          ; Blink Delay
TX_BYTE:     .EQU    $8081          ; Byte to send
RX_BYTE:     .EQU    $8082          ; Byte recieved
FLAGS_A:     .EQU    $8083          ; Flags A: Bit 0=ECHO                            
COUNT_A:     .EQU    $8085          ; Counter A
COUNT_B:     .EQU    $8086          ; Counter B
COUNT_C:     .EQU    $8087          ; Counter C
ADDR_LO:     .EQU    $8088
ADDR_HI:     .EQU    $8089
TEMP_01:     .EQU    $8091          ; Temp Storage 1
TEMP_02:     .EQU    $8092          ; Temp Storage 2
TEMP_03:     .EQU    $8093          ; Temp Storage 3
TEMP_04:     .EQU    $8094          ; Temp Storage 4
REC_LEN:     .EQU    $8095          ; iHex Record Length 
REC_TYPE:    .EQU    $8096          ; iHex Record Type
REC_CSUM:    .EQU    $8097          ; iHex Record Checksum
ASM_ADDR:    .EQU    $8098          ; Assembler Destination address

ASM_BUF:     .EQU    $80A0          ; 16 byte ASM Input Buffer
OUT_BUF:     .EQU    $80AB          ; 4 byte test buffer(last part of ASM_BUF)  
INS_BUF:     .EQU    $80B0          ; 4 Byte Instruction Buffer
PARM_BUF:    .EQU    $80B4          ; 7 Byte Parm Buffer
VAL_BUF:     .EQU    $80BB          ; 5 Byte Value Buffer
VAL_BUF_HI:  .EQU    $80BB          ; 2 Hi Bytes in Value Buffer
VAL_BUF_LO:  .EQU    $80BD          ; 2 Lo Bytes in Value Buffer
SRC_ADDR:    .EQU    $80C0          ; 2 byte source pointer storage
DES_ADDR:    .EQU    $80C2          ; 2 byte destination pointer storage
BLK_ADDR:    .EQU    $80C4          ; 2 byte table block pointer storage
ROW_ADDR:    .EQU    $80C6          ; 2 byte table row pointer storage
BLK_NUM:     .EQU    $80C8          ; 1 byte Block Number
BLK_SIZE:    .EQU    $80C9          ; 1 byte Block Size
ROW_NUM      .EQU    $80CA          ; 1 byte Row Number  
ML_BUF:      .EQU    $80CB          ; 3 byte ML buffer
ML_BTCOUNT:  .EQU    $80CD          ; Last byte of ML buffer(byte count)
VAL_LO:      .EQU    $80CE          ; Converted value LO
VAL_HI:      .EQU    $80CF          ; Converted value Hi

;*******************************************************************
;*        START AFTER RESET,                                       *
;*        Function....: ready system and restart                   *
;*******************************************************************
             .ORG    $0000
             NOP                   ;A Few NOPs to let things settle down
             NOP
             NOP
             DI                    ; Disable interrupt
             LD     SP,RAMTOP      ; Set stack pointer to top off ram
             JP     MAIN_START     ; jump to Start of program
             
             .BYTE  $FF,$FF,$FF    ; 3 unprogramed bytes

             .byte " MGH80 "  ; text string in rom
             .byte " V 8.3mgh "
             .byte " 01/2026 "

            .ORG    $0030
;*******************************************************************
; External call entry points
; the offsets on these functions should never change
; ther rely on specific ram values for input & output 
;*******************************************************************
XSEND_CHR:  LD    A,(TX_BYTE)
            CALL  SENDBYTE
            RET
            
XGET_CHR:   CALL  GETBYTE
            RET          

XSEND_STR:  LD   HL,(ADDR_LO)
            CALL SENDSTR 
            RET
            
XSEND_HEX:  LD    A,(TX_BYTE)
            CALL  SENDHEX
            RET          
XGET_HEX:   CALL  GETHEXBYTE
            LD    (RX_BYTE),A         
            RET
              
XOUT_P:     LD     B,00h
            LD     A,(TEMP_03)    ; Get Saved Port#
            LD     C,A            ; Move to C
            LD     A,(TEMP_02)    ; Get Value
            OUT    (C),A          ; Output it
            RET
            
XIN_P:      LD     A,(TEMP_03)    ; Get Saved Port#
            LD     C,A
            LD     B,0             
            IN     A,(C)         ; Read Port
            LD     (TEMP_02),A   ; Save it
            RET
  
XDELAY4:    JP     DELAY4
XBEEP       JP     BEEP
XPAUSE      JP     PAUSE            
;*******************************************************************
;*        MAIN PROGRAM                                             *
;*******************************************************************
MAIN_START:  CALL   INIT_PIO    ; programm the PIO
             
             LD     A, 5          ; 5= 1Khz
             LD     B, 1          ; 1= 100ms
             CALL   BEEP             
             
             LD     A,10        
             LD     BC,1000
             CALL   FLASHLED    ; blink LED 10x 20ms / blink
             
             LD     A, 0B2h
             LD     (CT_BLINK),A   ;set default blink delay B2=1/2sec
             
             LD     A,01h
             LD     (FLAGS_A),A  ;Set ECHO ON
             
             LD     HL,TXT_BOOTMS ; get boot message address 
             CALL   SENDSTR       ; send it
           
GET_COMMAND: LD     HL,TXT_PROMPT ; send CR & LF & '>'
             CALL   SENDSTR     

BLINK_START: LD     A, (CT_BLINK)  ;0xB2 = 501.25ms
             LD     B,A
BLINK_LOOP:  IN     A,(PIO1C)      ;READ PORTC       
             BIT    4,A            ;Test BIT 4
             JP     Z,READ_LOOP   ;If LOW get byte
             DEC    C
             JP     NZ,BLINK_LOOP
             DEC    B
             JP     NZ,BLINK_LOOP
             BIT    0,A            ;Test BIT 0
             JP     NZ, LED_OFF    ;If HIGH GOTO LED_OFF
LED_ON:      ORA    1
             OUT    (PIO1C),A 
             JP     BLINK_START    
LED_OFF:     AND    0FEh
             OUT    (PIO1C),A
             JP     BLINK_START    
            
READ_LOOP:   LD     A,'?'
             CALL   GETBYTE     ; get 1 Char
             CALL   SENDBYTE    ; send it
             
             LD     A,(RX_BYTE) ; Get byte recieved
             
CMD_ATTN:    CP     '@'         ; attention command? 
             JP     NZ,CMD_CLS
             LD     HL,TXT_ATNRSP ; send "$$$" 
             CALL   SENDSTR
             JP     GET_COMMAND
             
CMD_CLS:     CP     'C'         ; Clear Screen 
             JP     NZ,CMD_FLASH
             LD     HL,TXT_MSGCLS ; send clear screen & home string  
             CALL   SENDSTR
             LD     A,'>'
             CALL   SENDBYTE
             JP     READ_LOOP
             
CMD_FLASH:   CP     'f'         ; Flash LEDs 
             JP     NZ,CMD_BEEP
             LD     A,10 
             LD     BC, 800
             CALL   FLASHLED
             JP     GET_COMMAND
              
CMD_BEEP:    CP     't'         ; BEEP 625Hz for 1 sec 
             JP     NZ,CMD_DUMP16
             LD     A, 8    ;8 = 625hz  
             LD     B, 7    ;7 = 1.12sec @ 625hz 
             CALL   BEEP             
             JP     GET_COMMAND
             
CMD_DUMP16   CP     'd'         ; dump 16 bytes? 
             JP     NZ,CMD_DUMP256
             CALL   GETADDRESS  ; Print "Enter Address:" and get 4 hex bytes
             LD     HL,TXT_MSG_NL ; send CR & LF 
             CALL   SENDSTR
             LD     HL,(ADDR_LO)
             CALL   DUMP16
             JP     GET_COMMAND

CMD_DUMP256: CP     'D'         ;DUMP 256 Bytes?
             JP     NZ,CMD_SET
             CALL   GETADDRESS  ; Print "Enter Address:" and get 4 hex bytes
             LD     HL,TXT_MSG_NL ; send CR & LF 
             CALL   SENDSTR
             
             LD     A,010h        
             LD     (COUNT_A),A    ;Set COUNT_A
             
NEXT_DUMP16: LD     HL,(ADDR_LO)   ;Reload HL with start address 
             CALL   DUMP16         ;DUMP16 will return with HL+16
             LD     (ADDR_LO),HL   ;Update ADDR_LO & ADDR_HI with new HL value
             
             LD     HL,TXT_MSG_NL ; send CR & LF 
             CALL   SENDSTR
             
             LD     A,(COUNT_A)    ;Get Count_A
             DEC    A              ;Decrement A 
             LD     (COUNT_A),A    ;Save updated Value 
             JP     NZ,NEXT_DUMP16 ; Not Done? - Loop 
             JP     GET_COMMAND
 
CMD_SET:     CP     'S'          ; Set Memory?
             JP     NZ,CMD_TXT
             CALL   GETADDRESS  ; Print "Enter Address:" and get 4 hex bytes
             LD     HL,TXT_PRMPT2 ; send CR & LF & ':'
             CALL   SENDSTR
             LD     HL,(ADDR_LO)                           
NEXT_SET:    CALL   GETHEXBYTE
             LD     (TEMP_01),A 
             LD     A,B         ;NON-HEX input returns with 0xFF in B
             CP     0FFh
             JP     Z, GET_COMMAND ; Done with input
             LD     A,(TEMP_01)
             LD     (HL),A
             INC    HL
             LD     A,' '
             CALL   SENDBYTE
             JP     NEXT_SET
             
CMD_TXT:     CP     'T'          ; Text to Memory?
             JP     NZ,CMD_OUTIO
             CALL   GETADDRESS  ; Print "Enter Address:" and get 4 hex bytes
             LD     HL,TXT_PRMPT2 ; send CR & LF & ':'
             CALL   SENDSTR
             LD     HL,(ADDR_LO)                           
NEXT_TXT:    CALL   GETBYTE
             CP     0Dh            ; Enter = Done 
             JP     Z, GET_COMMAND ; Done with input
             CALL   SENDBYTE
             LD     (HL),A
             INC    HL
             LD     A,' '
             CALL   SENDBYTE
             JP     NEXT_TXT             
             
CMD_OUTIO:   CP     'O'         ;Output to I/O
             JP     NZ,CMD_INIO         
             LD     HL,TXT_MSGPRT
             CALL   SENDSTR       
             CALL   GETHEXBYTE    ;Get Port#
             LD     (TEMP_03),A   ;Save it
             
             LD     HL,TXT_MSGVAL
             CALL   SENDSTR       
             CALL   GETHEXBYTE    ;Get Value
             LD     (TEMP_02),A   ; Save it
             
             LD     B,00h
             LD     A,(TEMP_03)    ; Get Saved Port#
             LD     C,A            ; Move to C
             LD     A,(TEMP_02)    ; Get Value
             OUT    (C),A          ; Output it
             
             JP     GET_COMMAND

CMD_INIO:    CP     'I'         ;Input from I/O  
             JP     NZ,CMD_HELP         
             LD     HL,TXT_MSGPRT
             CALL   SENDSTR       
             CALL   GETHEXBYTE    ;Get Port#
             LD     C,A
             LD     B,0             
             IN     A,(C)         ; Read Port
             LD     (TEMP_02),A   ; Save it
             
             LD     HL,TXT_MSGVAL
             CALL   SENDSTR       
             LD     A,(TEMP_02)    ; Get Value
             CALL   SENDHEX
             JP     GET_COMMAND

CMD_HELP:    CP     'm'         ;Print Menu? 
             JP     Z,SHOW_MENU
CMD_MENU:    CP     'M'         ;Print Menu? 
             JP     NZ,CMD_GO         
SHOW_MENU    LD     HL,TXT_MSGHLP
             CALL   SENDSTR       ; send Help Menu...
             JP     GET_COMMAND
             
CMD_GO:      CP     'G'            ; GO command?
             JP     NZ,CMD_GO8100
             CALL   GETADDRESS  ; Print "Enter Address:" and get 4 hex bytes
             LD     HL,TXT_MSG_NL ; send CR & LF 
             CALL   SENDSTR
             LD     HL,(ADDR_LO)
             CALL   EXECUTE
             NOP
             LD     HL,TXT_MSG_NL ; send CR & LF 
             CALL   SENDSTR
             JP     GET_COMMAND
             
CMD_GO8100:  CP     'g'            ; GO 8100 command?
             JP     NZ,CMD_LIST
             LD     HL,TXT_MSG_NL ; send CR & LF 
             CALL   SENDSTR
             LD     HL,8100h
             CALL   EXECUTE
             NOP
             LD     HL,TXT_MSG_NL ; send CR & LF 
             CALL   SENDSTR
             JP     GET_COMMAND
             
CMD_LIST:    CP     'L'            ; LIST command?
             JP     NZ,CMD_ASSEMBLE
             CALL   DASM_MAIN
             JP     GET_COMMAND

CMD_ASSEMBLE:CP     'A'            ; ASSEMBLE command?
             JP     NZ,CMD_BASIC
             CALL   ASM_MAIN
             JP     GET_COMMAND
             
CMD_BASIC:   CP     'B'            ; Start BASIC (Cold Start)
             JP     NZ,CMD_BASICW
BASIC_COLD:  LD     (TEMP_03),SP
             LD     HL,TEMPSTACK    ; Temp stack
             LD     SP,HL           ; Set up a temporary stack
             CALL   COLD
BASICRET:    LD     SP,(TEMP_03)
             JP     GET_COMMAND             

CMD_BASICW:  CP     'b'            ; Start BASIC (Warm Start)
             JP     NZ,CMD_IHEXREC
             LD     A,(WRKSPC)
             CP     0C3H
             JP     NZ,BASIC_COLD
             LD     A,(USR)
             CP     0C3H
             JP     NZ,BASIC_COLD
             CALL   WARM
             JP     BASICRET                          

CMD_IHEXREC: CP     ':'           ; Get & Load iHEX record                  
             JP     NZ,CMD_SNDIHEX
             CALL   GETIHEXREC     ;Get 1 iHex Record and reply
             JP     GET_COMMAND

CMD_SNDIHEX: CP     03Bh          ;';' Get Length & Address then send iHEX record                  
             JP     NZ,CMD_RESET
             CALL   SNDIHEXREC    ;Send 1 iHex data Record with checksum
             JP     GET_COMMAND
             
CMD_RESET:   CP     '!'           ;Restart the system                   
             JP     NZ,CMD_NL
             JP     MAIN_START

CMD_NL: 	 CP     00DH           ; CR, no command                   
             JP     NZ,CMD_ERR
			 JP     GET_COMMAND			 
             
CMD_ERR:     LD     HL,TXT_UNKCMD
             CALL   SENDSTR       ; send "Unknown Command"
             JP     GET_COMMAND   ;again

EXECUTE:     JP     (HL)
             JP     GET_COMMAND
             
ERR_MSG:     LD     HL,TXT_ERRMSG  ; Print "ERROR"
             CALL   SENDSTR       
             JP     GET_COMMAND
                          
;******************************************************************
; Messages
;******************************************************************
TXT_BOOTMS: .BYTE 00,10," *** MGH80 - Started *** "
TXT_MSG_NL: .BYTE 13,10,END
TXT_ERRMSG: .BYTE 13,10,"ERROR",13,10,END
TXT_OKMSG:  .BYTE 13,10,"OK",13,10,END
TXT_MSG001: .BYTE 13,10,"Enter Address:",END
TXT_MSG003: .BYTE 13,10,"Start Address:",END
TXT_MSG004: .BYTE "  End Address:",END
TXT_UNKCMD: .BYTE 13,10,"Error, hit m for menu",END
TXT_PROMPT: .BYTE 13,10,'>',END
TXT_PRMPT2: .BYTE 13,10,':',END
TXT_ASMERR2:.BYTE "?"
TXT_ASMERR1:.BYTE "?",END
TXT_MSGSPC4:.BYTE "    ",END
TXT_ATNRSP: .BYTE "$$$",END
TXT_MSGPRT: .BYTE " Enter Port:",END
TXT_MSGVAL: .BYTE " Value:",END
TXT_MSGCLS: .BYTE 27,"[2J",27,"[0;0f",END
TXT_MSGHLP: .BYTE 13,10," ****** MGH80 Monitor   *** "
            .BYTE " *** [V8.3mgh 01/2026]  ******"
            .BYTE 13,10," d  Dump Memory(16 bytes)"
            .BYTE "  D  Dump Memory(256 bytes)"
            .BYTE 13,10," S  Set Memory           "
            .BYTE "  T  ASCI bytes to Memory"
            .BYTE 13,10," L  LIST                 "
            .BYTE "  A  ASSEMBLE"
            .BYTE 13,10," G  Run from address     "
            .BYTE "  g  Run from 8100H"
            .BYTE 13,10," B  Start BASIC          "
            .BYTE "  C  Clear Screen"                        
            .BYTE 13,10," O  Write I/O Port       "
            .BYTE "  I  Read I/O Port"
            .BYTE 13,10," f  Flash LEDs 10x       "
            .BYTE "  t  Beep Test"       
            .BYTE 13,10," @  Sync                 "     
            .BYTE "  M/m  Main Menu               "
            .BYTE 13,10," :  Get iHEX Rec.(no echo)"
            .BYTE 13,10," ;  Send iHEX Rec.(no echo)"   
            .BYTE 13,10,END


;******************************************************************
;        INIT_PIO  8255                                               
;  BIT 0 = PORTC(Lower) 1=INPUT 0=OUTPUT      
;  BIT 1 = PORTB  1=INPUT 0=OUTPUT
;  BIT 2 = MODE  0 or 1
;  BIT 3 = PORTC(Upper) 1=INPUT 0=OUTPUT
;  BIT 4 = PORTA  1=INPUT 0=OUTPUT
;  BIT 5&6 = 00=0, 01=1, 1?=2
;  BIT 7 = MODE SET FLAG  1=Active
;******************************************************************
;INIT_PIO:    LD     A,10000010B    ; A= OUT, B= IN C= OUT  (DATA FRA LCD)

INIT_PIO:    LD     A,10001010B    ; A=OUT, B=IN C=(lower)OUT (Upper)IN
             OUT    (PIO1CONT),A
             RET
             
;******************************************************************
;        SUB-RUTINE..: PAUSE                                      ;
;        Function....: Pause in 100uS. times value in BC          ;
;        Input.......: BC reg                                     ;
;        Output......: no                                         ;
;        call........: NONE                                       ;
;        Info........: KEA.      dato: 23/5-93                    ;
;******************************************************************
PAUSE:       PUSH   AF
             INC    B
             INC    C              ; ADJUST THE LOOP
PAUSELOOP1:  LD     A,13H          ; ADJUST THE TIME 13h IS FOR 4 MHZ
PAUSELOOP2:  DEC    A              ; DEC COUNTER. 4 T-states = 1 uS.
             JP     NZ,PAUSELOOP2  ; JUMP TO PAUSELOOP2 IF A <> 0.
             DEC    C              ; DEC COUNTER
             JP     NZ,PAUSELOOP1  ; JUMP TO PAUSELOOP1 IF C <> 0.

             DJNZ   PAUSELOOP1     ; JUMP TO PAUSELOOP1 IF B <> 0.
PAUSESLUT:   POP    AF
             RET
             
;******************************************************************
;        SUB-RUTINE..: DELAY4                                     ;
;        Function....: DELAY in 4uS. times value in BC            ;
;        Input.......: BC reg                                     ;
;******************************************************************
DELAY4:      INC    B
             INC    C              ; Adjust Loop 
DELAY4LOOP:  DEC    C              ; DEC COUNTER. 4 T-states = 1 uS.
             JP     NZ,DELAY4LOOP  ; JUMP TO DELAY4LOOP IF C <> 0. 
                                   ;  10 T States 2.5us 
             DJNZ   DELAY4LOOP     ; JUMP TO DELAY4LOOP IF B <> 0.
             RET


;******************************************************************
; FLASHLED    Flash LED on PORTC BIT0  A times  BC * 100us = delay
;******************************************************************
FLASHLED:    INC    A              ; Add 1 to A (adjust loop count)
             LD     (COUNT_A),A    ;Save A -> COUNT_A
             LD     HL,COUNT_A     ;Point HL to Loop Count
             LD     (COUNT_B),BC   ;Save BC in COUNT_B & COUNT_C
             
FLASH_LOOP:  IN     A,(PIO1A)      ;READ PORTA  
             ORA    1
             OUT    (PIO1A),A     ; Output to PORTA (LED ON)
             LD     BC,(COUNT_B)   
             CALL   PAUSE         ; Delay BC * 100us
             
             AND    0FEh        ; A should still have PORTA value
             OUT    (PIO1A),A   ; Output to PORTA (LED OFF)
             LD     BC,(COUNT_B)
             CALL   PAUSE        ; Delay BC * 100us
             
             DEC    (HL)          ; DEC COUNT_A
             JP     NZ,FLASH_LOOP   ;Loop if not done
             RET      

;******************************************************************
; BEEP  Beep speaker  A=Frequency(delay*100us)  B=Duration (cycles/100)  
;******************************************************************
BEEP:        LD     (COUNT_C),A     ;Save A (frequency)
             LD     A,B
             LD     (COUNT_B),A     ;Save C (duration)
BEEP_LOOP1:  LD     D, 100         ; D = cycle count multiplier (100)
BEEP_LOOP2:  IN     A,(PIO1C)      ;READ PORTC  
             ORA    2
             OUT    (PIO1C),A   ; Output to PORTC (SPEAKER HIGH)
             LD     B, 0
             LD     A, (COUNT_C)  ; 
             LD     C, A          ; 
             CALL   PAUSE         ; Delay BC * 100us
             
             IN     A,(PIO1C)   ;READ PORTC
             AND    0FDh
             OUT    (PIO1C),A   ; Output to PORTC (SPEAKER LOW)
             LD     A, (COUNT_C)
             LD     C, A
             CALL   PAUSE       ; Delay BC * 100us
             DEC    D
             LD     A,D
             JP     NZ,BEEP_LOOP2   ;Loop if not done             
             LD     A,(COUNT_B)    ;Get Loop Count
             DEC    A
             LD     (COUNT_B),A     ;Save New value
             JP     NZ,BEEP_LOOP1   ;Loop if not done
             RET      
             
;******************************************************************
;        SENDBYTE                             working! 10/11/25
;        Send 1 serial byte  
;        Input.......: A                                 
;        1200 baud delay=833.3us  2400 baud=416.6us 9600= 104.16us
;******************************************************************
SENDBYTE:    PUSH   AF     
             PUSH   BC 
             LD     (TX_BYTE),A   ;Save Byte to output
             LD     C,08          ;Set Bit Count
             IN     A,(PIO1C)       
             RES    3,A
             OUT    (PIO1C),A     ;Output LOW (Start Bit)
SEND_BIT:    LD     B,25          ;9600 baud = 25
DEL_BIT1:    DJNZ   DEL_BIT1      ;Delay 1 bit (decrement B till zero)
             LD     A,(TX_BYTE)   ;Get Byte to send
             RRA                  ;Shift Right through Carry 
             LD     (TX_BYTE),A   ;Save shifted result
             JP     C,OUT_HI      ;If Carry Set goto OUT_HI
             IN     A,(PIO1C)       
             RES    3,A
             OUT    (PIO1C),A      ;Output LOW
             JP     NEXT_BIT             
OUT_HI:      IN     A,(PIO1C)       
             SET    3,A
             OUT    (PIO1C),A      ;Output HI
NEXT_BIT:    DEC    C
             JP     NZ,SEND_BIT
             LD     B,25          ;9600 baud = 25                  
DEL_BIT2:    DJNZ   DEL_BIT2      ;Delay 1 bit(last data bit)
             IN     A,(PIO1C)       
             SET    3,A
             OUT    (PIO1C),A      ;Output HI
             LD     B,50          ;9600 baud (2 bits) = 50                  
DEL_BIT3:    DJNZ   DEL_BIT3      ;Delay 2 bits (parity & stop)
             POP    BC
             POP    AF
             RET

;******************************************************************
;        GETBYTE                                    WORKS 12/06/24;
;        Wait for 1 serial byte  
;        Output.......: RX_BYTE                                   
;        1200 baud delay=833.3us   2400 baud=416.6us  9600= 104.16us
;******************************************************************
GETBYTE:     PUSH   BC 
             LD     C,09           ;Set Bit Count
STARTWAIT:   IN     A,(PIO1C)      ;READ PORTC       
             BIT    4,A            ;Test BIT 0
             JP     NZ,STARTWAIT   ;If HI keep checking
             
             LD     B,18           ;9600 baud = 18 (1/2 Bit)           
NEXT_IN_BIT: DJNZ   NEXT_IN_BIT    ;Delay 1/2 or 1 bit
             
             IN     A,(PIO1C)      ; READ PORTC       
             RLA                   ;Rotate BIT4 into CARRY
             RLA
             RLA
             RLA
             LD     A,(RX_BYTE)    ;Get RX_BYTE
             RRA                   ;Rotate CARRY to BIT7
             LD     (RX_BYTE),A    ;Save result
             LD     B,26           ;9600 Full bit=32 (-20us for code)=26          
             DEC    C              ;Decrement Bit Count
             JP     NZ,NEXT_IN_BIT ; If not done NEXT_IN_BIT
                                   ;code between "READ PORTC" and this point
                                   ;takes about 20us to execute 
             LD     A,(RX_BYTE)    ;Get RX_BYTE
             POP    BC 
             RET
             
;******************************************************************
; TESTKEY
; Is a character in the process of being recieved?
; This routine will destroy the input character
; it's good only for a "Press A Key" function where the value of 
; the key is not important.
; RETURNS Z=0 if a key is pressed  
;******************************************************************
TESTKEY:     PUSH   BC
             PUSH   DE
             PUSH   HL
             IN     A,(PIO1C)  ;Read PORTC
             BIT    4,A        ;Test BIT4 
             POP    HL
             POP    DE
             POP    BC
             RET
            
;******************************************************************
; SENDSTR
; Output characters at (HL) until 0xFF (END) is encountered
;******************************************************************
SENDSTR:     PUSH   AF
SENDSTR2:    LD     A,0FFh
             CP    (HL)
             JP     Z, SENDSTR_EXIT
             LD     A,(HL)
             CALL   SENDBYTE    ; send it
             INC    HL
             JP     SENDSTR2   ; do next char
             
SENDSTR_EXIT: POP    AF 
              RET 

;******************************************************************
; IS_DIGIT
;  
; RETURN Z=1 if A is 'A'-'F' otherwise Z=0 (A is unchanged )
; NOTE: A MUST be a non-zero ASCII Digit 
;******************************************************************
IS_DIGIT:    CALL  ISDECDIGIT     ;Is it '0'-'9' 
             JP    Z,IS_DIG_EXIT  ;YES=EXIT with Z=1

             CALL  ISHEXDIGIT     ;test for 'A'-'F' and return
IS_DIG_EXIT: RET

;******************************************************************
; ISHEXDIGIT
;  
; RETURN Z=1 if A is 'A'-'F' otherwise Z=0 (A is unchanged)
; NOTE: A MUST be a non-zero ASCII Digit  
;******************************************************************
ISHEXDIGIT:  CP    'A'             ; is A <'A'?
             JP    M,ISHEXD_EXIT   ; YES=just exit Z=0 
             CP    'G'             ; is A <='F'?
             JP    M,ISHEXD_ZRET   ; YES=return Z=1
             JP    ISHEXD_EXIT     ; otherwise return Z=0
             
ISHEXD_ZRET: CP    A               ;Set Z=1  and Return               
             RET
                              
ISHEXD_EXIT: CP    0               ;Set Z=0  and Return
             RET

;******************************************************************
; ASCII2BYTE
; Convert 2 Hex ASCII bytes in HL to HEX Value in A
; NOTE: L=MSB, H=LSB since strings are usually Hi,Lo eg:"35"
; if we use LD HL,(first_char) HL will be H='5' and L='3'
; NOTE: The values in H&L are assumed to be a valid hex characters
;******************************************************************
ASCII2BYTE:  PUSH  BC              ;Save BC
             LD    A,L             ; Get High Byte from L
             CALL  HEXASCII_VAL    ; Convert to Value in A
             SCF                   ; Set Carry 
             CCF                   ; Invert Carry Flag (Carry is now cleared) 
             RLA                   ; Shift Left 4x
             RLA
             RLA
             RLA
             LD    B,A             ;Save in B
             LD    A,H             ; Get Low byte from H
             CALL  HEXASCII_VAL    ; Convert to a value
             ADD   A,B             ; Add Hi value
             POP   BC              ; Restore BC
             RET                   ; Return

;******************************************************************
; ISDECDIGIT
;  
; RETURN A=1 if A is '0'-'9' otherwise Z=0 (A is unchanged)
; NOTE: A MUST be a non-zero ASCII Digit 
;******************************************************************
ISDECDIGIT:  CP    '0'             ; is A <'0'?
             JP    M,ISDECD_EXIT   ; YES= exit with Z=0 
             CP    03Ah            ; is A <='9'?
             JP    M,ISDECD_ZRET   ; YES=return Z=1
             JP    ISDECD_EXIT     ; otherwise just exit with Z=0
             
ISDECD_ZRET: CP    A               ;Set Z=1  and Return
             RET

ISDECD_EXIT: CP    0               ;Set Z=0  and Return
             RET
;******************************************************************
; MEMSET
; HL=src  B=COUNT A=FILL BYTE 
; COPY A to (HL) for B bytes 
;******************************************************************
MEMSET:      LD    (HL),A
             INC   HL 
             DEC   B
             JP    NZ, MEMSET
             RET
;******************************************************************
; TOUPPER
; Convert ASCII in A to UPPERCASE ASCII in A
;******************************************************************
TOUPPER:     CP     'a'        ;is it <'a'?
             JP     M,TOUP_EXIT ;Exit
             CP     07Bh        ;is it >'z'?
             JP     P,TOUP_EXIT ;Exit 
             AND    05Fh        ;Mask Bits
TOUP_EXIT:   RET       
                           
;******************************************************************
; HEXASCII_VAL
; Convert The ASCII character in A to it's HEX value in A
; RETURN 0xFF if not a hex value
;******************************************************************
HEXASCII_VAL:CALL   TOUPPER
             CP     'G'         ;is it >'F'?
             JP     P,ERR_RET   ; ERRROR
             CP     '0'         ;is it <'0'?
             JP     M,ERR_RET   ; ERRROR
             CP     03Ah        ;is it <='9'?
             JP     M,MASK_RET  ; Convert & return
             CP     'A'         ;is it < 'A'?
             JP     M,ERR_RET   ; ERRROR
             SUB    037h        ;must be 'A'-'F' - Convert to Value  
             RET                ;Return
MASK_RET:    AND    0Fh
             RET             
ERR_RET:     LD     A,0FFh      ; ERROR return Val
             RET       

;******************************************************************
; NIB_TOHEX
; Convert Lo 4 bits of A to ASCII of it's HEX value (0-9 or A-F)
;******************************************************************
NIB_TOHEX:   AND    0Fh          ;Mask Hi 4 Bits
             CP     0Ah          ; is it 9 or less?
             JP     M,ADD_30X  
             ADD    A,07h
ADD_30X:     ADD    A,030h     
             RET

;******************************************************************
; SENDHEX
; Output A as 2 HEX characters
;******************************************************************
SENDHEX:     LD     E,A        ;Save A in E
             RRA
             RRA
             RRA
             RRA
             AND    0Fh         ;Mask Hi 4 Bits              
             CALL   NIB_TOHEX
             CALL   SENDBYTE    ; send it
             LD     A,E
             CALL   NIB_TOHEX
             CALL   SENDBYTE    ; send it
             RET
   
;******************************************************************
; GETHEXBYTE
; input 2 HEX characters and convert to a value in A
; Return with B=FF if error otherwise B=0 
;******************************************************************
GETHEXBYTE:  CALL   GETBYTE        ; get 1 Char (Hi 4 bits)
             LD     A,(FLAGS_A)    ;Test the ECHO flag
             AND    01h
             JP     Z,GHB_NOECHO1
             LD     A,(RX_BYTE)    ;Get RX_BYTE
             CALL   SENDBYTE       ; echo it
GHB_NOECHO1  LD     A,(RX_BYTE)    ;Get RX_BYTE
             CALL   HEXASCII_VAL   ; Convert to value (0-F)
             CP     0FFh           ; if NON-HEX goto GHB_ERROR
             JP     Z, GHB_ERROR   
             RL     A
             RL     A
             RL     A
             RL     A
             AND    0F0h
             LD     (TEMP_01),A
             
             CALL   GETBYTE        ; get 1 Char (low 4 bits)
             LD     A,(FLAGS_A)    ; Test the echo flag
             AND    01h
             JP     Z,GHB_NOECHO2
             LD     A,(RX_BYTE)    ;Get RX_BYTE
             CALL   SENDBYTE       ; echo it
GHB_NOECHO2: LD     A,(RX_BYTE)    ;Get RX_BYTE
             CALL   HEXASCII_VAL   ; Convert to value (0-F)
             CP     0FFh           ; if NON-HEX goto GHB_ERROR
             JP     Z, GHB_ERROR
             LD     B,A            ; Save Lo Value in B 
             LD     A,(TEMP_01)    ; Get Hi Value
             ADD    A,B            ; Add Low value
             LD     (TEMP_01),A    ; Save in TEMP_01
             LD     B,00h          ; Set B=0
             RET
GHB_ERROR:   LD     B,0FFh         ; Set B=0xFF(ERROR) A should also be 0xFF
             RET
                          
;******************************************************************
; RTJUSTVAL
; Shift bytes in VAL_BUF right until left padded with '0's  
;******************************************************************
RTJUSTVAL:   PUSH  IX
             PUSH  BC
             LD    IX,VAL_BUF
             LD    B,05h           ; B=MAX search count 5
             
RTJVAL_LOOP: LD    A,(IX+3)        ; Get last byte from VAL_BUF
             CP    ' '             ; Is It SPACE?
             JP    NZ,RTJVAL_EXIT  ; Exit
             LD    A,(IX+2)        ; Shift 3 bytes left 1 positiom
             LD    (IX+3),A
             LD    A,(IX+1) 
             LD    (IX+2),A
             LD    A,(IX+0) 
             LD    (IX+1),A
             LD    A,'0'           ;Pad first position with '0' 
             LD    (IX+0),A
             DEC   B
             JP    NZ,RTJVAL_LOOP
             
RTJVAL_EXIT: POP   BC
             POP   IX
             RET

;******************************************************************
; GETADDRESS
; Routint only accepts Hex digits, BS or CR(everything else ignored)
; Returns with Z=1 if No Address (CR) or "0000" was entered
;   ADDRESS_HI & ADDRESS_LO will be populated
;******************************************************************
GETADDRESS1: PUSH   HL           ; Call here if a different prompt is used
             PUSH   BC
             JP     GETADDRESS2
GETADDRESS:  PUSH   HL
             PUSH   BC
             LD     HL,TXT_MSG001  ; Print "Enter Address:"             
GETADDRESS2: CALL   SENDSTR        
             ; **** Get 4 Hex Chars store in ADDR_HI & ADDR_LO *****
             LD    B,0           ; B= input byte count
             LD    HL,VAL_BUF    ; HL = Destination pointer(VAL_BUF)
             LD    B,05h
             LD    A,' '
             CALL  MEMSET        ; Fill VAL_BUF with spaces 
             LD    HL,VAL_BUF    ; HL = Destination pointer(VAL_BUF)
             
GAD_NEXTCHR: CALL  GETBYTE       ; get 1 Char
             CALL  TOUPPER       ; convert to UPPERCASE
             LD    (RX_BYTE),A   ; Save UPPERCASE in RX_BYTE
             CP    08h           ; Backspace?
             JP    Z,GAD_DOBKSPC
             CP    07Fh          ; Putty Backspace? (127)
             JP    NZ,GADISRETURN  ; NO =Check for CR  
              
GAD_DOBKSPC: LD    A,B           ; Process Backspace 
             CP    0h            ; is B==0:
             JP    Z,GAD_NEXTCHR ; YES=Just get another byte
             LD    A,08h         ; Back up cursor
             CALL  SENDBYTE      
             LD    A,' '         ; Wipe out last byte
             CALL  SENDBYTE
             LD    A,08h         ; Back up cursor
             CALL  SENDBYTE
             DEC   B             ; Back up byte coune
             DEC   HL            ; Back up HL
             LD    A,' '         
             LD    (HL),A        ; Set current byte back to a space
             JP    GAD_NEXTCHR   ; Get next byte
             
GADISRETURN: CP    0Dh           ; Return char?
             JP    Z,GAD_EXIT    ; YES=Justify , Convert & EXIT
             
             LD    A,03h         ; Max Bytes entered?         
             CP    B
             JP    M, GAD_NEXTCHR ; YES=Just allow BS or CR
             
             LD    A,(RX_BYTE)   ; Get byte entered from RX_BYTE
             
             CALL  IS_DIGIT      ; Is this avalid Hex Digit?
             JP    NZ,GAD_NEXTCHR ;Ignore input 
             
             CALL  SENDBYTE      ; echo it     
             LD    (HL),A        ; Save Byte in (HL)
             INC   HL            ; Inc. HL
             INC   B             ; Inc Byte Counter
             LD    A,04h         ; Max Bytes entered?         
             CP    B
             JP    M, GAD_EXIT   ; Justify, Convert  & Exit
             JP    GAD_NEXTCHR   ; Otherwise get anoter byte
             
GAD_EXIT:    CALL  RTJUSTVAL     ; Right Justify VAL_BUF
             LD    HL,(VAL_BUF)  ; HL = Start of VAL_BUF (Hi Bytes) 
             CALL  ASCII2BYTE
             LD    (ADDR_HI),A
             LD    B,A
             LD    HL,(VAL_BUF+2) ; HL = Last 2 bytes of VAL_BUF (Lo Bytes)
             CALL  ASCII2BYTE
             LD    (ADDR_LO),A
             ADD   A,B            ;If A+B=0 Return with Z flag set(addr=0000)  
             POP   BC
             POP   HL
             RET             
            
;******************************************************************
; DUMP16:  Display 16bytes of memory in HEX and ASCII
;******************************************************************             
DUMP16:      LD     B,010h          ;Set Byte count = 16
             LD     A,(ADDR_HI)    
             CALL   SENDHEX         ;Print Address Hi
             LD     A,(ADDR_LO)
             CALL   SENDHEX         ;Print Address Lo
             
DUMP16_LOOP1:LD     A,B             ; Printing byte 8?
             CP     08h
             JP     NZ,D16_SPACE
             LD     A,'-'           ; Use a dash instead of a space
             JP     D16_SENDB1
D16_SPACE:   LD     A,' '
D16_SENDB1:  CALL   SENDBYTE        ;Print Space or Dash
             LD     A,(HL)           
             CALL   SENDHEX         ;Print Memory value
             INC    HL              ;INC address pointer
             DEC    B               ;DEC byte count
             JP     NZ,DUMP16_LOOP1 ;If not done loop
                 
                                   ;Print ASCII values if printable 
             LD     HL,(ADDR_LO)   ;Reload HL from ADD_LO & ADD_HI
             LD     B,010h         ;Set Byte count = 16
             
             LD     A,' '
             CALL   SENDBYTE        ;Print Space
             CALL   SENDBYTE        ;Print Space 
             
DUMP16_LOOP2:LD     A,(HL)          ;Get byte
             CP     020h            ; Less than Space?
             JP     M,D16_PERIOD    ; Switch to dot
             CP     07Fh            ; Less than or equal '~'?  
             JP     M,D16_SENDB2    ; OK send it - otherwise 
D16_PERIOD:  LD     A,'.'           ; Switch to dot 
D16_SENDB2:  CALL   SENDBYTE        ;Send ASCII char or dot
             INC    HL              ;INC address pointer
             DEC    B               ;DEC byte count
             JP     NZ,DUMP16_LOOP2 ;If not done loop
             
             RET   
;******************************************************************
; GETIHEXREC:
; the ':' command - wait for an iHEX record and store it
;                   verify checksum and respond with '*' if OK 
;******************************************************************             
GETIHEXREC:  LD     A,(FLAGS_A)
             AND    0FEh 
             LD     (FLAGS_A),A  ;Set ECHO OFF
             LD     A,0
             LD     (COUNT_C),A  ;Clear Checksum
             LD     (COUNT_A),A  ;Byte Counter
             
             CALL   GETHEXBYTE  ;GET RECORD LENGTH
             LD     (REC_LEN),A
             LD     (COUNT_A),A
             LD     A,B         ;NON-HEX input returns with 0xFF in B
             CP     0FFh
             JP     Z, GIHR_ERR  ; Goto ERROR Exit
                  
             CALL   GETHEXBYTE    ; get 2 Hex Char
             LD     (ADDR_HI),A   ;Save Byte to ADDR_HI
             LD     A,B           ;NON-HEX input returns with 0xFF in B
             CP     0FFh
             JP     Z, GIHR_ERR  ; Goto ERROR Exit

             CALL   GETHEXBYTE     ; get 2 Hex Char
             LD     (ADDR_LO),A    ;Save Byte to ADDR_LO
             LD     A,B            ;NON-HEX input returns with 0xFF in B
             CP     0FFh
             JP     Z, GIHR_ERR  ; Goto ERROR Exit

             CALL   GETHEXBYTE    ;GET RECORD TYPE
             LD     (REC_TYPE),A
             LD     A,B         ;NON-HEX input returns with 0xFF in B
             CP     0FFh
             JP     Z, GIHR_ERR  ; Goto ERROR Exit
             
             LD     HL,(ADDR_LO) ; Address -> HL
                                        
NEXT_IHEXB:  CALL   GETHEXBYTE   ;Get Data Byte
             LD     (TEMP_01),A  ;Save in TEMP_01
             LD     A,B          ;NON-HEX input returns with 0xFF in B
             CP     0FFh
             JP     Z, GIHR_ERR  ; Goto ERROR Exit
             
             LD     A,(TEMP_01)  ; Add to Checksum Count 
             LD     B,A
             LD     A,(COUNT_C)
             ADD    A,B
             LD     (COUNT_C),A
             
             LD     A,(TEMP_01)   ; Get input byte   
             LD     (HL),A        ; Store in Memory  
             INC    HL            ; Inc Address Pointer
             
             LD     A,(COUNT_A)   ; Get Byte Counter
             DEC    A             ; Decrement
             JP     Z,GIHR_CSUM   ; Done? - Calculate Checksum
             LD     (COUNT_A),A   ; Update Counter
             JP     NEXT_IHEXB    ; Get next byte

GIHR_CSUM:   CALL   GETHEXBYTE    ; GET INPUT CHECKSUM
             LD     (REC_CSUM),A 
             LD     A,B           ; NON-HEX input returns with 0xFF in B
             CP     0FFh
             JP     Z, GIHR_ERR   ; Goto ERROR Exit
             
             LD     A,(COUNT_C)   ; Get Checksum counter
             LD     B,A           ; Put total in B  
             LD     A,(REC_LEN)   ; Get Rec Len 
             ADD    A,B           ; Add Total
             LD     B,A           ; Save New Total
             LD     A,(REC_TYPE)  ; Get Rec Type
             ADD    A,B             ; Add Total
             LD     B,A           ; Save New Total
             LD     A,(ADDR_HI)   ; Address HI
             ADD    A,B             ; Add Total
             LD     B,A           ; Save New Total
             LD     A,(ADDR_LO)   ; Address LO
             ADD    A,B           ; Add Total
             NEG                  ; 2's complement 
             LD     (COUNT_C),A   ; Save in Checksum counter
             LD     B,A           ; also in B 
              
             LD     A,(REC_CSUM)  ; Get Input Checksum
             CP     B
             JP     NZ,GIHR_ERR2  ; Checksum Error
                                  ; Otherwise 
             JP     GIHR_EXIT     ; Good Record - Exit
             
GIHR_ERR:    LD     A,'?'         ; Input Error (NON-HEX data)
             JP     GIHR_EXIT1
              
GIHR_ERR2:   LD     A,'E'         ; Checksum Error
             JP     GIHR_EXIT1 
             
GIHR_EXIT:   LD     A,'*'
GIHR_EXIT1:  CALL   SENDBYTE

             LD     A,(FLAGS_A)
             OR     01h
             LD     (FLAGS_A),A  ;Set ECHO ON
             LD     A,0
             RET

;******************************************************************
; SNDIHEXREC:  the ';' command
; Get Length and start address and send an iHEX record with checksum
;******************************************************************             
SNDIHEXREC:  LD     A,0
             LD     (COUNT_C),A  ;Clear Checksum
             LD     (COUNT_A),A  ;Byte Counter
             LD     (REC_TYPE),A  ;Record Type always = 0

             LD     A,(FLAGS_A)
             AND    0FEh 
             LD     (FLAGS_A),A  ;Set ECHO OFF
             
             CALL   GETHEXBYTE  ;GET RECORD LENGTH
             LD     (REC_LEN),A
             LD     (COUNT_A),A
             LD     A,B         ;NON-HEX input returns with 0xFF in B
             CP     0FFh
             JP     Z, SIHR_ERR  ; Goto ERROR Exit

             CALL   GETHEXBYTE    ; get 2 Hex Char
             LD     (ADDR_HI),A   ;Save Byte to ADDR_HI
             LD     A,B           ;NON-HEX input returns with 0xFF in B
             CP     0FFh
             JP     Z, SIHR_ERR  ; Goto ERROR Exit

             CALL   GETHEXBYTE    ; get 2 Hex Char
             LD     (ADDR_LO),A   ;Save Byte to ADDR_HI
             LD     A,B           ;NON-HEX input returns with 0xFF in B
             CP     0FFh
             JP     Z, SIHR_ERR  ; Goto ERROR Exit
                  
             LD     A,' '
             CALL   SENDBYTE     ;Send Space to Indicate good len & address.
                          
             LD     HL,(ADDR_LO)
                                        
NEXT_SIHEXB: LD     A,(HL)       ;Get Data from memory  

             CALL   SENDHEX      ;Print Memory value
             LD     A,(HL)       ;Get Data from memory (again)
             
             LD     B,A          ;Add to Checksum counter
             LD     A,(COUNT_C)
             ADD    A,B
             LD     (COUNT_C),A
             
             INC    HL            ; Inc Address Pointer
             
             LD     A,(COUNT_A)   ; Get Byte Counter
             DEC    A             ; Decrement
             LD     (COUNT_A),A   ; Update Counter
             JP     Z,SIHR_CSUM   ; Done? - Calculate Checksum
             JP     NEXT_SIHEXB   ; Send next byte

SIHR_CSUM:   LD     A,(COUNT_C)   ; Get Checksum counter
             LD     B,A           ; Put total in B  
             LD     A,(REC_LEN)   ; Get Rec Len 
             ADD    A,B           ; Add Total
             LD     B,A           ; Save New Total
             LD     A,(REC_TYPE)  ; Get Rec Type
             ADD    A,B             ; Add Total
             LD     B,A           ; Save New Total
             LD     A,(ADDR_HI)   ; Address HI
             ADD    A,B             ; Add Total
             LD     B,A           ; Save New Total
             LD     A,(ADDR_LO)   ; Address LO
             ADD    A,B           ; Add Total
             NEG                  ; 2's complement 
             LD     (COUNT_C),A   ; Save in Checksum counter
             CALL   SENDHEX       ; Send Checksum
             JP     SIHR_EXIT     ; Exit
             
SIHR_ERR:    LD     A,'?'         ; Input Error (NON-HEX data)
             CALL   SENDBYTE 

SIHR_EXIT:   LD     HL,TXT_MSG_NL ; send CR & LF 
             CALL   SENDSTR
              
             LD     A,(FLAGS_A)
             OR     01h
             LD     (FLAGS_A),A  ;Set ECHO ON
             RET

;******************************************************************
; DASM_MAIN     Z80 Dis-Assembler
; Based on tables used by the TASM for the Z80 target 
;******************************************************************
             
DASM_MAIN:   LD     HL,TXT_MSG003 ; get starting address 
             CALL   GETADDRESS1   ; Print "Enter Start Address:" Get 4 Hex bytes
             
             LD     HL,(ADDR_LO)  ; Get Start address from ADDR_LO & ADDR_HI 
             LD     (SRC_ADDR),HL ; Save in SRC_ADDR & SRC_ADDR+1
             
             LD     BC,0h         ; Add 1 To Start Address  BC=0000
             SCF                  ; C=1
             ADC    HL,BC         ; Add HL+BC+C to HL(FFFF will overflow to 0000)  
             RET    Z             ; Exit if xFFFF was entered
             
             LD     HL,TXT_MSG004 ; get end address 
             CALL   GETADDRESS1   ; Print "Enter End Address:" Get 4 Hex bytes
             JP     NZ,DASM_UENDAD ; User entered a non-zero address(use it)
             
             LD     (ASM_ADDR),A    ;NOT Using End Address - Just do 16 rows
             LD     (ASM_ADDR+1),A  ;Set ASM_ADDR=x0000
             
             LD     A,10h
             LD     (COUNT_C),A   ; Set Row Counter = 16
             JP     DASM_UROWCT
             
DASM_UENDAD: LD     A,0FFh        ; End Address Was entered - Use It
             LD     (COUNT_C),A   ; Set Row Counter = xFF           
             
             LD     HL,(ADDR_LO)
             LD     (ASM_ADDR),HL
DASM_UROWCT: LD     HL,(SRC_ADDR)
             LD     (ADDR_LO),HL
             
             ; ** Print CR, LF, ADDR_HI, ADDR_LO (in HEX), space
DASM_LOOP1:  LD     HL,TXT_MSG_NL ; Print CR & LF
             CALL   SENDSTR       
             LD     A,(ADDR_HI)   ; Print Address Buffer
             CALL   SENDHEX
             LD     A,(ADDR_LO)
             CALL   SENDHEX
             LD     A,' '          ; Print Space
             CALL   SENDBYTE
             
             LD     HL,ASM_BUF    ; Clear ASM_BUF, INS_BUF, PARM_BUF & VAL_BUF
             LD     B,30h         ; (Set to all spaces)
             CALL   MEMSET
             
             ; ** Get 2 bytes from memory pointed to by ADDR_LO & ADDR_HI
             LD     HL,(ADDR_LO) ; Address ->HL
             LD     A,(HL)       ; First Byte ->A
             LD     (ML_BUF),A   ; Store in ML_BUF Byte 0

             INC    HL
             LD     A,(HL)       ; Second Byte ->A
             LD     (ML_BUF+1),A ; Store in ML_BUF Byte 1
             
             CALL   DASMBITINST  ; Is This a BIT,SET or RES Inst.?
             JP     NZ,DASM_FIND ; NO=Do regular search
             CALL   DSMFINDOPCD  ; Search For Matching BIT,SET,RES OP Code
             JP     Z,ERR_MSG    ; NOT FOUND - Error Message
             CALL   DASMGETINST  ; Copy 4 byte  Assembler Inst. to ASM_BUF
             JP     DASM_JUSTV   ; VAL_BUF has already been populated            
             
DASM_FIND:   CALL   DSMFINDOPCD  ; Search For Matching OP Code
             JP     Z,ERR_MSG    ; NOT FOUND - Error Message
             
             CALL   DASMGETINST   ; Copy 4 byte  Assembler Inst. to ASM_BUF
             
             ; ** Are Data Bytes expected? YES=COPY TO VAL_BUF
             LD     A,'0'
             LD     (VAL_BUF_HI),A   ; Set VAL_BUF_HI="00"
             LD     (VAL_BUF_HI+1),A
             LD     A,0
             LD     (VAL_BUF_LO),A   ; Set VAL_BUF_LO=NULL(NO DATA indicator)
             
             CALL   DASMGETVAL       ; Get 1 or 2 value bytes from memory
             
DASM_JUSTV:  CALL   DSMLFJVAL        ; Left justify VAL_BUF(Trim leading zeros)
             
             CALL   DASMGETPARM      ; Build parameter string with value data

             CALL   DSMRTRIMASM      ; Trim trailing spaces from ASM_BUF
             
             LD     A,0Fh     ; Output Memory Bytes and Advance Address Pointer
             LD     C,A
             LD     HL,(ADDR_LO)     ; Address ->HL
             LD     A,(ML_BTCOUNT)   ;Get Total Byte count from lookup table
             LD     B,A              ;Save in B
DASM_MEMOUT: LD     A,(HL)
             CALL   SENDHEX
             LD     A,' '            ; Print Space
             CALL   SENDBYTE
             INC    HL               ; Adjust memory pointer and byte count
             DEC    C
             DEC    C
             DEC    C
             DEC    B
             JP     NZ,DASM_MEMOUT   ; DONE?  NO=Continue
             LD     (ADDR_LO),HL     ; Save New Memory Address
             
DASM_SPCOUT: LD     A,' '            ; Pad with spaces to 15 bytes             
             CALL   SENDBYTE
             DEC    C
             JP     NZ,DASM_SPCOUT   ; DONE?  NO=Continue
                                      
             LD     HL,ASM_BUF       ; Send Assembly string 
             CALL   SENDSTR             
             
             LD     A,(COUNT_C)      ; Get Row Count
             CP     0FFh             ; Using End Address?
             JP     Z,DASM_CKEADR             
             DEC    A                ; Decrement
             RET    Z                ; DONE? - YES = Exit
             LD     (COUNT_C),A      ; NO= Save Row Count 
             JP     DASM_LOOP1       ; Continue...
             
DASM_CKEADR: LD     HL,(ASM_ADDR)    ; Get End Address
             LD     BC,(ADDR_LO)     ; Get Memory Address pointer
             SBC    HL,BC            ; Subtract End from Current
             RET    M                ; If resulte negative - Exit
             JP     DASM_LOOP1       ; Otherwise Continue... 
             
;******************************************************************
; Dis-Assembler Routines
;******************************************************************

;******************************************************************
; ISVALBUF0
; Return Z=1 if VAL_BUF contains a single '0' followed by a NULL  
;******************************************************************
ISVALBUF0:  LD     A,(VAL_BUF)
            CP     '0'
            JP     NZ,IZVBFZ_RET
            LD     A,(VAL_BUF+1)
            CP     0
IZVBFZ_RET: RET
                  
;******************************************************************
; ISIXIYPRM
; Is parameter (IX*) or (IY*)  
;******************************************************************
ISIXIYPRM:   PUSH  BC
             PUSH  HL
             LD    C,0              ; C = match counter
             LD    B,7              ; B = byte counter
             LD    HL,(ROW_ADDR)    ; HL = Row data pointer
ISIX_LOOP:   LD    A,(HL)           ; Get a byte from row
             CP    '('              ; If '(', 'I' or '*' Increment C
             JP    Z,ISIX_CKI 
             CP    '*'
             JP    Z,ISIX_COUNT 
             JP    ISIX_NEXT        ;None of the above then continue
             
ISIX_CKI:    INC   HL               ;Check for '(' followed by 'I'
             LD    A,(HL)           ;Get byte after the '(' just found
             CP    'I'              ;Is it = 'I'?
             JP    Z,ISIX_COUNT     ;Yes=Count the match
             JP    ISIX_NEXT2       ;No = Continue
             
ISIX_COUNT:  INC   C
ISIX_NEXT:   INC   HL               ; Advance row data pointer
ISIX_NEXT2:  DEC   B                ; Decrement byte count
             JP    NZ,ISIX_LOOP     ; DONE?  NO = Continue
             LD    A,C              ; Get match count
             CP    2                ; If = 2 Return Z=1 otherwise Z=0
             POP   HL
             POP   BC
             RET
;******************************************************************
; DSMRTRIMASM
; Trim trailing spaces from ASM_BUF  
;******************************************************************
DSMRTRIMASM: PUSH  BC
             PUSH  HL 
             LD    B,0Fh           ; B=MAX loop count 15
             LD    HL,ASM_BUF+15   ; HL=tail of ASM_BUF
             
DSMRTA_LOOP: LD    A,(HL)          ; Get a byte from VAL_BUF
             CP    ' '             ; Is It ' '?
             JP    NZ,DSMRTA_EXIT  ; No = Exit
             LD    A,0FFh          ; A=FFh
             LD    (HL),A          ; Store in ASM_BUF 
             DEC   HL              ; Decrement ASM_BUF pointer
             DEC   B               ; Decrement byte count
             JP    NZ,DSMRTA_LOOP  ; Done? No=Continue
             
DSMRTA_EXIT: POP   HL              ; Restore BC, HL & Exit
             POP   BC
             RET
;******************************************************************
; DSMLFJVAL
; Shift bytes in VAL_BUF left until non-zero char is encountered  
;******************************************************************
DSMLFJVAL:   PUSH  BC
             LD    B,03h           ; B=MAX loop count 3
             
DSMLFJ_LOOP: LD    A,(VAL_BUF)     ; Get 1st byte from VAL_BUF
             CP    '0'             ; Is It '0'?
             JP    NZ,DSMLFJ_EXIT  ; No = Exit
             LD    A,(VAL_BUF+1)   ; Shift 3 bytes left 1 positiom
             LD    (VAL_BUF),A
             LD    A,(VAL_BUF+2) 
             LD    (VAL_BUF+1),A
             LD    A,(VAL_BUF+3) 
             LD    (VAL_BUF+2),A
             LD    A,0           ;Set last position to NULL 
             LD    (VAL_BUF+3),A
             DEC   B
             JP    NZ,DSMLFJ_LOOP
             
DSMLFJ_EXIT: POP   BC
             RET

;******************************************************************
; BYTE2ASCII
; Convert Hex Value of A to 2 Hex ASCII bytes in HL 
; NOTE: L=MSB, H=LSB since strings are usually Hi,Lo eg:"35"
; if we use LD (address),HL  then address = L and address+1 = H
;******************************************************************
BYTE2ASCII:  LD     H,A        ;Save A in H
             RRA               ;Shift Hi 4 Bits to Low 4 Bits 
             RRA
             RRA
             RRA
             CALL   NIB_TOHEX
             LD     L,A        ; MSB->L
             LD     A,H        ;Restore A from H  
             CALL   NIB_TOHEX
             LD     H,A        ; LSB->H
             RET
 
;******************************************************************
; DASMBITINST
; ML_BUF contains 2 bytes from current memory location.
; If Byte1=0xCB and (Byte2 & 0xC0) > 0 This is a BIR, SET or RES inst.
; Pull the "Bit" value from Byte2 and populate VAL_LO 
; Mask the "Bit" indicator bits from byte 2 and do the lookup
;******************************************************************

DASMBITINST: LD    B,0CBh            ;B=0xCB 
             LD    A,(ML_BUF)        ;A=ML_BUF Byte1
             CP    B                 ;Compare A with B
             JP    NZ,DASMBIT_RET    ;NoMatch Exit with Z=0 
             LD    A,(ML_BUF+1)      ;Get Byte2
             AND   0C0h              ;AND with 0xCO
             JP    NZ,DASMBIT_VAL    ;Not Zero then this is a BIT,SET or RES
             LD    A,0FFh            ;Otherwise...
             JP    DASMBITRETN       ;Return with Z=0  
       
DASMBIT_VAL: LD    A,(ML_BUF+1)      ;Get Byte2
             AND   038h              ;Mask All but 'BIT#' bits
             RRA                     ;Shift Right 3x
             RRA
             RRA
             AND   07h
             PUSH  HL                ;Save Address Pointer
             CALL  BYTE2ASCII        ;Convert A to 2 ASCII Bytes in HL
             LD    (VAL_BUF_LO),HL   ;Store 2 bytes in VAL_BUF_LO
             LD    A,'0'
             LD    (VAL_BUF_HI),A 
             LD    (VAL_BUF_HI+1),A  ;Store '00' in VAL_BUF_HI
             POP   HL                ;Restore Address pointer              
             LD    A,(ML_BUF+1)      ;Get Byte2
             AND   0C7h              ;AND with 0xC7
             LD    (ML_BUF+1),A      ;Replace MLByte2  
DASMBITRETZ: LD    A,0               ;Return with Z=1
DASMBITRETN: CP    0                 ;Return with Z=0
DASMBIT_RET: RET                     
 
;******************************************************************
; DASMGETPARM
; Build the Assembly instruction parameter string from bytes in 
; the found row in the lookup table. 
; Assumes justified value bytes are already in VAL_BUF if required.
; NOTE: ROW_ADDR is set by successful find by DSMFINDOPCD
;******************************************************************

DASMGETPARM: LD    B,7               ;Byte Counter = 7 
             LD    IY,ASM_BUF+5;     ;IY=Target Address (ASM_BUF+5)
             LD    IX,(ROW_ADDR)     ;IX=Source Address (Table Row Address)
DASM_GETPRM: LD    A,(IX)            ;Get Parm Byte 
             CP    '*'               ;Is it a '*'? 
             JP    NZ,DASM_SAVPAR    ;NO=Save Parm byte
             
             CALL  ISIXIYPRM         ;Is this an (IX*) ot (IY*) Parm?
             JP    NZ,DASM_MOVVAL    ;NO=Just move the value bytes
             CALL  ISVALBUF0         ;Is VAL_BUF="0"
             JP    Z,DASM_NXTPR2     ;YES=Skip move of value bytes
             LD    A,'+'
             LD    (IY),A            ;Store a '+'
             INC   IY                ;Advance Target Address & move value bytes
             
DASM_MOVVAL: LD    C,4               ;Byte count=4
             LD    HL,VAL_BUF        ;HL = VAL_BUF
DASM_MVLOOP: LD    A,(HL)            ;Get a value byte 
             CP    0                 ;NULL?
             JP    Z,DASM_SAVH       ;YES=DONE goto Save 'h' & continue  
             LD    (IY),A            ;Store the value char
             INC   IY                ;Advance destination (ASM_BUF) pointer
             INC   HL
             DEC   C
             JP    NZ,DASM_MVLOOP
             
DASM_SAVH:   LD    A,'h'             ;Load the 'h'
DASM_SAVPAR: LD    (IY),A            ;Store parm char
DASM_NXTPAR: INC   IY                ;Advance Target Address
DASM_NXTPR2: INC   IX                ;Advance Source Address
             DEC   B                 ;Count Source bytes
             JP    NZ,DASM_GETPRM    ;DONE? NO=Continue
             RET                     ;YES= Exit
             
;******************************************************************
; DASMGETVAL
; Copy 1 or 2 bytes of value data from memory to VAL_BUF 
; Data value are converted to ASCII HEX chars in VAL_BUF
; NOTE: ML_BTCOUNT is set by successful find by DSMFINDOPCD
;******************************************************************

DASMGETVAL:  LD    HL,(ADDR_LO)   ;Get memory Address->HL
             LD    A,(ML_BTCOUNT) ;Get Total Byte count from lookup table
             LD    B,A            ;Save in B
             DEC   B              ;Skip 1 Byte count
             INC   HL             ;Skip 1 byte in memory             
             LD    A,(ML_BUF+1)   ;Is this a 2 byte instruction?
             CP    0
             JP    Z,DASM_CKBTCNT ;NO= check final byte count
             DEC   B              ;Decrement byte count
             INC   HL             ;Adjust memory pointer
DASM_CKBTCNT:LD    A,0            
             CP    B              ;Is byte count=0?
             JP    Z,DASM_GVEXIT  ;YES=NO Data Bytes expected - Exit
             LD    A,(HL)         ;Get 1st Data Byte from memory
             PUSH  HL             ;Save Address Pointer
             CALL  BYTE2ASCII     ;Convert A to 2 ASCII Bytes in HL
             LD    (VAL_BUF_LO),HL ;Store 2 bytes in VAL_BUF_LO
             POP   HL              ;Restore Address pointer
             DEC   B
             LD    A,0            
             CP    B              ;Is byte count=0?
             JP    Z,DASM_GVEXIT  ;YES=NO More Data Bytes expected - Exit
             INC   HL              
             LD    A,(HL)         ;Get 2nd Data Byte from memory
             CALL  BYTE2ASCII     ;Convert A to 2 ASCII Bytes in HL
             LD    (VAL_BUF_HI),HL ;Store 2 bytes in VAL_BUF_LO
DASM_GVEXIT: RET
             
;******************************************************************
; DASMGETINST
; Copy 4 byte Assembler Instruction to ASM_BUFF
; NOTE: BLK_ADDR is set by successful find by DSMFINDOPCD
;******************************************************************
DASMGETINST: LD     HL,(BLK_ADDR) ; Block Header Row Address ->HL
             LD     DE,ASM_BUF    ; ASM_BUF address->DE
             LD     B,04h         ; Byte Count=4
DASM_MOVINS: INC    HL            ; Inc Block Header data pointer
             LD     A,(HL)        ; Get 1 byte from Block Header
             LD     (DE),A        ; Save to ASM_BUF 
             INC    DE            ; Inc destination (ASM_BUF) pointer
             DEC    B             ; Dec byte count
             JP     NZ,DASM_MOVINS  ;DONE? No=Continue
             RET                    ; YES=Exit 
             
;******************************************************************
; DSMFINDOPCD
; ML_BUF contains 2 bytes from current memory location.
; Search opcode table for a matching opcode
; Return with BLK_ADDR=block header address, ROW_ADDR=found row address
; ML_BYCOUNT=a non-zero count if match was found  
;******************************************************************

DSMFINDOPCD: PUSH  BC
             LD    IX,OPCD_TABLE   ;Set IX=Table Start Address
DSMFN_LOOP1: LD    A,(IX+0)
             CP    '#'             ;Is Row Byte0='#'?
             JP    NZ,DSMFNCKBT1   ;YES=SAVE IX->BLK_ADDR
             LD    (BLK_ADDR),IX
             JP    DSMFN_NXTROW
             
DSMFNCKBT1:  LD    A,(ML_BUF)      ;IS ML_BUF0=(CB,DD,ED or FD)? 
             CP    0CBh
             JP    Z,DSMFN_CKBT2
             CP    0DDh
             JP    Z,DSMFN_CKBT2
             CP    0EDh
             JP    Z,DSMFN_CKBT2
             CP    0FDh
             JP    Z,DSMFN_CKBT2
             LD    C,(IX+7)        ; If ML_BUF0 is NOT one of the above
             CP    C               ; Compare with row byte7  
             JP    NZ,DSMFN_NXTROW ; NO=Next Row
             LD    A,0              
             LD    C,(IX+8)        ; Get Row Byte8
             CP    C               ; Is it Zero
             JP    Z,DSMFN_MATCH   ; YES=MATCH! 
             JP    DSMFN_NXTROW    ; NO=Next Row
             
DSMFN_CKBT2: LD    C,(IX+8)        ;If ML_BUF0=(CB,DD,ED or FD)?
             CP    C               ; Compare with row byte8
             JP    NZ,DSMFN_NXTROW ; NO=Next Row
             LD    A,(ML_BUF+1)    ; YES=Check Next Byte
             LD    C,(IX+7)        ; Combare with row byte7
             CP    C   
             JP    Z,DSMFN_MATCH   ;   YES=MATCH!                      
                                   
DSMFN_NXTROW:LD    BC,000Ah        ; Add 10 to IX and KEEP LOOKING
             ADD   IX,BC
             LD    A,(IX+5)        ; End Of Lookup Table?
             CP    0
             JP    NZ,DSMFN_LOOP1   ; NO=Keep Looking otherwise EXIT
 
DSMFN_MATCH: LD    (ROW_ADDR),IX    ; Save IX->ROW_ADDR
             LD    A,(IX+8)
             LD    (ML_BUF+1),A     ; Save row byte8 ->ML_BUF1
             LD    A,(IX+9)
             LD    (ML_BTCOUNT),A   ; Save byte count->ML_BYCOUNT
             CP    0                ; Set Z flag if NOT FOUND  
             POP   BC
             RET
;******************************************************************
             
;******************************************************************
; *** END  DIS_MAIN
;******************************************************************

;******************************************************************
; ASM_MAIN  Z80 Assembler
; Based on tables used by the TASM for the Z80 target
;******************************************************************

ASM_MAIN:   CALL   GETADDRESS  ; Print "Enter Address:" and get 4 hex bytes
             
             ; ** Print CR, LF, ADDR_HI, ADDR_LO (in HEX), space
ASM_LOOP1:   LD     HL,TXT_MSG_NL ; Print CR & LF
             CALL   SENDSTR       
             LD     A,(ADDR_HI)   ; Print Address Buffer
             CALL   SENDHEX
             LD     A,(ADDR_LO)
             CALL   SENDHEX
             LD     A,' '          ; Print Space
             CALL   SENDBYTE
             
             LD     HL,ASM_BUF    ; Clear ASM_BUF, INS_BUF, PARM_BUF & VAL_BUF
             LD     B,30h
             CALL   MEMSET
              
             CALL   GETASMBLY    ; Input 1 line of Assembly Code
             LD     A,(ASM_BUF)  ; Check 1st byte of ASM_BUF
             CP     0            ; Nothing was entered (QUIT) 
             JP     Z,ASM_EXIT   ; Just exit
              
ASM_LOOP2:   LD     A,' '        ; print spaces (16-input length from B)
             CALL   SENDBYTE
             INC    B
             LD     A,B
             CP     0Fh
             JP     M,ASM_LOOP2             
          
             
ASM_CPYINS:  LD     DE,INS_BUF   
             LD     HL,ASM_BUF
             CALL   CPY2SPC      ; Copy the instruction from ASM_BUF to INST_BUF 
             CALL   SKIPSPC      ; find the start of the parm. bytes
             
             LD     BC,PARM_BUF   
             CALL   PADWSPC      ; Pad the instruction buffer to 4 bytes
             
             ;**** Process the input parameter *****
             LD     A,10h
             LD     B,A             ; Load byte counter =16 
GET_NEXTASM: LD     A,(HL);         ; Get 1 byte from ASM_BUF
             CP     0               ; if we reached the end of input?
             JP     Z,ASMLOOP_EXIT  ; just exit
             CALL   ISFLAGORNUM     ; Is it $,+,# or 0-9?
             JP     NZ,SAVE_ASMCHR
             CALL   ASMGETVAL       ; Extract the numbers to VAL_BUF
             LD     A,'*'           ; Load PARM_BUF with a '*'
             LD     (DE),A          
             INC    DE              ; Advance dest. pointer
             LD     A,(HL);         ; Get next non-number byte from ASM_BUF

SAVE_ASMCHR: CP     0               ; if we reached the end while in getval()?
             JP     Z,ASMLOOP_EXIT  ; just exit
             LD     (DE),A          ; Otherwise store the byte
             INC    DE              ; Advance dest. pointer
             INC    HL              ; Advance src. pointer
             DEC    B
             JP     NZ,GET_NEXTASM
             

ASMLOOP_EXIT:LD     BC,VAL_BUF   
             CALL   PADWSPC      ; Pad the parm buffer to 7 bytes
             
             LD     (SRC_ADDR),HL ;Save HL & DE
             LD     (DES_ADDR),DE
             
             CALL   ASMFINDINST     ; Find Instruction in table
             LD     A,(BLK_SIZE)    ; Got a match? YES=search for a parameter match
             CP     0
             JP     NZ,ASM_FINDPRM   
             LD     HL,TXT_ASMERR1  ; Print "?"  ERROR: Instruction Not Found
             CALL   SENDSTR
             JP     ASM_LOOP1       ;Get another line of ASM input... 
             ;; DEBUG JP     DUMP_MEM1       ; Show buffers & variables
             
             
ASM_FINDPRM: CALL   ASMFINDPARM     ; Look for matching parameter pattern
             LD     A,(ML_BUF+2)    ; Found one? NO=ERROR 
             CP     0               
             JP     NZ,ASMOUTML
             LD     HL,TXT_ASMERR2  ; Print "??"  ERROR parameter Not Found
             CALL   SENDSTR
             JP     ASM_LOOP1       ;Get another line of ASM input... 
             ;; DEBUG JP     DUMP_MEM1       ; Show buffers & variables 
             
             
ASMOUTML:    CALL   RTJUSTVAL     ; Right Justify VAL_BUF
             
             LD     HL,(VAL_BUF_HI)  ;Convert 4 ASCII Chars in VAL_BUF to 2 values
             CALL   ASCII2BYTE
             LD     (VAL_HI),A
             
             LD     HL,(VAL_BUF_LO)
             CALL   ASCII2BYTE
             LD     (VAL_LO),A

             ;; Populate OUT_BUF with ML output             
             LD     IX,OUT_BUF
             LD     A,(ML_BUF+1)
             CP     0
             JP     Z,ASMNOBYTE2
             LD     (IX),A
             INC    IX
             CP     0CBh             ;Is this a BIT,SET or RES Inst?
             JP     NZ,ASMNOBYTE2    ;NO=Continue
             LD     A,(ML_BUF)       ;YES=Check 1st ML byte
             AND    0C0h             ;Are Bits 7 or 6 are set?
             JP     Z,ASMNOBYTE2     ;NO=Continue
             LD    A,(ML_BUF)        ;YES=Combine Val with ML_BUF byte1
             LD    B,A
             LD    A,(VAL_LO)
             SLA   A
             SLA   A
             SLA   A
             AND   38h
             OR    B
             LD   (ML_BUF),A
             
ASMNOBYTE2:  LD     A,(ML_BUF)
             LD    (IX),A
             INC   IX
             
             LD    A,(VAL_LO)
             LD    (IX),A
             INC   IX 
             LD    A,(VAL_HI)
             LD    (IX),A

             ;; *** Move ML code(s) to target address,  *** 
             ;; *** print them and adjust pointer       ***      
             LD     HL,TXT_MSGSPC4  ; Print "   "
             CALL   SENDSTR                   

ASM_TOMEM:   LD    A,(ML_BTCOUNT)  ;Load Byte Count ->B
             LD    B,A
             LD    IX,OUT_BUF      ;Load IX with OUT_BUF address 
ASM_TOMEM1:  LD    HL,(ADDR_LO)    ;Load HL with Target Address
             LD    A,(IX)          ;Get Byte to Move
             LD    (HL),A          ;Store at target address
             CALL  SENDHEX         ;Print it
             LD    A,' '           ;Print 1 space
             CALL  SENDBYTE        
             INC   HL              ;Advance Target Pointer
             LD    (ADDR_LO),HL    ;Save in ADDR_LO & HI
             INC   IX              ;Advance ML_BUF pointer
             DEC   B               ;Decrement byte counter
             JP    NZ,ASM_TOMEM1   ;Done? NO=Continue
             JP    ASM_LOOP1       ;Get another line of ASM input...       
             
ASM_EXIT:    LD     HL,TXT_OKMSG  ; Print "OK"
             CALL   SENDSTR      
             RET      	     
             
ASM_ERR_MSG: LD     HL,TXT_ERRMSG  ; Print "ERROR"
             CALL   SENDSTR      
             RET
           
;******************************************************************
;  END of ASM_MAIN
;******************************************************************             
;******************************************************************
; Z80 Assembler Routines
;******************************************************************
;******************************************************************
; ASMFINDPARM
; HL=src  dest = PARM_BUF  
; Search block until match of PARM_BUF or end of block is found
; Return with HL pointing to match block B=block count
;******************************************************************
ASMFINDPARM: PUSH  DE
             PUSH  BC
             PUSH  HL
             LD    IX,(BLK_ADDR)    ;Load Saved Block Address->IX
             LD    A,(BLK_SIZE)    ;Get Block Size
             LD    L,A             ;L=ROW COUNTER
AFP_NEXTROW: LD    DE,000Ah        ;10 bytes per row
             ADD   IX,DE           ;Add 10 to Address (next block)
             LD    (ROW_ADDR),IX   ;Save ROW Address
             LD    IY,PARM_BUF     ;IY=PARM_BUF              
             LD    C,07h           ;Loop count =7
AFP_CMPLOOP: LD    A,(IX+0)        ;Get Table byte->A
             LD    B,(IY+0)        ;Get PARM_BUF byte->B  
             CP    B               ;Compare A-B
             JP    NZ,AFP_NOMATCH  ;Mismatch = Exit loop
             INC   IX              ;Advance pointers
             INC   IY
             DEC   C               ;Decrement loop count
             JP    NZ,AFP_CMPLOOP  ;Not done yet - continue
             JP    AFP_MATCH       ;Match Found Get ML Bytes & Counts
                                   ;Match not found, advance to next block                 
AFP_NOMATCH: DEC   L               ;Decrement row counter 
             JP    Z,AFP_NOFIND    ;Done = NOT FOUND EXIT
             LD    IX,(ROW_ADDR)   ;Get Saved ROW Address->IX
             JP    AFP_NEXTROW     ;Continue 
             
AFP_NOFIND:  LD    A,0             ;Not Found set ML_BUF[2]=0  
             LD    (ML_BUF+2),A
             JP    AFP_EXIT
             
AFP_MATCH:   LD    A,(IX+0)        ;Get Table ML Byte 1
             LD    (ML_BUF),A      ;Save it in M_BUF[0]
             LD    A,(IX+1)        ;Get Table ML Byte 2
             LD    (ML_BUF+1),A    ;Save it in M_BUF[1]
             LD    A,(IX+2)        ;Get Table  ML Byte count
             LD    (ML_BUF+2),A    ;Save it in M_BUF[2]
             
AFP_EXIT:    POP   HL
             POP   BC
             POP   DE
             RET

;******************************************************************
; ASMFINDINST
; HL=src  dest = VAL_BUF  
; Search table until match of INS_BUF or end of table is found
; Return with IX pointing to match block B=block count
;******************************************************************
ASMFINDINST: PUSH  DE
             PUSH  BC
             LD    A,0
             LD    (ROW_NUM),A
             LD    IX,OPCD_TABLE
AFI_NEXTBLK: LD    (BLK_ADDR),IX   ;Save Block Address
             LD    A,(IX+5)        ;Get Block Size & Save
             LD    (BLK_SIZE),A
             CP    0               ;If Block Size = 0 EXIT
             JP    Z,AFI_EXIT
             
             LD    IY,INS_BUF      ;IX=INS_BUF              
             LD    C,04h           ;Loop count =4
AFI_CMPLOOP: LD    A,(IX+1)        ;Get Table byte->A
             LD    B,(IY+0)        ;Get INS_BUF byte->B  
             CP    B               ;Compare A-B
             JP    NZ,AFI_NOMATCH  ;Mismatch = Exit loop
             INC   IX              ;Advance pointers
             INC   IY
             DEC   C               ;Decremebnt loop count
             JP    NZ,AFI_CMPLOOP  ;Not done yet - continue
             JP    AFI_EXIT        ;Match Found EXIT
                                   ;Match not found, advance to next block                 
AFI_NOMATCH: LD    A,(BLK_SIZE)    ;Get Block Size
             INC   A               ;Add 1 to Block count
             LD    IX,(BLK_ADDR)   ;Get Saved Block Start Address
             LD    DE,000Ah        ;10 bytes per row
AFI_BLKLOOP: ADD   IX,DE           ;Add 10 to Address 
             DEC   A               ;Decrement block counter 
             JP    NZ,AFI_BLKLOOP  ;Not Done = loop
             LD    A,(ROW_NUM)     ;Advance Row Number
             INC   A
             LD    (ROW_NUM),A 
             JP    AFI_NEXTBLK
             
AFI_EXIT:    POP   BC
             POP   DE
             RET

;******************************************************************
; ASMRTJVAL
; Shift bytes in VAL_BUF right until left padded with '0's  
;******************************************************************
ASMRJTVAL:   PUSH  DE
             PUSH  BC
             LD    IX,VAL_BUF
             LD    B,05h           ; B=MAX search count 5
             
ASMRJT_LOOP: LD    A,(IX+3)        ; Get last byte from VAL_BUF
             CP    ' '             ; Is It SPACE?
             JP    NZ,ASMRJT_EXIT  ; Exit
             LD    A,(IX+2)        ; Shift 3 bytes left 1 positiom
             LD    (IX+3),A
             LD    A,(IX+1) 
             LD    (IX+2),A
             LD    A,(IX+0) 
             LD    (IX+1),A
             LD    A,'0'           ;Pad first position with '0' 
             LD    (IX+0),A
             DEC   B
             JP    NZ,ASMRJT_LOOP
             
ASMRJT_EXIT: POP   BC
             POP   DE
             RET

;******************************************************************
; ASMGETVAL
; HL=src  dest = VAL_BUF  
; Copy bytes from src to dest until a non digit is encountered (4 bytes max.)
; skip over number flags ('$','+,'#')
;******************************************************************
ASMGETVAL:   PUSH  DE
             PUSH  BC
             LD    DE,VAL_BUF
             LD    B,05h           ; B=MAX search count 5
ASMGVL_LOOP: LD    A,(HL)          ; Get a byte from ASM_BUF

             CP    0               ; End of input?
             JP    Z,ASMGVL_EXIT   ; Exit
              
             CALL  ISVALFLAG       ; Test A for '#' '$' or '+'
             JP    Z,ASMGVL_SKIP   ; If match then just skip it
             
             CALL  IS_DIGIT        ; Is A= '0'-'9' or 'A'-'F'?        
             JP    NZ,ASMGVL_EXIT
             LD    (DE),A          ; Save the byte to VAL_BUF
             INC   DE              ; Advance the destination pointer
ASMGVL_SKIP: INC   HL              ; Advance the sourc pointer 
             DEC   B               ; Decrement byte count
             JP    NZ,ASMGVL_LOOP  ; Max reached? NO=Continue
ASMGVL_EXIT: POP   BC
             POP   DE
             RET

;******************************************************************
; ISFLAGORNUM
;  
; RETURN Z=1 if A = '$', '+' ,'#' or '0'-'9' 
;******************************************************************
ISFLAGORNUM: CALL  ISVALFLAG       ; is A ='$','#' or '+'?
             JP    Z,ISNUMF_ZRET   ; YES=return Z=1

             CALL  ISDECDIGIT      ; Test for '0-'9'  
ISNUMF_ZRET: RET                   ;(Z is set accordingly)
 
;******************************************************************
; ISVALFLAG
;  
; RETURN Z=1 if A = '$', '+' ,'#' or '0'-'9' (A is unchanged )
; NOTE: A MUST be a non-zero ASCII Digit
;******************************************************************
ISVALFLAG:   CP    '$'             ; is A ='$'?
             JP    Z,ISVALF_ZRET   ; YES=return Z=1 
             CP    '+'             ; is A ='+'?
             JP    Z,ISVALF_ZRET   ; YES=return Z=1
             CP    '#'             ; is A ='#'?
             JP    Z,ISVALF_ZRET   ; YES=return Z=1
             
             CP    0               ; Otherwise set Z=0                  
ISVALF_ZRET: RET             
;******************************************************************
; PADWSPC
; DE=dest  BC=END 
; starting at current DE fill with spaces until DE=BC
; NOTE: BC MUST BE > DE no bounds checking is done
;******************************************************************
PADWSPC:     LD    A,B
             CP    D
             JP    NZ,DOPADWSPC
             LD    A,C
             CP    E
             JP    M,PADWSP_EXIT               
             JP    NZ,DOPADWSPC
PADWSP_EXIT: RET
DOPADWSPC:   LD    A,' '
             LD    (DE),A
             INC   DE
             JP    PADWSPC             

;******************************************************************
; SKIPSPC
; HL=src  b=MAX 
; advance HL until it is pointing at a non-space byte (16 bytes max.)
;******************************************************************
SKIPSPC:     LD    B,10h     ; B= MAX byte count 16
SKIPSP_LOOP: LD    A,(HL)
             INC   HL
             CP    ' '
             JP    Z,SKIPSP_EXIT
             CP    0
             JP    Z,SKIPSP_EXIT
             DEC   B
             JP    NZ,SKIPSP_LOOP 
SKIPSP_EXIT: RET

;******************************************************************
; CPY2SPC
; HL=src  DE=dest b=count 
; Copy bytes from src to dest until a space is encountered (12 bytes max.)
;******************************************************************
CPY2SPC:     LD    B,0Ch     ; B= MAX byte count 12
CPY2SP_LOOP: LD    A,(HL)
             CP    ' '
             JP    Z,CPY2SP_EXIT  ;Found space so EXIT
             
             CP    0
             JP    NZ,CPY2SP_COPY ;Found NULL before space
             LD    A,' '
             LD    (HL),A         ;Replace with space & exit
             INC   HL
             LD    A,0            ;Terminate
             LD    (HL),A
             DEC   HL
             JP    CPY2SP_EXIT
             
CPY2SP_COPY: LD    (DE),A         ;Copy the byte
             INC   DE             ;Advance destination pointer 
             INC   HL             ;Advance source pointer
             DEC   B              ;Decremet byte count 
             JP    NZ,CPY2SP_LOOP ;If MAX not reached continue...
CPY2SP_EXIT: RET

;******************************************************************
; GETASMBLY
; Get up to 16 bytes of input, stored in ASM_BUF
; backspace allowed, enter exits.     
;******************************************************************   
GETASMBLY:   LD    B,0           ; B= input byte count
             LD    HL,ASM_BUF    ; HL = Destination pointer(ASM_BUF)
             
GASM_NEXTCH: CALL  GETBYTE       ; get 1 Char
             CALL  TOUPPER       ; convert to UPPERCASE
             LD    (RX_BYTE),A   ; Save UPPERCASE in RX_BYTE
             LD    A,(RX_BYTE)   ; Get RX_BYTE
             CP    08h           ; Backspace?
             JP    Z,GASM_DO_BS  ; YES = Process Backspace
             CP    7Fh           ; Putty Backspace(127)?
             JP    NZ,GASM_ISCR  ; NO = Check for CR
                
GASM_DO_BS:  LD    A,B           ; Process Backspace 
             CP    0h            ; is B==0:
             JP    Z,GASM_NEXTCH  ; YES=Just get another byte
             LD    A,08h         ; Back up cursor
             CALL  SENDBYTE      
             LD    A,' '         ; Wipe out last byte
             CALL  SENDBYTE
             LD    A,08h         ; Back up cursor
             CALL  SENDBYTE
             DEC   B             ; Back up byte coune
             DEC   HL            ; Back up HL
             LD    A,' '         ; Set previous byte to space
             LD    (HL),A        ; Save Byte in (HL)
             JP    GASM_NEXTCH   ; Get next byte
             
GASM_ISCR:   CP    0Dh           ; Return char?
             JP    Z,GETASM_EXIT ; YES=Terminate & EXIT
             
             CALL  SENDBYTE      ; echo it     
             LD    (HL),A        ; Save Byte in (HL)
             INC   HL            ; Inc. HL
             INC   B             ; Inc Byte Counter
             LD    A,10h         ; Max Bytes entered?         
             CP    B
             JP    Z, GETASM_EXIT ; Terminate & Exit
             JP    GASM_NEXTCH    ; Otherwise get anoter byte
             
GETASM_EXIT: LD    A,0           ; Terminate Buffer with NULL
             LD    (HL),A
             RET             
;******************************************************************
; Z80 Assembler lookup table  
; FORMAT: 10 bytes per row
; Instruction Blocks: start with # followed by 4 char instruction
;   byte 5 = #of rows for this instruction
; Parameter Blocks: A 7 byte parameter pattern
;                Opcode byte 1, Opcode byte 2(if any otherwise zero)
;                Number of byte used for opcodes & data parameters.
;******************************************************************
OPCD_TABLE: .BYTE "#ADC ",$0F,0,0,0,0
            .BYTE "A,(HL) ",$8E,$00,1
            .BYTE "A,(IX*)",$8E,$DD,3
            .BYTE "A,(IY*)",$8E,$FD,3
            .BYTE "A,A    ",$8F,$00,1
            .BYTE "A,B    ",$88,$00,1
            .BYTE "A,C    ",$89,$00,1
            .BYTE "A,D    ",$8A,$00,1
            .BYTE "A,E    ",$8B,$00,1
            .BYTE "A,H    ",$8C,$00,1
            .BYTE "A,L    ",$8D,$00,1
            .BYTE "A,*    ",$CE,$00,2
            .BYTE "HL,BC  ",$4A,$ED,2
            .BYTE "HL,DE  ",$5A,$ED,2
            .BYTE "HL,HL  ",$6A,$ED,2
            .BYTE "HL,SP  ",$7A,$ED,2
            .BYTE "#ADD ",$17,0,0,0,0
            .BYTE "A,(HL) ",$86,$00,1
            .BYTE "A,(IX*)",$86,$DD,3
            .BYTE "A,(IY*)",$86,$FD,3
            .BYTE "A,A    ",$87,$00,1
            .BYTE "A,B    ",$80,$00,1
            .BYTE "A,C    ",$81,$00,1
            .BYTE "A,D    ",$82,$00,1
            .BYTE "A,E    ",$83,$00,1
            .BYTE "A,H    ",$84,$00,1
            .BYTE "A,L    ",$85,$00,1
            .BYTE "A,*    ",$C6,$00,2
            .BYTE "HL,BC  ",$09,$00,1
            .BYTE "HL,DE  ",$19,$00,1
            .BYTE "HL,HL  ",$29,$00,1
            .BYTE "HL,SP  ",$39,$00,1
            .BYTE "IX,BC  ",$09,$DD,2
            .BYTE "IX,DE  ",$19,$DD,2
            .BYTE "IX,IX  ",$29,$DD,2
            .BYTE "IX,SP  ",$39,$DD,2
            .BYTE "IY,BC  ",$09,$FD,2
            .BYTE "IY,DE  ",$19,$FD,2
            .BYTE "IY,IY  ",$29,$FD,2
            .BYTE "IY,SP  ",$39,$FD,2
            .BYTE "#AND ",$0B,0,0,0,0
            .BYTE "(HL)   ",$A6,$00,1
            .BYTE "(IX*)  ",$A6,$DD,3
            .BYTE "(IY*)  ",$A6,$FD,3
            .BYTE "A      ",$A7,$00,1
            .BYTE "B      ",$A0,$00,1
            .BYTE "C      ",$A1,$00,1
            .BYTE "D      ",$A2,$00,1
            .BYTE "E      ",$A3,$00,1
            .BYTE "H      ",$A4,$00,1
            .BYTE "L      ",$A5,$00,1
            .BYTE "*      ",$E6,$00,2
            .BYTE "#BIT ",$08,0,0,0,0
            .BYTE "*,(HL) ",$46,$CB,2
            .BYTE "*,A    ",$47,$CB,2
            .BYTE "*,B    ",$40,$CB,2
            .BYTE "*,C    ",$41,$CB,2
            .BYTE "*,D    ",$42,$CB,2
            .BYTE "*,E    ",$43,$CB,2
            .BYTE "*,H    ",$44,$CB,2
            .BYTE "*,L    ",$45,$CB,2
            .BYTE "#CALL",$09,0,0,0,0
            .BYTE "C,*    ",$DC,$00,3
            .BYTE "M,*    ",$FC,$00,3
            .BYTE "NC,*   ",$D4,$00,3
            .BYTE "NZ,*   ",$C4,$00,3
            .BYTE "P,*    ",$F4,$00,3
            .BYTE "PE,*   ",$EC,$00,3
            .BYTE "PO,*   ",$E4,$00,3
            .BYTE "Z,*    ",$CC,$00,3
            .BYTE "*      ",$CD,$00,3
            .BYTE "#CCF ",$01,0,0,0,0
            .BYTE "       ",$3F,$00,1
            .BYTE "#CP  ",$0B,0,0,0,0
            .BYTE "(HL)   ",$BE,$00,1
            .BYTE "(IX*)  ",$BE,$DD,3
            .BYTE "(IY*)  ",$BE,$FD,3
            .BYTE "A      ",$BF,$00,1
            .BYTE "B      ",$B8,$00,1
            .BYTE "C      ",$B9,$00,1
            .BYTE "D      ",$BA,$00,1
            .BYTE "E      ",$BB,$00,1
            .BYTE "H      ",$BC,$00,1
            .BYTE "L      ",$BD,$00,1
            .BYTE "*      ",$FE,$00,2
            .BYTE "#CPD ",$01,0,0,0,0
            .BYTE "       ",$A9,$ED,2
            .BYTE "#CPDR",$01,0,0,0,0
            .BYTE "       ",$B9,$ED,2
            .BYTE "#CPIR",$01,0,0,0,0
            .BYTE "       ",$B1,$ED,2
            .BYTE "#CPI ",$01,0,0,0,0
            .BYTE "       ",$A1,$ED,2
            .BYTE "#CPL ",$01,0,0,0,0
            .BYTE "       ",$2F,$00,1
            .BYTE "#DAA ",$01,0,0,0,0
            .BYTE "       ",$27,$00,1
            .BYTE "#DEC ",$10,0,0,0,0
            .BYTE "(HL)   ",$35,$00,1
            .BYTE "(IX*)  ",$35,$DD,3
            .BYTE "(IY*)  ",$35,$FD,3
            .BYTE "A      ",$3D,$00,1
            .BYTE "B      ",$05,$00,1
            .BYTE "BC     ",$0B,$00,1
            .BYTE "C      ",$0D,$00,1
            .BYTE "D      ",$15,$00,1
            .BYTE "DE     ",$1B,$00,1
            .BYTE "E      ",$1D,$00,1
            .BYTE "H      ",$25,$00,1
            .BYTE "HL     ",$2B,$00,1
            .BYTE "IX     ",$2B,$DD,2
            .BYTE "IY     ",$2B,$FD,2
            .BYTE "L      ",$2D,$00,1
            .BYTE "SP     ",$3B,$00,1
            .BYTE "#DI  ",$01,0,0,0,0
            .BYTE "       ",$F3,$00,1
            .BYTE "#DJNZ",$01,0,0,0,0
            .BYTE "*      ",$10,$00,2
            .BYTE "#EI  ",$01,0,0,0,0
            .BYTE "       ",$FB,$00,1
            .BYTE "#EX  ",$05,0,0,0,0
            .BYTE "(SP),HL",$E3,$00,1
            .BYTE "(SP),IX",$E3,$DD,2
            .BYTE "(SP),IY",$E3,$FD,2
            .BYTE "AF,AF",$2C,$20,$08,$00,1
            .BYTE "DE,HL  ",$EB,$00,1
            .BYTE "#EXX ",$01,0,0,0,0
            .BYTE "       ",$D9,$00,1
            .BYTE "#HALT",$01,0,0,0,0
            .BYTE "       ",$76,$00,1
            .BYTE "#IM  ",$03,0,0,0,0
            .BYTE "0      ",$46,$ED,2
            .BYTE "1      ",$56,$ED,2
            .BYTE "2      ",$5E,$ED,2
            .BYTE "#IN  ",$08,0,0,0,0
            .BYTE "A,(C)  ",$78,$ED,2
            .BYTE "B,(C)  ",$40,$ED,2
            .BYTE "C,(C)  ",$48,$ED,2
            .BYTE "D,(C)  ",$50,$ED,2
            .BYTE "E,(C)  ",$58,$ED,2
            .BYTE "H,(C)  ",$60,$ED,2
            .BYTE "L,(C)  ",$68,$ED,2
            .BYTE "A,(*)  ",$DB,$00,2
            .BYTE "#IN0 ",$07,0,0,0,0
            .BYTE " A,(*) ",$38,$ED,3
            .BYTE " B,(*) ",$00,$ED,3
            .BYTE " C,(*) ",$08,$ED,3
            .BYTE " D,(*) ",$10,$ED,3
            .BYTE " E,(*) ",$18,$ED,3
            .BYTE " H,(*) ",$20,$ED,3
            .BYTE " L,(*) ",$28,$ED,3
            .BYTE "#INC ",$10,0,0,0,0
            .BYTE "(HL)   ",$34,$00,1
            .BYTE "(IX*)  ",$34,$DD,3
            .BYTE "(IY*)  ",$34,$FD,3
            .BYTE "A      ",$3C,$00,1
            .BYTE "B      ",$04,$00,1
            .BYTE "BC     ",$03,$00,1
            .BYTE "C      ",$0C,$00,1
            .BYTE "D      ",$14,$00,1
            .BYTE "DE     ",$13,$00,1
            .BYTE "E      ",$1C,$00,1
            .BYTE "H      ",$24,$00,1
            .BYTE "HL     ",$23,$00,1
            .BYTE "IX     ",$23,$DD,2
            .BYTE "IY     ",$23,$FD,2
            .BYTE "L      ",$2C,$00,1
            .BYTE "SP     ",$33,$00,1
            .BYTE "#IND ",$01,0,0,0,0
            .BYTE "       ",$AA,$ED,2
            .BYTE "#INDR",$01,0,0,0,0
            .BYTE "       ",$BA,$ED,2
            .BYTE "#INI ",$01,0,0,0,0
            .BYTE "       ",$A2,$ED,2
            .BYTE "#INIR",$01,0,0,0,0
            .BYTE "       ",$B2,$ED,2
            .BYTE "#JP  ",$0C,0,0,0,0
            .BYTE "(HL)   ",$E9,$00,1
            .BYTE "(IX)   ",$E9,$DD,2
            .BYTE "(IY)   ",$E9,$FD,2
            .BYTE "C,*    ",$DA,$00,3
            .BYTE "M,*    ",$FA,$00,3
            .BYTE "NC,*   ",$D2,$00,3
            .BYTE "NZ,*   ",$C2,$00,3
            .BYTE "P,*    ",$F2,$00,3
            .BYTE "PE,*   ",$EA,$00,3
            .BYTE "PO,*   ",$E2,$00,3
            .BYTE "Z,*    ",$CA,$00,3
            .BYTE "*      ",$C3,$00,3
            .BYTE "#JR  ",$05,0,0,0,0
            .BYTE "C,*    ",$38,$00,2
            .BYTE "NC,*   ",$30,$00,2
            .BYTE "NZ,*   ",$20,$00,2
            .BYTE "Z,*    ",$28,$00,2
            .BYTE "*      ",$18,$00,2
            .BYTE "#LD  ",$84,0,0,0,0
            .BYTE "(BC),A ",$02,$00,1
            .BYTE "(DE),A ",$12,$00,1
            .BYTE "(HL),A ",$77,$00,1
            .BYTE "(HL),B ",$70,$00,1
            .BYTE "(HL),C ",$71,$00,1
            .BYTE "(HL),D ",$72,$00,1
            .BYTE "(HL),E ",$73,$00,1
            .BYTE "(HL),H ",$74,$00,1
            .BYTE "(HL),L ",$75,$00,1
            .BYTE "(HL),* ",$36,$00,2
            .BYTE "(IX*),A",$77,$DD,3
            .BYTE "(IX*),B",$70,$DD,3
            .BYTE "(IX*),C",$71,$DD,3
            .BYTE "(IX*),D",$72,$DD,3
            .BYTE "(IX*),E",$73,$DD,3
            .BYTE "(IX*),H",$74,$DD,3
            .BYTE "(IX*),L",$75,$DD,3
            .BYTE "(IX*),*",$36,$DD,4
            .BYTE "(IY*),A",$77,$FD,3
            .BYTE "(IY*),B",$70,$FD,3
            .BYTE "(IY*),C",$71,$FD,3
            .BYTE "(IY*),D",$72,$FD,3
            .BYTE "(IY*),E",$73,$FD,3
            .BYTE "(IY*),H",$74,$FD,3
            .BYTE "(IY*),L",$75,$FD,3
            .BYTE "(IY*),*",$36,$FD,4
            .BYTE "(*),A  ",$32,$00,3
            .BYTE "(*),BC ",$43,$ED,4
            .BYTE "(*),DE ",$53,$ED,4
            .BYTE "(*),HL ",$22,$00,3
            .BYTE "(*),IX ",$22,$DD,4
            .BYTE "(*),IY ",$22,$FD,4
            .BYTE "(*),SP ",$73,$ED,4
            .BYTE "A,(BC) ",$0A,$00,1
            .BYTE "A,(DE) ",$1A,$00,1
            .BYTE "A,(HL) ",$7E,$00,1
            .BYTE "A,(IX*)",$7E,$DD,3
            .BYTE "A,(IY*)",$7E,$FD,3
            .BYTE "A,A    ",$7F,$00,1
            .BYTE "A,B    ",$78,$00,1
            .BYTE "A,C    ",$79,$00,1
            .BYTE "A,D    ",$7A,$00,1
            .BYTE "A,E    ",$7B,$00,1
            .BYTE "A,H    ",$7C,$00,1
            .BYTE "A,I    ",$57,$ED,2
            .BYTE "A,L    ",$7D,$00,1
            .BYTE "A,R    ",$5F,$ED,2
            .BYTE "A,(*)  ",$3A,$00,3
            .BYTE "A,*    ",$3E,$00,2
            .BYTE "B,(HL) ",$46,$00,1
            .BYTE "B,(IX*)",$46,$DD,3
            .BYTE "B,(IY*)",$46,$FD,3
            .BYTE "B,A    ",$47,$00,1
            .BYTE "B,B    ",$40,$00,1
            .BYTE "B,C    ",$41,$00,1
            .BYTE "B,D    ",$42,$00,1
            .BYTE "B,E    ",$43,$00,1
            .BYTE "B,H    ",$44,$00,1
            .BYTE "B,L    ",$45,$00,1
            .BYTE "B,*    ",$06,$00,2
            .BYTE "BC,(*) ",$4B,$ED,4
            .BYTE "BC,*   ",$01,$00,3
            .BYTE "C,(HL) ",$4E,$00,1
            .BYTE "C,(IX*)",$4E,$DD,3
            .BYTE "C,(IY*)",$4E,$FD,3
            .BYTE "C,A    ",$4F,$00,1
            .BYTE "C,B    ",$48,$00,1
            .BYTE "C,C    ",$49,$00,1
            .BYTE "C,D    ",$4A,$00,1
            .BYTE "C,E    ",$4B,$00,1
            .BYTE "C,H    ",$4C,$00,1
            .BYTE "C,L    ",$4D,$00,1
            .BYTE "C,*    ",$0E,$00,2
            .BYTE "D,(HL) ",$56,$00,1
            .BYTE "D,(IX*)",$56,$DD,3
            .BYTE "D,(IY*)",$56,$FD,3
            .BYTE "D,A    ",$57,$00,1
            .BYTE "D,B    ",$50,$00,1
            .BYTE "D,C    ",$51,$00,1
            .BYTE "D,D    ",$52,$00,1
            .BYTE "D,E    ",$53,$00,1
            .BYTE "D,H    ",$54,$00,1
            .BYTE "D,L    ",$55,$00,1
            .BYTE "D,*    ",$16,$00,2
            .BYTE "DE,(*) ",$5B,$ED,4
            .BYTE "DE,*   ",$11,$00,3
            .BYTE "E,(HL) ",$5E,$00,1
            .BYTE "E,(IX*)",$5E,$DD,3
            .BYTE "E,(IY*)",$5E,$FD,3
            .BYTE "E,A    ",$5F,$00,1
            .BYTE "E,B    ",$58,$00,1
            .BYTE "E,C    ",$59,$00,1
            .BYTE "E,D    ",$5A,$00,1
            .BYTE "E,E    ",$5B,$00,1
            .BYTE "E,H    ",$5C,$00,1
            .BYTE "E,L    ",$5D,$00,1
            .BYTE "E,*    ",$1E,$00,2
            .BYTE "H,(HL) ",$66,$00,1
            .BYTE "H,(IX*)",$66,$DD,3
            .BYTE "H,(IY*)",$66,$FD,3
            .BYTE "H,A    ",$67,$00,1
            .BYTE "H,B    ",$60,$00,1
            .BYTE "H,C    ",$61,$00,1
            .BYTE "H,D    ",$62,$00,1
            .BYTE "H,E    ",$63,$00,1
            .BYTE "H,H    ",$64,$00,1
            .BYTE "H,L    ",$65,$00,1
            .BYTE "H,*    ",$26,$00,2
            .BYTE "HL,(*) ",$2A,$00,3
            .BYTE "HL,*   ",$21,$00,3
            .BYTE "I,A    ",$47,$ED,2
            .BYTE "IX,(*) ",$2A,$DD,4
            .BYTE "IX,*   ",$21,$DD,4
            .BYTE "IY,(*) ",$2A,$FD,4
            .BYTE "IY,*   ",$21,$FD,4
            .BYTE "L,(HL) ",$6E,$00,1
            .BYTE "L,(IX*)",$6E,$DD,3
            .BYTE "L,(IY*)",$6E,$FD,3
            .BYTE "L,A    ",$6F,$00,1
            .BYTE "L,B    ",$68,$00,1
            .BYTE "L,C    ",$69,$00,1
            .BYTE "L,D    ",$6A,$00,1
            .BYTE "L,E    ",$6B,$00,1
            .BYTE "L,H    ",$6C,$00,1
            .BYTE "L,L    ",$6D,$00,1
            .BYTE "L,*    ",$2E,$00,2
            .BYTE "R,A    ",$4F,$ED,2
            .BYTE "SP,(*) ",$7B,$ED,4
            .BYTE "SP,HL  ",$F9,$00,1
            .BYTE "SP,IX  ",$F9,$DD,2
            .BYTE "SP,IY  ",$F9,$FD,2
            .BYTE "SP,*   ",$31,$00,3
            .BYTE "#LDD ",$01,0,0,0,0
            .BYTE "       ",$A8,$ED,2
            .BYTE "#LDDR",$01,0,0,0,0
            .BYTE "       ",$B8,$ED,2
            .BYTE "#LDI ",$01,0,0,0,0
            .BYTE "       ",$A0,$ED,2
            .BYTE "#LDIR",$01,0,0,0,0
            .BYTE "       ",$B0,$ED,2
            .BYTE "#NEG ",$01,0,0,0,0
            .BYTE "       ",$44,$ED,2
            .BYTE "#NOP ",$01,0,0,0,0
            .BYTE "       ",$00,$00,1
            .BYTE "#OR  ",$0B,0,0,0,0
            .BYTE "(HL)   ",$B6,$00,1
            .BYTE "(IX*)  ",$B6,$DD,3
            .BYTE "(IY*)  ",$B6,$FD,3
            .BYTE "A      ",$B7,$00,1
            .BYTE "B      ",$B0,$00,1
            .BYTE "C      ",$B1,$00,1
            .BYTE "D      ",$B2,$00,1
            .BYTE "E      ",$B3,$00,1
            .BYTE "H      ",$B4,$00,1
            .BYTE "L      ",$B5,$00,1
            .BYTE "*      ",$F6,$00,2
            .BYTE "#OTDR",$01,0,0,0,0
            .BYTE "       ",$BB,$ED,2
            .BYTE "#OTIR",$01,0,0,0,0
            .BYTE "       ",$B3,$ED,2
            .BYTE "#OUT ",$08,0,0,0,0
            .BYTE "(C),A  ",$79,$ED,2
            .BYTE "(C),B  ",$41,$ED,2
            .BYTE "(C),C  ",$49,$ED,2
            .BYTE "(C),D  ",$51,$ED,2
            .BYTE "(C),E  ",$59,$ED,2
            .BYTE "(C),H  ",$61,$ED,2
            .BYTE "(C),L  ",$69,$ED,2
            .BYTE "(*),A  ",$D3,$00,2
            .BYTE "#OUT0",$07,0,0,0,0
            .BYTE "(*),A  ",$39,$ED,3
            .BYTE "(*),B  ",$01,$ED,3
            .BYTE "(*),C  ",$09,$ED,3
            .BYTE "(*),D  ",$11,$ED,3
            .BYTE "(*),E  ",$19,$ED,3
            .BYTE "(*),H  ",$21,$ED,3
            .BYTE "(*),L  ",$29,$ED,3
            .BYTE "#OUTD",$01,0,0,0,0
            .BYTE "       ",$AB,$ED,2
            .BYTE "#OUTI",$01,0,0,0,0
            .BYTE "       ",$A3,$ED,2
            .BYTE "#POP ",$06,0,0,0,0
            .BYTE "AF     ",$F1,$00,1
            .BYTE "BC     ",$C1,$00,1
            .BYTE "DE     ",$D1,$00,1
            .BYTE "HL     ",$E1,$00,1
            .BYTE "IX     ",$E1,$DD,2
            .BYTE "IY     ",$E1,$FD,2
            .BYTE "#PUSH",$06,0,0,0,0
            .BYTE "AF     ",$F5,$00,1
            .BYTE "BC     ",$C5,$00,1
            .BYTE "DE     ",$D5,$00,1
            .BYTE "HL     ",$E5,$00,1
            .BYTE "IX     ",$E5,$DD,2
            .BYTE "IY     ",$E5,$FD,2
            .BYTE "#RES ",$08,0,0,0,0
            .BYTE "*,(HL) ",$86,$CB,2
            .BYTE "*,A    ",$87,$CB,2
            .BYTE "*,B    ",$80,$CB,2
            .BYTE "*,C    ",$81,$CB,2
            .BYTE "*,D    ",$82,$CB,2
            .BYTE "*,E    ",$83,$CB,2
            .BYTE "*,H    ",$84,$CB,2
            .BYTE "*,L    ",$85,$CB,2
            .BYTE "#RET ",$09,0,0,0,0
            .BYTE "       ",$C9,$00,1
            .BYTE "C      ",$D8,$00,1
            .BYTE "M      ",$F8,$00,1
            .BYTE "NC     ",$D0,$00,1
            .BYTE "NZ     ",$C0,$00,1
            .BYTE "P      ",$F0,$00,1
            .BYTE "PE     ",$E8,$00,1
            .BYTE "PO     ",$E0,$00,1
            .BYTE "Z      ",$C8,$00,1
            .BYTE "#RETI",$01,0,0,0,0
            .BYTE "       ",$4D,$ED,2
            .BYTE "#RETN",$01,0,0,0,0
            .BYTE "       ",$45,$ED,2
            .BYTE "#RL  ",$08,0,0,0,0
            .BYTE "(HL)   ",$16,$CB,2
            .BYTE "A      ",$17,$CB,2
            .BYTE "B      ",$10,$CB,2
            .BYTE "C      ",$11,$CB,2
            .BYTE "D      ",$12,$CB,2
            .BYTE "E      ",$13,$CB,2
            .BYTE "H      ",$14,$CB,2
            .BYTE "L      ",$15,$CB,2
            .BYTE "#RLA ",$01,0,0,0,0
            .BYTE "       ",$17,$00,1
            .BYTE "#RLC ",$08,0,0,0,0
            .BYTE "(HL)   ",$06,$CB,2
            .BYTE "A      ",$07,$CB,2
            .BYTE "B      ",$00,$CB,2
            .BYTE "C      ",$01,$CB,2
            .BYTE "D      ",$02,$CB,2
            .BYTE "E      ",$03,$CB,2
            .BYTE "H      ",$04,$CB,2
            .BYTE "L      ",$05,$CB,2
            .BYTE "#RLCA",$01,0,0,0,0
            .BYTE "       ",$07,$00,1
            .BYTE "#RLD ",$01,0,0,0,0
            .BYTE "       ",$6F,$ED,2
            .BYTE "#RR  ",$08,0,0,0,0
            .BYTE "(HL)   ",$1E,$CB,2
            .BYTE "A      ",$1F,$CB,2
            .BYTE "B      ",$18,$CB,2
            .BYTE "C      ",$19,$CB,2
            .BYTE "D      ",$1A,$CB,2
            .BYTE "E      ",$1B,$CB,2
            .BYTE "H      ",$1C,$CB,2
            .BYTE "L      ",$1D,$CB,2
            .BYTE "#RRA ",$01,0,0,0,0
            .BYTE "       ",$1F,$00,1
            .BYTE "#RRC ",$08,0,0,0,0
            .BYTE "(HL)   ",$0E,$CB,2
            .BYTE "A      ",$0F,$CB,2
            .BYTE "B      ",$08,$CB,2
            .BYTE "C      ",$09,$CB,2
            .BYTE "D      ",$0A,$CB,2
            .BYTE "E      ",$0B,$CB,2
            .BYTE "H      ",$0C,$CB,2
            .BYTE "L      ",$0D,$CB,2
            .BYTE "#RRCA",$01,0,0,0,0
            .BYTE "       ",$0F,$00,1
            .BYTE "#RRD ",$01,0,0,0,0
            .BYTE "       ",$67,$ED,2
            .BYTE "#RST ",$08,0,0,0,0
            .BYTE "00H    ",$C7,$00,1
            .BYTE "08H    ",$CF,$00,1
            .BYTE "10H    ",$D7,$00,1
            .BYTE "18H    ",$DF,$00,1
            .BYTE "20H    ",$E7,$00,1
            .BYTE "28H    ",$EF,$00,1
            .BYTE "30H    ",$F7,$00,1
            .BYTE "38H    ",$FF,$00,1
            .BYTE "#SBC ",$0F,0,0,0,0
            .BYTE "A,(HL) ",$9E,$00,1
            .BYTE "A,(IX*)",$9E,$DD,3
            .BYTE "A,(IY*)",$9E,$FD,3
            .BYTE "A,A    ",$9F,$00,1
            .BYTE "A,B    ",$98,$00,1
            .BYTE "A,C    ",$99,$00,1
            .BYTE "A,D    ",$9A,$00,1
            .BYTE "A,E    ",$9B,$00,1
            .BYTE "A,H    ",$9C,$00,1
            .BYTE "A,L    ",$9D,$00,1
            .BYTE "HL,BC  ",$42,$ED,2
            .BYTE "HL,DE  ",$52,$ED,2
            .BYTE "HL,HL  ",$62,$ED,2
            .BYTE "HL,SP  ",$72,$ED,2
            .BYTE "A,*    ",$DE,$00,2
            .BYTE "#SCF ",$01,0,0,0,0
            .BYTE "       ",$37,$00,1
            .BYTE "#SET ",$08,0,0,0,0
            .BYTE "*,(HL) ",$C6,$CB,2
            .BYTE "*,A    ",$C7,$CB,2
            .BYTE "*,B    ",$C0,$CB,2
            .BYTE "*,C    ",$C1,$CB,2
            .BYTE "*,D    ",$C2,$CB,2
            .BYTE "*,E    ",$C3,$CB,2
            .BYTE "*,H    ",$C4,$CB,2
            .BYTE "*,L    ",$C5,$CB,2
            .BYTE "#SLA ",$08,0,0,0,0
            .BYTE "(HL)   ",$26,$CB,2
            .BYTE "A      ",$27,$CB,2
            .BYTE "B      ",$20,$CB,2
            .BYTE "C      ",$21,$CB,2
            .BYTE "D      ",$22,$CB,2
            .BYTE "E      ",$23,$CB,2
            .BYTE "H      ",$24,$CB,2
            .BYTE "L      ",$25,$CB,2
            .BYTE "#SRA ",$08,0,0,0,0
            .BYTE "(HL)   ",$2E,$CB,2
            .BYTE "A      ",$2F,$CB,2
            .BYTE "B      ",$28,$CB,2
            .BYTE "C      ",$29,$CB,2
            .BYTE "D      ",$2A,$CB,2
            .BYTE "E      ",$2B,$CB,2
            .BYTE "H      ",$2C,$CB,2
            .BYTE "L      ",$2D,$CB,2
            .BYTE "#SRL ",$08,0,0,0,0
            .BYTE "(HL)   ",$3E,$CB,2
            .BYTE "A      ",$3F,$CB,2
            .BYTE "B      ",$38,$CB,2
            .BYTE "C      ",$39,$CB,2
            .BYTE "D      ",$3A,$CB,2
            .BYTE "E      ",$3B,$CB,2
            .BYTE "H      ",$3C,$CB,2
            .BYTE "L      ",$3D,$CB,2
            .BYTE "#SUB ",$0B,0,0,0,0
            .BYTE "(HL)   ",$96,$00,1
            .BYTE "(IX*)  ",$96,$DD,3
            .BYTE "(IY*)  ",$96,$FD,3
            .BYTE "A      ",$97,$00,1
            .BYTE "B      ",$90,$00,1
            .BYTE "C      ",$91,$00,1
            .BYTE "D      ",$92,$00,1
            .BYTE "E      ",$93,$00,1
            .BYTE "H      ",$94,$00,1
            .BYTE "L      ",$95,$00,1
            .BYTE "*      ",$D6,$00,2
            .BYTE "#XOR ",$0B,0,0,0,0
            .BYTE "(HL)   ",$AE,$00,1
            .BYTE "(IX*)  ",$AE,$DD,3
            .BYTE "(IY*)  ",$AE,$FD,3
            .BYTE "A      ",$AF,$00,1
            .BYTE "B      ",$A8,$00,1
            .BYTE "C      ",$A9,$00,1
            .BYTE "D      ",$AA,$00,1
            .BYTE "E      ",$AB,$00,1
            .BYTE "H      ",$AC,$00,1
            .BYTE "L      ",$AD,$00,1
            .BYTE "*      ",$EE,$00,2
            .BYTE "#END ",$00,0,0,0,0            
;******************************************************************
; END of Z80 Assembler lookup table  
;******************************************************************

;******************************************************************
; NASCOM ROM BASIC Ver 4.7, (C) 1978 Microsoft
; Scanned from source published in 80-BUS NEWS from Vol 2, Issue 3
; (May-June 1983) to Vol 3, Issue 3 (May-June 1984)
;******************************************************************
    .include Z80BASIC.ASM     
;******************************************************************                             
 .text "\n\r  -END-OF-FILE-  \n\r"
 .end
