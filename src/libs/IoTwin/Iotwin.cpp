#include "Iotwin.h"

IoTwin& IoTwin::GetInstance() {
    static IoTwin instance;
    return instance;
}
