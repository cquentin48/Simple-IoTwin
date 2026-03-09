#include "Iotwin.h"
#include <stdlib.h>

IoTwin& IoTwin::GetInstance() {
    // LCOV_EXCL_START
    static IoTwin instance;
    return instance;
    // LCOV_EXCL_STOP
}

int IoTwin::getI() {
    return this->i;
}
