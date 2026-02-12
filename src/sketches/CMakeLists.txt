set(ARDUINO_CORE_FILES "$ENV{HOME}/.arduino15/packages/arduino/hardware" "ARDUINO CORE FILES")
set(ARDUINO_SAMD_VERSION "7-2017q4" CACHE FILEPATH "SAMD Compiler version")
set(ARDUINO_TOOLS_PATH "$ENV{HOME}/.arduino15/packages/arduino/tools/arm-none-eabi-gcc/${ARDUINO_SAMD_VERSION}/bin")

message(STATUS ${ARDUINO_TOOLS_PATH})


# Arduino Core
if(ARDUINO_CORE_FILES)
    file(GLOB HARDWARES "${ARDUINO_CORE_FILES}/samd")
    set(ARDUINO_CORE_FILES)

    set(LIBRARY_CORE_FOLDERS)
    set(LIBRARY_VARIANT_FOLDERS)
    foreach(HARDWARE ${HARDWARES})
        file(GLOB LIBRARY_CORE_PATHS "${HARDWARE}/*")
        foreach(LIBRARY_CORE_PATH ${LIBRARY_CORE_PATHS})
            file(GLOB VERSION_CORE_FILES "${LIBRARY_CORE_PATH}/cores/arduino/**.cpp"
                "${LIBRARY_CORE_PATH}/cores/arduino/**.c"
                "${LIBRARY_CORE_PATH}/cores/arduino/**.h"
                "${LIBRARY_CORE_PATH}/cores/arduino/**.S"
                "${LIBRARY_CORE_PATH}/cores/arduino/new"
            )
            list(APPEND ARDUINO_CORE_FILES ${VERSION_CORE_FILES})
            
            file(GLOB VARIANTS "${LIBRARY_CORE_PATH}/variants/*")

            list(APPEND LIBRARY_CORE_FOLDERS ${VARIANTS} ${LIBRARY_CORE_PATH}/cores/arduino)
        endforeach()
    endforeach()

    add_library(ArduinoCore STATIC ${ARDUINO_CORE_FILES})
    target_link_libraries(ArduinoCore PUBLIC ArduinoFlags)
    target_compile_features(ArduinoCore PUBLIC cxx_std_11 c_std_11)
    target_include_directories(ArduinoCore PUBLIC ${LIBRARY_CORE_FOLDERS})


    set(CMAKE_SYSTEM_PROCESSOR samd)
    set(CMAKE_C_COMPILER ${ARDUINO_TOOLS_PATH}/arm-none-eabi-gcc CACHE FILEPATH
        "Path to gcc compiler" FORCE)
    set(CMAKE_CXX_COMPILER ${ARDUINO_TOOLS_PATH}/arm-none-eabi-g++ CACHE FILEPATH
        "Path to g++ compiler" FORCE)
    set(CMAKE_OBJCOPY ${ARDUINO_TOOLS_PATH}/arm-none-eabi-objcopy CACHE FILEPATH
        "Path to arm-objcopy" FORCE)
    set(CMAKE_SIZE ${ARDUINO_TOOLS_PATH}/arm-none-eabi-size CACHE FILEPATH
        "Path to avr-size" FORCE)

    add_library(ArduinoFlags INTERFACE)
    target_compile_options(ArduinoFlags INTERFACE
        "-fno-exceptions"
        "-ffunction-sections"
        "-fdata-sections"
        "$<$<COMPILE_LANGUAGE:CXX>:-fno-threadsafe-statics>"
        "-mmcu=${ARDUINO_MCU}"
    )
    target_compile_definitions(ArduinoFlags INTERFACE
        "F_CPU=${ARDUINO_F_CPU}"
        "ARDUINO=${ARDUINO_VERSION}"
        "ARDUINO_${ARDUINO_BOARD}"
        "ARDUINO_ARCH_AVR"
    )
    target_link_options(ArduinoFlags INTERFACE
        "-mmcu=${ARDUINO_MCU}"
        "-fuse-linker-plugin"
        "LINKER:--gc-sections"
    )
    target_compile_features(ArduinoFlags INTERFACE cxx_std_11 c_std_11)

else()
    message(FATAL_ERROR "The path to the arduino library cores is not set!")
endif()