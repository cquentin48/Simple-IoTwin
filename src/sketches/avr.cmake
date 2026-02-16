set(ARDUINO_AVR_VERSION "7.3.0-atmel3.6.1-arduino7" CACHE FILEPATH "SAMD Compiler version")
set(ARDUINO_TOOLS_PATH "$ENV{HOME}/.arduino15/packages/arduino/tools/avr-gcc/${ARDUINO_AVR_VERSION}/bin") 

set(CMAKE_SYSTEM_PROCESSOR samd)
set(CMAKE_C_COMPILER ${ARDUINO_TOOLS_PATH}/avr-gcc CACHE FILEPATH
    "Path to gcc compiler" FORCE)
set(CMAKE_CXX_COMPILER ${ARDUINO_TOOLS_PATH}/avr-g++ CACHE FILEPATH
    "Path to g++ compiler" FORCE)
set(CMAKE_OBJCOPY ${ARDUINO_TOOLS_PATH}/avr-objcopy CACHE FILEPATH
    "Path to arm-objcopy" FORCE)
set(CMAKE_SIZE ${ARDUINO_TOOLS_PATH}/avr-size CACHE FILEPATH
    "Path to avr-size" FORCE)