# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-sailgirlz

CONFIG += sailfishapp

SOURCES += src/harbour-sailgirlz.cpp

OTHER_FILES += qml/harbour-sailgirlz.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    qml/pages/EditGirlDlg.qml \
    qml/pages/AboutPage.qml \
    qml/pages/NotesPage.qml \
    qml/pages/EditNoteDlg.qml \
    qml/pages/Qlecti.js \
    qml/pages/Persistence.js \
    qml/pages/Algo.js \
    qml/pages/controls/ValueButtonEx.qml \
    rpm/harbour-sailgirlz.changes \
    rpm/harbour-sailgirlz.spec \
    rpm/harbour-sailgirlz.yaml \
    translations/*.ts \
    harbour-sailgirlz.desktop

#SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256
SAILFISHAPP_ICONS = 86x86

# to disable building translations every time, comment out the
# following CONFIG line
#CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-sailgirlz-de.ts

