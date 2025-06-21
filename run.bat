@echo off
cls
echo Fetching RefineX Simulation Environment...
rmdir /s /q rfx
mkdir rfx
cd rfx
curl -L -o refinex.zip https://github.com/java3east/RefineXModular/releases/download/alpha-1.0/refinex.zip
tar -xf refinex.zip
del refinex.zip
cd ..
echo Running RefineX Simulation...
java -jar .\rfx\RefineX-1.0-SNAPSHOT.jar RFX .\__test\run.lua
rmdir /s /q rfx
echo RefineX run completed.
pause