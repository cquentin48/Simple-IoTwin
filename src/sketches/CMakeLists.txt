# Check for arduino cli to be installed
find_program(ARDUINO_CLI "arduino-cli")

if(NOT ARDUINO_CLI)
    message(ERROR "You must have the arduino cli software installed!")
endif()

set(ARDUINO_SKETCH_PATH STRING "Arduino sketch path")
if(ARDUINO_SKETCH_PATH)
    add_custom_target(
        upload_sketch arduino-cli  ${ARDUINO_SKETCH_PATH}
    )
endif(ARDUINO_SKETCH_PATH)


#System paths
if(UNIX)
    include(Platform/UnixPaths)
    if(APPLE)
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH ~/Applications
                                              /Applications
                                              /Developer/Applications
                                              /sw
                                              /opt/local)
    endif()
elseif(WIN32)
    include(Platform/WindowsPaths)
endif()

#
# @function add_arduino_lib
# @brief Add arduino library files from a specify hardware
# @param[IN] LIB_PATH Hardware root library path
# @param[OUT] NEW_LIB_FILES New library files to add
#
function(add_arduino_lib LIB_PATH NEW_LIB_FILES)
    file(GLOB VERSION_FOLDERS "${LIB_PATH}/*")
    foreach(VERSION_FOLDER ${VERSION_FOLDERS})
        set(NEW_VERSION_FILES)
        file(GLOB VARIANTS
            "${VERSION_FOLDER}/variants/**/*.h"
        )
        list(APPEND NEW_VERSION_FILES ${VARIANTS})
        string(REPLACE "/" ";" TYPES ${LIB_PATH})
        list(GET TYPES -1 CORE_TYPE)

        foreach(VERSION ${CORE_TYPE})
            file(GLOB CORE_FILES
                "${VERSION_FOLDER}/libraries/**/*.h"
                "${VERSION_FOLDER}/libraries/**/*.cpp"
                "${VERSION_FOLDER}/cores/arduino/*"
            )
            list(APPEND NEW_VERSION_FILES ${CORE_FILES})
        endforeach()
        list(APPEND NEW_LIB_FILES ${NEW_VERSION_FILES})
    endforeach()
    set(${NEW_LIB_FILES} ${${NEW_LIB_FILES}} PARENT_SCOPE)
endfunction()

set(ARDUINO_FILES)

#Arduino SDK
if(NOT ARDUINO_SDK_PATH)
    set(ARDUINO_SDK_PATH)
    set(ARDUINO_CORE)
    foreach(DETECT_VERSION_MAJOR 1)
        foreach(DETECT_VERSION_MINOR RANGE 5 0)
            set(PATH $ENV{HOME}/.arduino${DETECT_VERSION_MAJOR}${DETECT_VERSION_MINOR})
            if(EXISTS ${PATH})
                FILE(GLOB SUB_FOLDERS "${PATH}/packages/arduino/hardware/*")
                foreach(SUB_FOLDER ${SUB_FOLDERS})
                    set(NEW_LIB_FILES)
                    add_arduino_lib(${SUB_FOLDER} NEW_LIB_FILES)
                    list(APPEND ARDUINO_CORE ${NEW_LIB_FILES})
                endforeach()
            endif()
            list(APPEND ARDUINO_PATHS $ENV{HOME}/.arduino-${DETECT_VERSION_MAJOR}.${DETECT_VERSION_MINOR})
        endforeach()
    endforeach()
else()
    add_arduino_lib(${ARDUINO_SDK_PATH})
endif()

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