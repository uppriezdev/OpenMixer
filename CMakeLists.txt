cmake_minimum_required(VERSION 3.16)

project(OpenMixer VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Qt packages
find_package(Qt6 COMPONENTS Quick Gui REQUIRED)

# Set source files
set(SOURCES
    src/core/systemmonitor.cpp
    src/core/systemprocess.cpp
    src/main.cpp
    src/gui/app.cpp
)

set(HEADERS
    src/core/systemmonitor.hpp
    src/core/systemprocess.hpp
    src/gui/app.hpp
)

# Add executable
add_executable(${PROJECT_NAME}
    ${SOURCES}
    ${HEADERS}
    Resources/shared.qrc
)

# Link Qt libraries
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Quick
    Qt6::Gui
)

# Set compiler flags
if(MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /W3)
else()
    target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra)
endif()

# Set output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/lib)

# Debug/Release specific settings
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_definitions(${PROJECT_NAME} PRIVATE QT_QML_DEBUG)
    if(MSVC)
        target_compile_options(${PROJECT_NAME} PRIVATE /Zi)
        target_link_options(${PROJECT_NAME} PRIVATE /DEBUG)
    endif()
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Release")
    target_compile_definitions(${PROJECT_NAME} PRIVATE
        QT_NO_DEBUG
        QT_NO_DEBUG_OUTPUT
    )
endif()

# Installation rules
if(UNIX AND NOT APPLE)
    include(GNUInstallDirs)
    install(TARGETS ${PROJECT_NAME}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
endif()