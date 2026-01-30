# Linter custom command
add_custom_target(
    lint cpplint --config=linter.cfg ${CMAKE_BINARY_DIR}/src/libs/**/*.cpp
    ${CMAKE_BINARY_DIR}/src/tests/**/*.cpp ${CMAKE_BINARY_DIR}/src/libs/**/*.h
    COMMENT "Check the code for writing errors or warning"
)