# klipper-mcu-config

Klipper MCU firmware build scripts

The firmware is tested only on KINGROON KP3S.

## Usage

### Raspberry Pi

Run the following commands to build the firmware.

```
git clone https://github.com/Tiryoh/klipper-mcu-config.git
cd klipper-mcu-config
./build.sh
```

The firmware will be built and written in the `build` directory.
If you want to download the firmware to a PC from the web browser, run the following command to start the web server.

```
python3 -m http.server 8000
```

The file is available from `http://$raspberry-pi-ip-address:8000`, like `http://192.168.10.40:8000`.

After downloading the firmware file, write the `Robin_nano.bin` to the SD card and flash it to the KP3S.

### PC

Download this repository and run the following commands.

```
docker build -t klipper-firmware-builder:latest .
docker run --rm -it -v $PWD/build:/home/klippy/klipper-mcu-config/build klipper-firmware-builder:latest /home/klippy/klipper-mcu-config/build.sh
```

The firmware will be built and written in the `build` directory.

After creating the firmware file, write the `Robin_nano.bin` to the SD card and flash it to the KP3S.

## License

This repository is released under the GNU General Public License v3.0,  
because it includes the scripts released under the GNU General Public License v3.0.

```
Copyright (C) 2022 Daisuke Sato <tiryoh@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```