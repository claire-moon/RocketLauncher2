#-------------------------------------------------
#
# Project created by QtCreator 2016-03-25T00:16:21
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = RocketLauncher2
TEMPLATE = app


SOURCES += main.cpp\
        rocketlauncher2.cpp \
    abstractmodels.cpp \
    dndfilesystemlistview.cpp \
    hyp_commonfunc.cpp \
    configs.cpp \
    enginesetup.cpp

HEADERS  += rocketlauncher2.h \
    abstractmodels.h \
    dndfilesystemlistview.h \
    hyp_commonfunc.h \
    configs.h

FORMS    += rocketlauncher2.ui

RESOURCES += \
    resources.qrc

CONFIG(release, debug|release):DEFINES += QT_NO_DEBUG_OUTPUT

win32:RC_ICONS = RocketLauncher2.ico

CONFIG += c++11

VERSION = 0.1.0.2
QMAKE_TARGET_COMPANY = Techpillar
QMAKE_TARGET_PRODUCT = Rocket Launcher 2.0
QMAKE_TARGET_DESCRIPTION = Rocket Launcher 2.0
QMAKE_TARGET_COPYRIGHT = Hypnotoad

unix {
    target.path = /usr/bin

    desktop.path = /usr/share/applications
    desktop.files = packaging/linux/io.github.Hypnotoad90.RocketLauncher2.desktop

    icon.path = /usr/share/icons/hicolor/256x256/apps
    icon.files = packaging/linux/rocketlauncher2.png

    metainfo.path = /usr/share/metainfo
    metainfo.files = packaging/linux/io.github.Hypnotoad90.RocketLauncher2.appdata.xml

    INSTALLS += target desktop icon metainfo
}
