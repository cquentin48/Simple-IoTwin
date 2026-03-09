include(FetchContent)

# If board type is set
if(BOARD_TYPE STREQUAL "AVR")
    set(ARDUINO_CORE_GIT_REPO "https://github.com/arduino/ArduinoCore-avr")
    set(ARDUINO_CORE_VERSION 1.8.7)
    string(TOLOWER ${BOARD_TYPE} CMAKE_COMPILERS)
elseif(BOARD_TYPE STREQUAL "SAMD")
    set(ARDUINO_CORE_GIT_REPO "https://github.com/arduino/ArduinoCore-samd")
    set(ARDUINO_CORE_VERSION 1.6.1)
    string(TOLOWER ${BOARD_TYPE} CMAKE_COMPILERS)
else()
    message(FATAL_ERROR "The cmake option BOARD_TYPE is invalid! Must be AVR for an AVR family board (e.g. Uno) or SAMD for a SAMD family board (e.g. MKR Wifi 1010)!")
endif()

# Download from the git repository
if(ARDUINO_CORE_GIT_REPO)
    # Arduino git repository based folder
    set(ARDUINO_TOOLS_PATH ${PROJECT_SOURCE_DIR}/build/_deps/arduinocore)

    if(EXISTS ${CMAKE_CURRENT_LIST_DIR}/${CMAKE_COMPILERS}.cmake)
        include(${CMAKE_CURRENT_LIST_DIR}/${CMAKE_COMPILERS}.cmake)
    else()
        message(FATAL_ERROR "No compiler with the name ${CMAKE_CURRENT_LIST_DIR}/${CMAKE_COMPILERS}.cmake was found!")
    endif()

    # Downloads it if not already done
    if(NOT EXISTS ${FETCHCONTENT_BASE_DIR}/arduinocore)
        message(STATUS "Downloading the arduino core ${BOARD_TYPE} family board git repository from github...")
        FetchContent_Declare(
            ArduinoCore
            GIT_REPOSITORY ${ARDUINO_CORE_GIT_REPO}
            GIT_TAG ${ARDUINO_CORE_VERSION}
        )
        FetchContent_MakeAvailable(ArduinoCore)
        file(REMOVE_RECURSE ${FETCHCONTENT_BASE_DIR}/arduinocore-build)
        file(REMOVE_RECURSE ${FETCHCONTENT_BASE_DIR}/arduinocore-subbuild)
        file(RENAME ${FETCHCONTENT_BASE_DIR}/arduinocore-src ${FETCHCONTENT_BASE_DIR}/arduinocore)
    else()
        message(STATUS "Using already downloaded folder. If the src folder don't correspond to the family board, please remove it and build again the project.")
    endif()
else()
    message(FATAL_ERROR "No board family found!")
endif()

# Fetch the board relevant data (board name, mcu, cpu frequency and variant)
find_package(Python3 REQUIRED)

message(STATUS "Fetching board informations from the board.txt file in the git repository.")
set(BOARD_FINDER_PY_SRC_FILE ${PROJECT_SOURCE_DIR}/utils/board_finder.py)
execute_process(COMMAND ${Python3_EXECUTABLE} ${BOARD_FINDER_PY_SRC_FILE} ${ARDUINO_BOARD} OUTPUT_VARIABLE RESULT WORKING_DIRECTORY ${PROJECT_SOURCE_DIR} RESULT_VARIABLE OUTPUT)

if(${OUTPUT} EQUAL 1)
    message(FATAL_ERROR "No board found with the name ${ARDUINO_BOARD} in the family ${BOARD_TYPE}!")
else()
    string(JSON BOARD_NAME GET ${RESULT} boardName)
    string(JSON F_CPU GET ${RESULT} f_cpu)
    string(JSON MCU GET ${RESULT} mcu)
    string(JSON VARIANT GET ${RESULT} variant)
    message(STATUS "Board ${BOARD_NAME} found in the ${BOARD_TYPE} family found")
    message(STATUS "- CPU frequency : ${F_CPU}")
    message(STATUS "- MCU : ${MCU}")
    message(STATUS "- Variant : ${VARIANT}")
endif()

# Build the library
message(STATUS "Building the arduino library with the variant ${VARIANT}")

set(ARDUINO_CORE_SRC_FOLDER ${PROJECT_SOURCE_DIR}/build/_deps/arduinocore/cores/arduino)
set(VARIANT_DIR ${PROJECT_SOURCE_DIR}/build/_deps/arduinocore/variants/${VARIANT})

if(NOT EXISTS ${VARIANT_DIR})
    message(FATAL_ERROR "The folder with the board name variant ${VARIANT} located at ${VARIANT_DIR} doesn't exist!")
endif()

file(GLOB ARDUINO_CORE_SRC
    ${ARDUINO_CORE_SRC_FOLDER}/*.c
    ${ARDUINO_CORE_SRC_FOLDER}/*.cpp
    ${ARDUINO_CORE_SRC_FOLDER}/*.S
)
add_library(ArduinoCore STATIC ${ARDUINO_CORE_SRC})

target_compile_definitions(ArduinoCore PUBLIC
    F_CPU=${F_CPU}
    ARDUINO=10607
    ARDUINO_AVR_${ARDUINO_BOARD}
    ARDUINO_ARCH_AVR
)

target_compile_options(ArduinoCore PRIVATE
    -mmcu=${MCU}
    -Os
    -Wall
    -ffunction-sections
    -fdata-sections
    -flto
)
    
target_include_directories(ArduinoCore PUBLIC
    "${ARDUINO_CORE_SRC_FOLDER}"
    "${VARIANT_DIR}"
)

install(TARGETS ${CORE_TARGET}
    ARCHIVE DESTINATION lib
)
    
install(DIRECTORY "${ARDUINO_CORE_SRC}/"
    DESTINATION include/arduino
    FILES_MATCHING PATTERN "*.h"
)
    
install(DIRECTORY "${VARIANT_DIR}/"
    DESTINATION include/variant
    FILES_MATCHING PATTERN "*.h"
)

message(STATUS "CMake correctly set up for the board ${BOARD_NAME} in the family ${BOARD_TYPE}.")
message(STATUS "To build the project : cmake --build build")