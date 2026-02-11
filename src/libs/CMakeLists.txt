# Simple IoTwin library name
add_library(simple_iotwin STATIC)

# Binary and library output folder
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/lib)

# Source file lists
file(GLOB_RECURSE SOURCES
     "${CMAKE_CURRENT_SOURCE_DIR}/IoTwin/*.cpp"
     "${CMAKE_CURRENT_SOURCE_DIR}/IoTwin/*.h")
target_sources(simple_iotwin PRIVATE ${SOURCES})

# Coverage option (if enabled)
if(ENABLE_COVERAGE AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    message(TRACE "Code coverage enabled")
    target_compile_options(simple_iotwin PRIVATE --coverage -O0 -g -Wno-dev)
else()
    message(TRACE "Code coverage disabled")
endif()