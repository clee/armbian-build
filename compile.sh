#!/bin/bash
#
# Copyright (c) 2013-2021 Igor Pecovnik, igor.pecovnik@gma**.com
#
# This file is licensed under the terms of the GNU General Public
# License version 2. This program is licensed "as is" without any
# warranty of any kind, whether express or implied.
#
# This file is a part of the Armbian build script
# https://github.com/armbian/build/

# DO NOT EDIT THIS FILE
# use configuration files like config-default.conf to set the build configuration
# check Armbian documentation https://docs.armbian.com/ for more info

#set -o pipefail  # trace ERR through pipes - will be enabled "soon"
#set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable - one day will be enabled
set -o errtrace # trace ERR through - enabled
set -o errexit  ## set -e : exit the script if any statement returns a non-true return value - enabled
# Important, go read http://mywiki.wooledge.org/BashFAQ/105 NOW!

SRC="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
cd "${SRC}" || exit

# check for whitespace in ${SRC} and exit for safety reasons
grep -q "[[:space:]]" <<< "${SRC}" && {
	echo "\"${SRC}\" contains whitespace. Not supported. Aborting." >&2
	exit 1
}

# Sanity check.
if [[ ! -f "${SRC}"/lib/single.sh ]]; then
	echo "Error: missing build directory structure"
	echo "Please clone the full repository https://github.com/armbian/build/"
	exit 255
fi

# shellcheck source=lib/single.sh
source "${SRC}"/lib/single.sh

# hook up the error handler early, we wanna see stack for all errors.
trap 'main_error_monitor "$?" "$(show_caller_full)" "$(get_extension_hook_stracktrace "${BASH_SOURCE[*]}" "${BASH_LINENO[*]}")"' ERR EXIT

# And execute the main entrypoint.
cli_entrypoint "$@"
