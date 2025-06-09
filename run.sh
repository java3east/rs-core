clear &&
rm -rf rfx &&
mkdir rfx &&
cd rfx &&
wget -q https://github.com/java3east/RefineXModular/releases/download/alpha-1.0/refinex.zip &&
unzip -qq refinex.zip &&
rm refinex.zip &&
cd .. &&
java -jar ./rfx/RefineX-1.0-SNAPSHOT.jar RFX ./__test/run.lua &&
rm -rf rfx &&
echo "RefineX run completed."