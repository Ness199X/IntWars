@echo off
echo Building IntWars Server.
echo ------------------------------
cd build
mingw32-make -j4 all
cd ..
pause
