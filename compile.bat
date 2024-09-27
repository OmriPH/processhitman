@echo off
echo Compilation uses g++, make sure you have it installed!
@echo on
windres resources.rc -O coff -o resources.o
g++ -o ProcessHitman.exe hitman.cpp resources.o -mwindows