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

et-log "Enabling i386 architecture support.."
dpkg --add-architecture i386
apt update

et-log "Installing QtTermTCP 32-bit build and runtime dependencies..."
apt install \
  qtbase5-dev:i386 \
  qtbase5-dev-tools:i386 \
  qt5-qmake:i386 \
  qtchooser:i386 \
  qtmultimedia5-dev:i386 \
  libqt5serialport5-dev:i386 \
  libfftw3-dev:i386 \
  qttools5-dev-tools:i386 \
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
