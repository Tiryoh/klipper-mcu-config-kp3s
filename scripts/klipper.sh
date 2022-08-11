#!/usr/bin/env bash


# SPDX-License-Identifier: GPL-3.0-or-later
# https://spdx.org/licenses/GPL-3.0-or-later.html
# Copyright (C) 2020 - 2022 Dominik Willner <th33xitus@gmail.com>
# Copyright (C) 2022 Daisuke Sato <tiryoh@gmail.com>

# This script is adapted from KIAUH - Klipper Installation And Update Helper
# https://github.com/th33xitus/kiauh/blob/1d7fb010af75c4d1cbea7e37893a06a6401a9b80/scripts/klipper.sh
# which is released under the GPLv3 License.
# Copyright (C) 2020 - 2022 Dominik Willner <th33xitus@gmail.com>
# https://github.com/th33xitus/kiauh/blob/1d7fb010af75c4d1cbea7e37893a06a6401a9b80/LICENSE
# This file may be distributed under the terms of the GNU GPLv3 license

set -e

function build_fw() {
  local python_version

  if [[ ! -d ${KLIPPER_DIR} || ! -d ${KLIPPY_ENV} ]]; then
    print_error "Klipper not found!\n Cannot build firmware without Klipper!"
    return
  fi

  python_version=$(get_klipper_python_ver)

  cd "${KLIPPER_DIR}"
  status_msg "Initializing firmware build ..."
  local dep=(build-essential dpkg-dev make)
  dependency_check "${dep[@]}"

  make distclean

  status_msg "Configuring from $1 ..."
  cp $1 .config
  make olddefconfig

  status_msg "Building firmware ..."
  if (( python_version == 3 )); then
    make PYTHON=python3
  elif (( python_version == 2 )); then
    make PYTHON=python2
  else
    warn_msg "Error reading Python version!"
    return 1
  fi

  ok_msg "Firmware built!"
}

#================================================#
#=================== HELPERS ====================#
#================================================#

function get_klipper_cfg_dir() {
  local cfg_dir

  if [[ -z ${custom_klipper_cfg_loc} ]]; then
    cfg_dir="${HOME}/klipper_config"
  else
    cfg_dir="${custom_klipper_cfg_loc}"
  fi

  echo "${cfg_dir}"
}

### returns the major python version the klippy-env was created with
function get_klipper_python_ver() {
  [[ ! -d ${KLIPPY_ENV} ]] && return

  local version
  version=$("${KLIPPY_ENV}"/bin/python --version 2>&1 | cut -d" " -f2 | cut -d"." -f1)
  echo "${version}"
}

function get_klipper_git_version() {
  [[ ! -d ${KLIPPER_DIR} ]] && return

  local version
  version=$(git -C ${KLIPPER_DIR} describe --always --tags --long --dirty)
  echo "${version}"
}