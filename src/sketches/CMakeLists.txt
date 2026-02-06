# Check for arduino cli to be installed
find_program(ARDUINO_CLI "arduino-cli")

if(NOT ARDUINO_CLI)
    message(ERROR "You must have the arduino cli software installed!")
endif()

set(ARDUINO_SKETCH_PATH STRING "Arduino sketch path")
if(ARDUINO_SKETCH_PATH)
    add_custom_target(
        upload_sketch arduino-cli  ${ARDUINO_SKETCH_PATH}
    )
endif(ARDUINO_SKETCH_PATH)

#System paths
if(UNIX)
    include(Platform/UnixPaths)
    if(APPLE)
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH ~/Applications
                                              /Applications
                                              /Developer/Applications
                                              /sw
                                              /opt/local)
    endif()
elseif(WIN32)
    include(Platform/WindowsPaths)
endif()

function(add_arduino_lib PATH)
    file(GLOB VERSION_FOLDERS "${PATH}/*")
    foreach(VERSION_FOLDER ${VERSION_FOLDERS})
        file(GLOB VARIANTS "${VERSION_FOLDER}/variants/*")
        string(REPLACE "/" ";" TYPES ${PATH})
        list(GET TYPES -1 CORE_TYPE)

        foreach(VERSION ${CORE_TYPE})
            SET(library_name Arduino${CORE_TYPE})
            include_directories(
                ${CORE_TYPE} STATIC
                ${VERSION_FOLDER}/libraries
                ${VERSION_FOLDER}/cores/arduino
            )
            link_directories(${PATH})
            #target_link_libraries(${CORE_TYPE} PUBLIC sketches)
            #target_link_libraries(${CORE_TYPE} PUBLIC cxx_std_11)
        endforeach()
    endforeach()
    
endfunction()


#Arduino SDK
if(NOT ARDUINO_SDK_PATH)
    set(ARDUINO_SDK_PATH)

    foreach(DETECT_VERSION_MAJOR 1)
        foreach(DETECT_VERSION_MINOR RANGE 5 0)
            set(PATH $ENV{HOME}/.arduino${DETECT_VERSION_MAJOR}${DETECT_VERSION_MINOR})
            if(EXISTS ${PATH})
                FILE(GLOB SUB_FOLDERS "${PATH}/packages/arduino/hardware/*")
                foreach(SUB_FOLDER ${SUB_FOLDERS})
                    add_arduino_lib(${SUB_FOLDER})
                endforeach()
            endif()
            list(APPEND ARDUINO_PATHS $ENV{HOME}/.arduino-${DETECT_VERSION_MAJOR}.${DETECT_VERSION_MINOR})
        endforeach()
    endforeach()
else()
    add_arduino_lib(${ARDUINO_SDK_PATH})
endif()