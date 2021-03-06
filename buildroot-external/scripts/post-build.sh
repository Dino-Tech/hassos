#!/bin/bash
set -e

SCRIPT_DIR=${BR2_EXTERNAL_HASSOS_PATH}/scripts
BOARD_DIR=${2}

. ${SCRIPT_DIR}/rootfs-layer.sh
. ${BR2_EXTERNAL_HASSOS_PATH}/info
. ${BOARD_DIR}/info
. ${SCRIPT_DIR}/name.sh
. ${SCRIPT_DIR}/rauc.sh


# HassOS tasks
fix_rootfs
install_hassos_cli

# Write os-release
(
    echo "NAME=${HASSOS_NAME}"
    echo "VERSION=\"${VERSION_MAJOR}.${VERSION_BUILD} (${BOARD_NAME})\""
    echo "ID=${HASSOS_ID}"
    echo "VERSION_ID=${VERSION_MAJOR}.${VERSION_BUILD}"
    echo "PRETTY_NAME=\"${HASSOS_NAME} ${VERSION_MAJOR}.${VERSION_BUILD}\""
    echo "CPE_NAME=cpe:2.3:o:home_assistant:${HASSOS_ID}:${VERSION_MAJOR}.${VERSION_BUILD}:*:${DEPLOYMENT}:*:*:*:${BOARD_ID}:*"
    echo "HOME_URL=https://hass.io/"
    echo "VARIANT=\"${HASSOS_NAME} ${BOARD_NAME}\""
    echo "VARIANT_ID=${BOARD_ID}"
) > ${TARGET_DIR}/usr/lib/os-release

# Write machine-info
(
    echo "CHASSIS=${CHASSIS}"
    echo "DEPLOYMENT=${DEPLOYMENT}"
) > ${TARGET_DIR}/etc/machine-info


# Setup rauc
write_rauc_config
install_rauc_certs
install_bootloader_config

