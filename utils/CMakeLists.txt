# Linter custom command
add_custom_target(
    lint cpplint --config=linter.cfg ${CMAKE_BINARY_DIR}/src/libs/**/*.cpp
    ${CMAKE_BINARY_DIR}/src/tests/**/*.cpp ${CMAKE_BINARY_DIR}/src/libs/**/*.h
    COMMENT "Check the code for writing errors or warning"
)

# Coverage custom command
add_custom_target(
    lcov -c -i -d src/libs -o cov_result.info
    COMMENT "Generate the coverage report base file"
)

# Generates HTML page
add_custom_target(
    genhtml -o coverage cov_result.info
)