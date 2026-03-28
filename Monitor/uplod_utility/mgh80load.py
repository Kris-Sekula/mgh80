try:
	import serial
	from serial.tools.list_ports import comports
except ImportError as error:
	
	print(f"""Looks like you are missing the serial communication library
You should run the following command to install it:

	   python -m pip install pyserial
	   

... below is some additional debugging information:

{error}

Python: {platform.python_version()}
System: {platform.system()}
""")
	
	input("Press Enter to continue...")
	exit()


import time
import sys

COM_READ_MAX = 5000
COM_FLUSH_MAX = 0.005  # 5 ms
BAUD_RATE = 9600

def wait_for_com_byte(ser, timeout):
    start_time = time.time()
    while (time.time() - start_time) < (timeout / 1000):
        if ser.in_waiting > 0:
            return ser.read(1)  # Read one byte
    return None

def wait_for_com_response(ser, timeout):
    start_time = time.time()
    response = b''
    while (time.time() - start_time) < (timeout / 1000):
        if ser.in_waiting > 0:
            response += ser.read(ser.in_waiting)  # Read all available bytes
            if b'$$$' in response or b'*' in response or b'?' in response or b'E' in response:
                return response
    return None

def open_com(port, baud):
    try:
        ser = serial.Serial(port, baudrate=baud, timeout=0)
        ser.dtr = False  # Disable DTR
        time.sleep(COM_FLUSH_MAX)  # Allow time for port to stabilize
        return ser
    except serial.SerialException as e:
        print(f"ERROR: Failed to open serial port {port}: {e}")
        return None

def ascii_to_hex_val(b):
    if '0' <= b <= '9':
        return ord(b) - ord('0')
    elif 'A' <= b <= 'F':
        return ord(b) - ord('A') + 10
    return 0

def hex_str_to_byte(buf):
    return (ascii_to_hex_val(buf[0]) << 4) + ascii_to_hex_val(buf[1])

def main():
    if len(sys.argv) < 2:
        print("\nERROR! Too Few Arguments\nUsage: python mgh80load.py {filename} {port_#} {execute_after_loading Y/N}\n")
        return 1

    port_num = int(sys.argv[2]) if len(sys.argv) > 2 else 10
    port_name = f'COM{port_num}' if port_num < 10 else f'\\\\.\\COM{port_num}'
    src_file_name = sys.argv[1]

    try:
        with open(src_file_name, 'r') as fp:
            print(f"FILE: '{src_file_name}'")
            
            ser = open_com(port_name, BAUD_RATE)
            if ser is None:
                return 2

            print(f"Com port {port_name} open at {BAUD_RATE} baud.")
            ser.write(b'@')  # Send the attention byte
            time.sleep(0.25)

            response = wait_for_com_response(ser, COM_READ_MAX)
            if response is None or b'$$$' not in response:
                print("\nERROR! No Response from target, hit reset on your MGH80 board")
                ser.close()
                return 3

            print("\nTarget Ready")

            while True:
                line = fp.readline()
                if not line:
                    break
                
                rec_len = hex_str_to_byte(line[1:3])
                rec_type = int(line[7:9])

                if (rec_len == 0) and (rec_type != 0):
                    break
                
                ser.write(b':')  # Send the iHex record start byte
                time.sleep(COM_FLUSH_MAX)
                data_to_send = line.strip().encode()
                ser.write(data_to_send[1:])  # Send data
                print(f"Len: {rec_len} Type: {rec_type} {line.strip()}")  # Print it.

                # Wait for response '*' or '?'
                response = wait_for_com_response(ser, COM_READ_MAX)
                if response is None:
                    print("\nERROR! No Response from target")
                    ser.close()
                    return 4
                
                # Check for the specific response
                if b'*' in response:
                    print("Response: OK")
                elif b'?' in response or b'E' in response:
                    print("Response: ERROR")

                time.sleep(COM_FLUSH_MAX)

            if len(sys.argv) > 3:
                if sys.argv[3] == 'Y':
                    print("\nWill start your program from 0x8100\n")
                    ser.write(b'g')  # Start the program
                elif sys.argv[3] == 'N':
                    ser.write(b'!')  # Reset command

            ser.close()  # Close the serial port
            print("\nDone...")
            return 0

    except FileNotFoundError:
        print(f"ERROR: Cannot Open File '{src_file_name}'")
        return -1
    except Exception as e:
        print(f"ERROR: {e}")
        return -1

if __name__ == "__main__":
    main()
