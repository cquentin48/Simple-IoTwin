add_executable(tests)

# CPP Unit test files with link to the test lib
file(GLOB_RECURSE TEST_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/**/*.cpp"
)
target_sources(tests PRIVATE ${TEST_SOURCES})

# Sets the output files (both lib and bin) in the out folder
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/lib)

# Includes library GTest and source code
target_link_libraries(tests PRIVATE arduino_iotwin gtest gtest_main)

# Include the source files for the unit tests
target_include_directories(tests PRIVATE
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src/libs>
)

# Toggles on coverage
if(ENABLE_COVERAGE AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(tests PRIVATE --coverage -O0 -g -Wno-dev)
    target_link_options(tests PRIVATE --coverage -Wno-dev)
endif()

# Sets output folder to keep clear folder
set_target_properties(tests PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/bin)

# Unit test automatic discovery
include(GoogleTest)
gtest_discover_tests(tests XML_OUTPUT_DIR tests_result)
