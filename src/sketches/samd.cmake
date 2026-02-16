set(ARDUINO_SAMD_VERSION "7-2017q4" CACHE FILEPATH "SAMD Compiler version")
set(ARDUINO_TOOLS_PATH "$ENV{HOME}/.arduino15/packages/arduino/tools/arm-none-eabi-gcc/${ARDUINO_SAMD_VERSION}/bin")

set(CMAKE_SYSTEM_PROCESSOR avr)
set(CMAKE_C_COMPILER ${ARDUINO_TOOLS_PATH}/arm-none-eabi-gcc CACHE FILEPATH
    "Path to gcc compiler" FORCE)
set(CMAKE_CXX_COMPILER ${ARDUINO_TOOLS_PATH}/arm-none-eabi-g++ CACHE FILEPATH
    "Path to g++ compiler" FORCE)
set(CMAKE_OBJCOPY ${ARDUINO_TOOLS_PATH}/arm-none-eabi-objcopy CACHE FILEPATH
    "Path to arm-objcopy" FORCE)
set(CMAKE_SIZE ${ARDUINO_TOOLS_PATH}/arm-none-eabi-size CACHE FILEPATH
    "Path to avr-size" FORCE)