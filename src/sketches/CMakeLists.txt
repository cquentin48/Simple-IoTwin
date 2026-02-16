set(ARDUINO_CORE_FILES "$ENV{HOME}/.arduino15/packages/arduino/hardware")

if(BOARD_TYPE)
    if(BOARD_TYPE STREQUAL "AVR")
        include(avr.cmake)
    elseif(BOARD_TYPE STREQUAL "SAMD")
        include(samd.cmake)
    else()
        message(FATAL_ERROR "The cmake option BOARD_TYPE is invalid! Must be AVR for an AVR family board (e.g. Uno) or SAMD for a SAMD family board (e.g. MKR Wifi 1010)!")
    endif()
else()
    message(FATAL_ERROR "Board type option not set!")
endif()

# Arduino Core
if(ARDUINO_CORE_FILES)
    string(TOLOWER ${BOARD_TYPE} HARDWARE_FAMILY)
    file(GLOB HARDWARES "${ARDUINO_CORE_FILES}/${HARDWARE_FAMILY}")

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