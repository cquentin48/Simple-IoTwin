# Simple IoTwin Tracker library

Simple library used to track IoT device which runs on a real time operating system.

Can also be used to save device parameters.

## Features
- Tracks and sends data to a dashboard
- Tracker configuration can be loaded from a `.json` file
- Manual (with cron) or automatic setup of data sending interval
- Can send data through MQTT or HTTP protocols
- Can send device settings data for later swap between devices

## Trackable data
- Battery percentage
- Model type (`Uno`, `Mega`, `MKR Wifi 1010`, $\dots$)
- Send data counter
- Device software errors
- Device current geolocation

## Requirements
- [`CMake`](https://cmake.org/download/)
- [`Arduino SDK`](https://www.arduino.cc/en/software)
- `FreeRTOS`


## Examples
Examples on how to use them are located inside the `examples` folder.

Here is a basic script on how to use the tracker inside your .ino file :

```c
#include <IoTwin/IoTwin.h>

void setup(){
    // Sets the tracker to track the battery percentage and model type
    IoTwin.setup([IoTwinBatteryPercentage, IoTwinObjectType]);

    // Data will be sent on the first of each month at midnight
    IoTwin.cron("0 0 1 * *");

    // Adds the rest of your script here...
}

void loop(){}
```
