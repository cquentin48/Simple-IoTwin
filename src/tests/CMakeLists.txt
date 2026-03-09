include(FetchContent)

FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip
)

# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

# CPP Unit test files with link to the test lib
file(GLOB_RECURSE TEST_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/**/*.cpp"
)

add_executable(simple_iotwin_tests ${TEST_SOURCES})

target_link_libraries(simple_iotwin_tests GTest:gtest_main)

# Toggles on coverage
if(ENABLE_COVERAGE AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(tests PRIVATE --coverage -O0 -g -Wno-dev)
    target_link_options(tests PRIVATE --coverage -Wno-dev)
endif()
#

# Sets output folder to keep clear folder
include(GoogleTest)
gtest_discover_tests(simple_iotwin_tests)