# Linter custom command
add_custom_target(
    lint cpplint --config=linter.cfg ${CMAKE_BINARY_DIR}/src/libs/**/*.cpp
    ${CMAKE_BINARY_DIR}/src/tests/**/*.cpp ${CMAKE_BINARY_DIR}/src/libs/**/*.h
    COMMENT "Check the code for writing errors or warning"
)

# Coverage custom command
add_custom_target(
    cov_gen lcov -c -i -d ${CMAKE_BINARY_DIR}/src/libs -o cov_result.info
    COMMENT "Generate the coverage report base file"
)

# Generates HTML page
add_custom_target(
    cov_html genhtml -o coverage ${CMAKE_BINARY_DIR}/cov_result.info
    COMMENT "Generates an HTML base folder for the coverage result"
)