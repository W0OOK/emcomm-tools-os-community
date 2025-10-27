#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 3 February 2025
# Purpose : Install QtTermTCP
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'et-log "\"${last_command}\" command failed with exit code $?."' ERR

. ./env.sh

APP=qttermtcp
VERSION=latest
DOWNLOAD_FILE=QtTermTCP
BIN_FILE=QtTermTCP
INSTALL_DIR="/opt/${APP}-${VERSION}"
INSTALL_BIN_DIR="${INSTALL_DIR}/bin"
LINK_PATH="/opt/${APP}"

et-log "Enabling arm64 architecture support.."
dpkg --add-architecture arm64
apt update

et-log "Installing QtTermTCP 32-bit build and runtime dependencies..."
apt install \
  qtbase5-dev:arm64 \
  qtbase5-dev-tools:arm64 \
  qt5-qmake:arm64 \
  qtchooser:arm64 \
  qtmultimedia5-dev:arm64 \
  libqt5serialport5-dev:arm64 \
  libfftw3-dev:arm64 \
  qttools5-dev-tools:arm64 \
  -y

if [ ! -e ${ET_DIST_DIR}/${DOWNLOAD_FILE} ]; then

  URL=http://www.cantab.net/users/john.wiseman/Downloads/${DOWNLOAD_FILE}

  et-log "Downloading QtTermTCP: ${URL}"
  curl -s -L -o ${DOWNLOAD_FILE} --fail ${URL}

  chmod 755 ${DOWNLOAD_FILE}
  mv -v ${DOWNLOAD_FILE} ${ET_DIST_DIR}
fi

CWD_DIR=`pwd`

[ ! -e ${INSTALL_BIN_DIR} ] && mkdir -v -p ${INSTALL_BIN_DIR}
cp -v "${ET_DIST_DIR}/${DOWNLOAD_FILE}" ${INSTALL_BIN_DIR}

[ -e ${LINK_PATH} ] && rm ${LINK_PATH}
ln -s ${INSTALL_DIR} ${LINK_PATH}

stow -v -d /opt ${APP} -t /usr/local

cd $CWD_DIR
