CONFIG += c++11 console # консольное приложение
CONFIG -= app_bundle
DEFINES += QT_DEPRECATED_WARNINGS
SOURCES += main.cpp
OBJECTS += text.o # подключение объектного модуля ассемблерной
 # подпрограммы
DISTFILES += text.asm 
CONFIG ~= s/-O[0123s]//g # отключение оптимизации
CONFIG += -O0
