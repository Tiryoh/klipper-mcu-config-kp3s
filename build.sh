#!/usr/bin/env bash

# SPDX-License-Identifier: GPL-3.0-or-later
# https://spdx.org/licenses/GPL-3.0-or-later.html
# Copyright (C) 2022 Daisuke Sato <tiryoh@gmail.com>

set -e
clear

### source other scripts
SRC_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
for script in "${SRC_DIR}/scripts/"*.sh; do
    . "${script}"
done

set_globals

KLIPPER_VERSION=$(get_klipper_git_version)

build_fw ${SRC_DIR}/configs/stm32f103vet6/.config
mkdir -p ${SRC_DIR}/build/klipper-${KLIPPER_VERSION}/stm32f103vet6
${KLIPPER_DIR}/scripts/update_mks_robin.py ${KLIPPER_DIR}/out/klipper.bin ${SRC_DIR}/build/klipper-${KLIPPER_VERSION}/stm32f103vet6/Robin_nano.bin

build_fw ${SRC_DIR}/configs/gd32f303vet6/.config
mkdir -p ${SRC_DIR}/build/klipper-${KLIPPER_VERSION}/gd32f303vet6
${KLIPPER_DIR}/scripts/update_mks_robin.py ${KLIPPER_DIR}/out/klipper.bin ${SRC_DIR}/build/klipper-${KLIPPER_VERSION}/gd32f303vet6/Robin_nano.bin
