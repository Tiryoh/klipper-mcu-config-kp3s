# SPDX-License-Identifier: GPL-3.0-or-later
# https://spdx.org/licenses/GPL-3.0-or-later.html
# Copyright (C) 2022 Daisuke Sato <tiryoh@gmail.com>

# This script is adapted from https://github.com/Klipper3d/klipper/blob/1636a9759bc2d5f162312ac8bf5823e95e0ad053/scripts/Dockerfile
# which is released under the GPLv3 license.
# Copyright (C) 2016  Kevin O'Connor <kevin@koconnor.net>
# License: https://github.com/Klipper3d/klipper/blob/1636a9759bc2d5f162312ac8bf5823e95e0ad053/COPYING

FROM ubuntu:20.04 as base

RUN apt-get update && \
    apt-get install -y sudo git \
    python-dev libffi-dev build-essential \
    libncurses-dev \
    avrdude gcc-avr binutils-avr avr-libc \
    stm32flash libnewlib-arm-none-eabi \
    gcc-arm-none-eabi binutils-arm-none-eabi libusb-1.0 && \
    rm -rf /var/lib/apt/lists/*

FROM base

### Pre-setup ###
# Create user
RUN useradd -ms /bin/bash klippy && adduser klippy dialout
RUN echo 'klippy ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/klippy

USER klippy
#This fixes issues with the volume command setting wrong permissions
RUN mkdir /home/klippy/.config
VOLUME /home/klippy/.config

### Klipper setup ###
WORKDIR /home/klippy
# Work-around for caching
# https://stackoverflow.com/questions/36996046/how-to-prevent-dockerfile-caching-git-clone/39278224#39278224
ADD https://api.github.com/repos/Klipper3d/klipper/git/refs/heads/master klipper-version.json
RUN git clone https://github.com/Klipper3d/klipper.git

# This is to allow the install script to run without error
RUN sudo ln -s /bin/true /bin/systemctl

RUN ./klipper/scripts/install-ubuntu-18.04.sh && \
    sudo rm -rf /var/lib/apt/lists/*

# Clean up install script workaround
RUN sudo rm -f /bin/systemctl

COPY --chown=klippy build.sh klipper-mcu-config/
COPY --chown=klippy scripts/ klipper-mcu-config/scripts/
COPY --chown=klippy configs/ klipper-mcu-config/configs/

CMD ["/home/klippy/klipper-mcu-config/build.sh"]
