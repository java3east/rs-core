clear
rm -rf rfx
mkdir rfx
cd rfx
wget https://github.com/java3east/RefineXModular/releases/download/alpha-1.0/refinex.zip
unzip refinex.zip
rm refinex.zip
cd ..
ls -la
java -jar ./rfx/RefineX-1.0-SNAPSHOT.jar RFX ./__test/run.lua
rm -rf rfx
echo "RefineX run completed."