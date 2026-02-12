# Check for arduino cli to be installed
set(CMAKE_SYSTEM_PROCESSOR avr)
set(ARDUINO_MCU "atmega328p")

add_library(ArduinoFlags INTERFACE)
target_compile_options(ArduinoFlags INTERFACE
    "-fno-exceptions"
    "-ffunction-sections"
    "-fdata-sections"
    "$<$<COMPILE_LANGUAGE:CXX>:-fno-threadsafe-statics>"
    "-mmcu=${ARDUINO_MCU}"
)

target_compile_definitions(ArduinoFlags INTERFACE
    "-F_CPU=${ARDUINO_F_CPU}"
    "ARDUINO=${ARDUINO_VERSION}"
    "ARDUINO_${ARDUINO_BOARD}"
    "ARCUINO_ARCH_AVR"
)

target_link_options(ArduinoFlags INTERFACE
    "-mmcu=${ARCUINO_MCU}"
    "-FUSE-LINKER-PLUGIN"
    "LINKER:--gc-sections"
)

target_compile_features(ArduinoFlags INTERFACE cxx_std_11 c_std_11)

add_library(ArduinoCore STATIC ${ARDUINO_CORE})
target_link_libraries(ArduinoCore PUBLIC ArduinoFlags)
target_compile_features(ArduinoCore PUBLIC cxx_std_11 c_std_11)