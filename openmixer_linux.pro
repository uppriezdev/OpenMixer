QT += quick gui
CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# To do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Project name and version
TARGET = OpenMixer
VERSION = 1.0.0

# Source files
SOURCES += \
    src/core/powerbutton.cpp \
    src/core/systemmonitor.cpp \
    src/core/systemprocess.cpp \
    src/main.cpp \
    src/gui/app.cpp

# Header files
HEADERS += \
    src/core/powerbutton.hpp \
    src/core/systemmonitor.hpp \
    src/core/systemprocess.hpp \
    src/gui/app.hpp

# Resource files
RESOURCES += \
    Resources/shared.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

# Output directories
DESTDIR = $$PWD/bin
OBJECTS_DIR = $$PWD/build/obj
MOC_DIR = $$PWD/build/moc
RCC_DIR = $$PWD/build/rcc
UI_DIR = $$PWD/build/ui

# Compiler specific flags
*msvc* {
    QMAKE_CXXFLAGS += /W3
} else {
    QMAKE_CXXFLAGS += -Wall -Wextra
}

# Debug configuration
CONFIG(debug, debug|release) {
    DEFINES += QT_QML_DEBUG
    msvc:QMAKE_CXXFLAGS += /Zi
    msvc:QMAKE_LFLAGS += /DEBUG
}

# Release configuration
CONFIG(release, debug|release) {
    DEFINES += QT_NO_DEBUG
    DEFINES += QT_NO_DEBUG_OUTPUT
}

DISTFILES +=
