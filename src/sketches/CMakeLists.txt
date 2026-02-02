# Check for arduino cli to be installed
find_program(ARDUINO_CLI "arduino-cli")

if(NOT ARDUINO_CLI)
    message(ERROR "You must have the arduino cli software installed!")
endif()

set(ARDUINO_SKETCH_PATH STRING "Arduino sketch path")
if(ARDUINO_SKETCH_PATH)
    add_custom_command(
        upload_sketch arduino-cli  ${ARDUINO_SKETCH_PATH}
    )
endif(ARDUINO_SKETCH_PATH)