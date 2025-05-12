@ECHO ON

cd DB-WebUI
docker compose up -d

cd ..
cd TerraDash

mkdir build
cd build

cmake ..

cmake --build . --config Debug

cd bin/Debug

main.exe

cd ../../../../