#include <Wire.h>
#include <MPU6050.h>

MPU6050 mpu;

void setup() {
  Serial.begin(9600);
  Wire.begin();
  
  mpu.initialize();
  
  // Verify connection
  Serial.println(mpu.testConnection() ? F("MPU6050 connection successful") : F("MPU6050 connection failed"));
}

void clearSerialMonitor() {
  Serial.write(0x0C); // Send the ASCII form feed character (clear screen)
}

void loop() {
  unsigned long startTime = millis(); // Record the start time
  unsigned long elapsedTime = 0; // Initialize the elapsed time
      int count =0;

  
  Serial.print("Data START COLLECTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>> ");
  Serial.println("Data START COLLECTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>> ");
  
  // Run for 20 seconds
  while (elapsedTime < 20000) {
    // Read accelerometer data
    int16_t ax, ay, az;
    mpu.getAcceleration(&ax, &ay, &az);

    // Convert raw accelerometer values to gravitational units (g)
    float gx = ax / 16384.0;
    float gy = ay / 16384.0;
    float gz = az / 16384.0;

    // Print data
    Serial.print(gx, 6); // Print with 6 decimal places
    Serial.print(", ");
    Serial.print(gy, 6);
    Serial.print(", ");
    Serial.print(gz, 6);
        Serial.println(" ; ");

    // Update elapsed time
    elapsedTime = millis() - startTime;
    if (count%25 == 0) {
      Serial.println(count);
    }
    count = count +1;
    delay(20); // Adjust delay as needed
  }
  
  // End of data collection
  Serial.println("Data collection complete.");
  
  // Stop further execution
  while (true) {}
}
