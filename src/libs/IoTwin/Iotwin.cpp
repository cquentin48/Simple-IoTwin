#include "Iotwin.h"
#include <iostream>

IoTwin& IoTwin::GetInstance() {
    static IoTwin instance;
    return instance;
}

int IoTwin::getI() {
    return this->i;
}
