# Required C++ version
cmake_minimum_required(VERSION 3.14)

# Project name and language
project(ArduinoIoTwin LANGUAGES CXX)

set(CMAKE_PROJECT_VERSION 0.1)
set(CMAKE_PROJECT_VERSION_MAJOR 0)
set(CMAKE_PROJECT_VERSION_MINOR 1)
set(CMAKE_PROJECT_VERSION_PATCH 0)

# Utils folder for custom commands (e.g. lint)
add_subdirectory(utils)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_FLAGS "-g -O0 -Wall -fprofile-arcs -ftest-coverage")
set(CMAKE_C_FLAGS "-g -O0 -Wall -fprofile-arcs -ftest-coverage")
set(CMAKE_EXE_LINKER_FLAGS "-fprofile-arcs -ftest-coverage")

# Binaries output folder
set(OUTPUT_FOLDER ${CMAKE_BINARY_DIR}/out)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_FOLDER}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_FOLDER}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_FOLDER}/lib)
set(LIBRARY_ROOT_FOLDER ${CMAKE_BINARY_DIR}/libs/IoTwin)

# Coverage option (for debugging and continuous integration)
option(ENABLE_COVERAGE "Enable coverage reporting with LCOV" OFF)

# Folder for respectively source code (libs) and unit tests (tests)
add_subdirectory(src/libs)
add_subdirectory(src/sketches)
add_subdirectory(src/tests)
add_subdirectory(docs)

# Debug messsage

# Fetch content for libraries
include(FetchContent)
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest
  GIT_TAG v1.17.0
)

# Fetch GTest library
FetchContent_MakeAvailable(googletest)