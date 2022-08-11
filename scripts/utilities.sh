#!/usr/bin/env bash

# SPDX-License-Identifier: GPL-3.0-or-later
# https://spdx.org/licenses/GPL-3.0-or-later.html
# Copyright (C) 2020 - 2022 Dominik Willner <th33xitus@gmail.com>
# Copyright (C) 2022 Daisuke Sato <tiryoh@gmail.com>

# This script is adapted from KIAUH - Klipper Installation And Update Helper
# https://github.com/th33xitus/kiauh/blob/1d7fb010af75c4d1cbea7e37893a06a6401a9b80/scripts/globals.sh
# https://github.com/th33xitus/kiauh/blob/1d7fb010af75c4d1cbea7e37893a06a6401a9b80/scripts/utilities.sh
# which is released under the GPLv3 License.
# Copyright (C) 2020 - 2022 Dominik Willner <th33xitus@gmail.com>
# https://github.com/th33xitus/kiauh/blob/1d7fb010af75c4d1cbea7e37893a06a6401a9b80/LICENSE
# This file may be distributed under the terms of the GNU GPLv3 license

# shellcheck disable=SC2034
set -e

function set_globals() {
  #=================== SYSTEM ===================#
  SYSTEMD="/etc/systemd/system"
  INITD="/etc/init.d"
  ETCDEF="/etc/default"

  #=================== KIAUH ====================#
  green=$(echo -en "\e[92m")
  yellow=$(echo -en "\e[93m")
  magenta=$(echo -en "\e[35m")
  red=$(echo -en "\e[91m")
  cyan=$(echo -en "\e[96m")
  white=$(echo -en "\e[39m")
  LOGFILE="/tmp/klipper-mcu-config.log"

  #================== KLIPPER ===================#
  KLIPPY_ENV="${HOME}/klippy-env"
  KLIPPER_DIR="${HOME}/klipper"
  KLIPPER_REPO="https://github.com/Klipper3d/klipper.git"
  KLIPPER_LOGS="${HOME}/klipper_logs"
  KLIPPER_CONFIG="$(get_klipper_cfg_dir)" # default: ${HOME}/klipper_config
}

#================================================#
#============= MESSAGE FORMATTING ===============#
#================================================#

function select_msg() {
  echo -e "${white}   [➔] ${1}"
}
function status_msg() {
  echo -e "\n${magenta}###### ${1}${white}"
}
function ok_msg() {
  echo -e "${green}[✓ OK] ${1}${white}"
}
function warn_msg() {
  echo -e "${yellow}>>>>>> ${1}${white}"
}
function error_msg() {
  echo -e "${red}>>>>>> ${1}${white}"
}
function abort_msg() {
  echo -e "${red}<<<<<< ${1}${white}"
}
function title_msg() {
  echo -e "${cyan}${1}${white}"
}

#================================================#
#================ DEPENDENCIES ==================#
#================================================#

function dependency_check() {
  local dep=( "${@}" )
  local packages
  status_msg "Checking for the following dependencies:"

  #check if package is installed, if not write its name into array
  for pkg in "${dep[@]}"; do
    echo -e "${cyan}● ${pkg} ${white}"
    [[ ! $(dpkg-query -f'${Status}' --show "${pkg}" 2>/dev/null) = *\ installed ]] && \
    packages+=("${pkg}")
  done

  #if array is not empty, install packages from array
  if (( ${#packages[@]} > 0 )); then
    status_msg "Installing the following dependencies:"
    for package in "${packages[@]}"; do
      echo -e "${cyan}● ${package} ${white}"
    done
    echo

    if sudo apt-get update --allow-releaseinfo-change && sudo apt-get install "${packages[@]}" -y; then
      ok_msg "Dependencies installed!"
    else
      error_msg "Installing dependencies failed!"
      return 1 # exit kiauh
    fi
  else
    ok_msg "Dependencies already met!"
    return
  fi
}
