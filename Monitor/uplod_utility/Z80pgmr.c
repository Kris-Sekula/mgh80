//  
// Z80pgmr.c   Command line utility to upload an Inter HEX file to the Z80 Board
//             By Eric M. Klaus   10/22/2013
//
// Modified by Kris Sekula to adopt to MGH80 SBC ... see mygeekyhobby.com
//

#include <windows.h>
#include <stdio.h>
#include <time.h>

#define COM_READ_MAX 5000
#define COM_FLUSH_MAX 25
#define RETRY_MAX 3
#define BAUD_RATE 9600

// declare two local functions here...
char WaitForComByte(HANDLE hCom, int timeout);
void SetComTimeout(HANDLE hCom);
HANDLE OpenCom(char *port, DWORD baud, int *pErrNo);

char AsciiToHexVal(char b);
unsigned char HexStrToByte(char *buf);

//declare GLOBAL variables here...

//char sPortName1[] = "COM1";      // Serial Port Name (when port is < COM10)
char sPortName1[] = "//./COM10";   // Serial Port Name (when port is > COM9)
DWORD dwBaud1 = BAUD_RATE;         // Baud Rate

DWORD lCtBytes;                      // Holds the number of bytes sent/received

char tempBuf[10] = {0,0,0,0,0,0,0,0,0,0};   // Temp Buffer
char dataBuf[100];                   // Another data buffer(100 bytes)
char inByte;                         // Holds our input byte
int err_no;                          // Holds our error code (if any)
int dataBufIndex;                    // points to where we store the data in dataBuf.
FILE *fp;
char srcFileName[80];


static HANDLE hCom1;                 // Com Port Handle

int main(int argc, char *argv[ ])
{
 int i, recLen, recType;;
 char *cp;

 printf("\nMGH80 HEX Loader v1.0\n");
 if(argc <2)
   {
     printf("\n ERROR! Too Few Arguments\n Usage: mgh80load.exe {filename} {port_#} {execute_after_loading Y/N}\n\n Example: mgh80load.exe blink.hex 1 Y\n");
	 printf("\n\n Your programs should be compiled to start at 0x8100 - location, in most compilers you can use 'ORG 8100H' at the start of your Z80 code");
	 printf("\n\n");
     return 1;
   }

 // Build COM port name if supplied
 if(argc >1)
   {
    i = atoi(argv[2]);
    if(i<10)
      sprintf(sPortName1, "COM%d", i);
    else
      sprintf(sPortName1, "//./COM%d", i);
   }

 // Open source file
 fp=fopen(argv[1], "r");  //open a file for reading
 if(!fp)                  //Always check for success.
   {
    printf("ERROR: Cannot Open File '%s'\n", argv[1]);
    return -1;
   }

 strcpy(srcFileName, argv[1]);
 printf("FILE: '%s'\n", srcFileName);

 // Attempt to open the specified serial port
 hCom1 = OpenCom(sPortName1, dwBaud1, &err_no);

 if(hCom1 == INVALID_HANDLE_VALUE)
   {
    // If we FAILED ... print a message and end the program
    printf ("Failed to open serial port with error %d.\n",err_no);
    fclose(fp);
    return 2;
   }
 else
   printf ("Com port %s open at %d baud.\n", sPortName1, (int)dwBaud1);


 // Send the attention byte '@' to the programmer
 WriteFile(hCom1, "@", 1, (LPDWORD)&lCtBytes, NULL);

 Sleep(250);  //Wait 1/4 sec.

 // Wait for the proper response '$$$'
 i=0;
 memset(dataBuf, 0, 80);
 while(i < 80)
      {
       inByte = WaitForComByte(hCom1, COM_READ_MAX);
       if(inByte)
         {
          dataBuf[i++]=inByte;
          if(strstr(dataBuf, "$$$"))  // Got Full Response?
              break;                  // Exit the while loop
         }
       else
         {
          printf("\n ERROR! No Response from target, hit reset on your MGH80 board");
          fclose(fp);
          CloseHandle(hCom1);
          return 3;
         }
      }

 printf("\n Target Ready\n");

 while(WaitForComByte(hCom1, COM_FLUSH_MAX));   // flush any unused input characters (trailing LF & CR)

 // Read records from source file
 while(!feof(fp)) //While NOT at End-Of-File
     {
      cp = fgets(dataBuf, 80, fp);  //Read 1 line from the file
      if(cp)                        //Make sure we got something
        {
         strncpy(tempBuf, &dataBuf[1], 2);
         tempBuf[2]=0;
         recLen = (int)HexStrToByte(tempBuf);

         strncpy(tempBuf, &dataBuf[7], 2);
         tempBuf[2]=0;
         recType = atoi(tempBuf);

         if((recLen==0)&&(recType!=0))
           break;

         // Send the iHex record start byte ':' to the programmer
         WriteFile(hCom1, ":", 1, (LPDWORD)&lCtBytes, NULL);
         Sleep(COM_FLUSH_MAX);  //Wait 5ms.
         dataBuf[(recLen*2)+11]=0;  //Trim trailing LF/CR from data
         printf("Len:%d Type:%d %s", recLen, recType, dataBuf);     //Print it.

         // Send data string to target
         WriteFile(hCom1, (LPSTR)&dataBuf[1], strlen((char *)&dataBuf[1]), (LPDWORD)&lCtBytes, NULL);

         // Wait for response "*" or "?"
         i=0;
         memset(tempBuf, 0, 8);
         err_no=0;
         while(i < 8)
              {
               inByte = WaitForComByte(hCom1, COM_READ_MAX);
               if(inByte)
                 {
                  tempBuf[i++]=inByte;
                  cp=strstr(tempBuf, "*");
                  if(cp)                        // Got OK Response?
                     break;                     // Exit the while loop

                  cp=strstr(tempBuf, "?");
                  if(cp)  // Got ERROR Response?
                  {
                    err_no=1;
                    break;                      // Exit the while loop
                  }

                  cp=strstr(tempBuf, "E");
                  if(cp)  // Got ERROR Response?
                  {
                    err_no=2;
                    break;                      // Exit the while loop
                  }

                 }
               else
                 {
                  printf("\n ERROR! No Response from target");
                  fclose(fp);
                  CloseHandle(hCom1);
                  return 4;
                 }
              }

           printf("%s\n", cp);

           while(WaitForComByte(hCom1, COM_FLUSH_MAX));   // flush any unused input characters (trailing LF & CR)

           if(err_no)
             Sleep(1000);  //Wait 1 sec.
           else
             Sleep(COM_FLUSH_MAX);  //Wait 5ms.
        }

      }

if (argc > 3) {
	if (strcmp(argv[3], "Y") == 0) {
		// Start program before exiting
		printf("\n Will start your program from 0x8100\n");
		WriteFile(hCom1, "g", 1, (LPDWORD)&lCtBytes, NULL);
	} else if (strcmp(argv[3], "N") == 0) {
		// Send the reset command '!' to the target
		WriteFile(hCom1, "!", 1, (LPDWORD)&lCtBytes, NULL);
	}
}
 
 fclose(fp);          // Close the source file.
 Sleep(COM_FLUSH_MAX);  //Wait 25ms.
 CloseHandle(hCom1);    // Close the COM port
 printf("\n Done...\n");

 return 0;
}

// ***********************************************************************
// WaitForComByte(hCom, timeout)
// Wait for a byte from the open COM port for COM_READ_MAX ms
// RETURN: character recieved or zero if timeout.
// ***********************************************************************
char WaitForComByte(HANDLE hCom, int timeout)
{
  DWORD dwCtBytes;
  clock_t finish;
  char b;

  finish = clock() + (timeout * (CLOCKS_PER_SEC/1000));
  while(clock() < finish)
       {
        ReadFile(hCom, (LPSTR)&b, 1, (LPDWORD)&dwCtBytes, NULL);  //Get Zero or 1 byte
        if(dwCtBytes > 0)
           break;
       }

  if(dwCtBytes == 0)
    b=0;

  return b;
}



// ***********************************************************************
// SetComTimeout(HANDLE hCom)
// Set the COM port timeout values - used by OpenCom()  (see below)
// ***********************************************************************
void SetComTimeout(HANDLE hCom)
{
 COMMTIMEOUTS ctmo;                  // See COMMTIMEOUTS in the Win32API ref for details

 ctmo.ReadIntervalTimeout=MAXDWORD;  // These 3 "Read.." settings will cause the ReadFile
 ctmo.ReadTotalTimeoutMultiplier=0;  // routine to return immediately with the characters (if any)
 ctmo.ReadTotalTimeoutConstant=0;    //  that have already been received.

 ctmo.WriteTotalTimeoutMultiplier=0;  // These 2 "Write.." settings wil cause the WriteFile
 ctmo.WriteTotalTimeoutConstant=5000; // routine to timout if it fails to send the specified data
                                      // in more than 5 seconds (5000ms)

 SetCommTimeouts(hCom, &ctmo);        // Set the Com Port time out values.
}

// ***********************************************************************
//  OpenCom(char *port, DWORD baud, int *pErrNo)
//  Open a serial port.
//  port= string with port name like "COM1" or "//.//COM12"
//  baud= desired baud rate
//  pErrNo = pointer to an integer that will contain the ERROR code (if any)
//  Returns a valid handle or INVALID_HANDLE_VALUE
// ***********************************************************************
HANDLE OpenCom(char *port, DWORD baud, int *pErrNo)
{
 DCB dcb;      // Windows Data Control Block (DCB)
 HANDLE hCom;  // Local COMM Handle

 // This is how to open a COM Port in Windows (just like opening a file.. sort of..)
 hCom = CreateFile( (LPSTR)port,
                   GENERIC_READ | GENERIC_WRITE,
                   0, // must be opened with exclusive-access
                   NULL, // no security attributes
                   OPEN_EXISTING, // must use OPEN_EXISTING
                   0, // not overlapped I/O
                   NULL // hTemplate must be NULL for comm devices
                 );

 if(hCom == INVALID_HANDLE_VALUE)
   {
     // CreateFile FAILED ...handle the error.
     *pErrNo=(int)GetLastError();
     return hCom;
   }
else
   {
    GetCommState(hCom, &dcb);  // Get a DCB for this PORT

    dcb.BaudRate = baud;       // set the baud rate
    dcb.ByteSize = 8;          // data size, xmit, and rcv
    dcb.Parity = NOPARITY;     // no parity bit
    dcb.StopBits = TWOSTOPBITS; // two stop bit

    dcb.fDtrControl = DTR_CONTROL_DISABLE;

    SetCommState(hCom, &dcb);  // Update the port settings

    SetComTimeout(hCom);       // Set the Com Port time out values.
   }

 return hCom;  // Return the valid COM handle to the calling program/
}
//************************************************************************
// AsciiToHexVal(char b)
// Convert a single ASCII character to it's 4 bit value 0-9 or A-F
// Note: no value error checking is done. Valid HEX characters is assumed
//************************************************************************
char AsciiToHexVal(char b)
{
 char v= b & 0x0F;  // '0'-'9' simply mask high 4 bits
 if(b>'9')
   v+=9;           // 'A'-'F' = low 4 bits +9
 return v;
}

//************************************************************************
// HexStrToByte(char *buf)
// Convert a 2 character ASCII string to a 8 bit unsigned value
//************************************************************************
unsigned char HexStrToByte(char *buf)
{
 unsigned char v;
 v= AsciiToHexVal(buf[0]) * 16;
 v+= AsciiToHexVal(buf[1]);
 return v;
}
