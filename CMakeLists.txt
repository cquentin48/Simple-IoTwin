# Required C++ version
cmake_minimum_required(VERSION 3.16)

# Project name and language
project(SimpleIoTwin LANGUAGES CXX C)

set(CMAKE_PROJECT_VERSION 0.1)
set(CMAKE_PROJECT_VERSION_MAJOR 0)
set(CMAKE_PROJECT_VERSION_MINOR 1)
set(CMAKE_PROJECT_VERSION_PATCH 0)

# Minimal version of c++
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O0 -Wall -fprofile-arcs  -ftest-coverage")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0 -Wall -fprofile-arcs -ftest-coverage")

# Utils folder for custom commands (e.g. lint)
add_subdirectory(utils)

# Doxygen documentation
add_subdirectory(docs)

# Binaries output folder
set(OUTPUT_FOLDER ${CMAKE_BINARY_DIR}/out)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_FOLDER}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_FOLDER}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_FOLDER}/lib)
set(LIBRARY_ROOT_FOLDER ${CMAKE_BINARY_DIR}/libs/IoTwin)

set(ARDUINO_BOARD "uno" CACHE STRING "Arduino board")
set(BOARD_TYPE "AVR" CACHE STRING "Arduino board family")

# Coverage option (for debugging and continuous integration)
option(ENABLE_COVERAGE "Enable coverage reporting with LCOV" OFF)
option(BOARD_FAMILY "Arduino family board (AVR | SAMD)" AVR)

# Source folders
add_subdirectory(src/sketches)
add_subdirectory(src/libs)
#add_subdirectory(src/tests)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")

target_link_libraries(simple_iotwin
    ArduinoCore
    "-lc"
    "-lm"
)