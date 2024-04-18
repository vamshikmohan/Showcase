import pyserial.tools.list_ports
import csv
import time

# Countdown function
def countdown(t):
    while t:
        mins, secs = divmod(t, 60)
        timeformat = '{:02d}:{:02d}'.format(mins, secs)
        print(timeformat, end='\r')
        time.sleep(1)
        t -= 1

# List available serial ports
def list_serial_ports():
    ports = pyserial.tools.list_ports.comports()
    return [port.device for port in ports]

# Find Arduino port
def find_arduino_port():
    ports = list_serial_ports()
    for port in ports:
        if 'Arduino' in port:
            return port
    return None

# Find Arduino port and open serial connection
arduino_port = find_arduino_port()
if arduino_port:
    ser = pyserial.Serial(arduino_port, 9600, timeout=1)
    time.sleep(2)  # Allow time for serial connection to establish

    # Open CSV file for writing
    with open('acceleration_data.csv', 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['X', 'Y', 'Z'])  # Write header

        # Countdown for 10 seconds
        countdown(10)

        # Read and write data for 10 seconds
        start_time = time.time()
        while (time.time() - start_time) < 10:
            line = ser.readline().decode().strip()
            data = line.split(',')
            writer.writerow(data)

    # Close serial port
    ser.close()
    print("Data collection completed.")
else:
    print("Arduino not found. Please check the connection.")
