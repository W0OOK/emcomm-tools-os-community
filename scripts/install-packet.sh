#!/bin/bash
# Author  : Gaston Gonzalez
# Date    : 27 March 2023
# Updated : 3 January 2025
# Purpose : Install packet packages
set -e

et-log "Installing AX.25 packages..."
apt install \
  ax25-tools \
  ax25-apps \
  expect \
  -y

et-log "Installing rfcomm sudoers rules..."
cp -v ../overlay/etc/sudoers.d/* /etc/sudoers.d/

et-log "Updating AX.25 port permissions..."
chgrp -v -R $ET_GROUP /etc/ax25/axports
chmod -v 664 /etc/ax25/axports

