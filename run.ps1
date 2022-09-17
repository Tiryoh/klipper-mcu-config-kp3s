docker build -t klipper-firmware-builder:latest .
docker run --rm -it -v $PWD/build:/home/klippy/klipper-mcu-config/build klipper-firmware-builder:latest /home/klippy/klipper-mcu-config/build.sh
