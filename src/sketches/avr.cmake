message(STATUS "Checking if the avr bin programs are installed...")
find_program(AVR_GCC avr-gcc)
find_program(AVR_GPP avr-g++)
find_program(AVR_OBJ_COPY avr-objcopy)
find_program(AVR_SIZE avr-size)

set(CMAKE_SYSTEM_PROCESSOR avr)

if(NOT AVR_GCC OR NOT AVR_GPP OR NOT AVR_OBJ_COPY OR NOT AVR_SIZE)
    message(FATAL_ERROR "The avr bin programs are not installed globally. Please install them globally!")
else()
    message(STATUS "Using the avr binaries from those installed globally into your system...")
    set(CMAKE_C_COMPILER ${AVR_GCC} CACHE FILEPATH
    "Path to gcc compiler" FORCE)
    set(CMAKE_CXX_COMPILER ${AVR_GPP} CACHE FILEPATH
        "Path to g++ compiler" FORCE)
    set(CMAKE_OBJCOPY ${AVR_OBJ_COPY} CACHE FILEPATH
        "Path to objcopy" FORCE)
    set(CMAKE_SIZE ${AVR_SIZE} CACHE FILEPATH
        "Path to size" FORCE)
    set(CMAKE_EXE_LINKER_FLAGS "-lm" CACHE STRING "")
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE "-Wl,--strip-debug" CACHE STRING "")
endif()
