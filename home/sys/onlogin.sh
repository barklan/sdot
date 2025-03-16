#!/bin/bash

set -e

sleep 3

until ping -c 1 one.one.one.one
do
  sleep 1
done

# fish -c cloud-drive-mount

# fish -c cloud-drive-mount-mega
# echo 'N9bYTt5w5vD2j698FAsWBwla15HcY8eP16UHDfZFWOsrDbdO' | gocryptfs ~/mega/vault/ ~/mounts/mega_vault/
# notify-send 'Cloud drive and vault mounted.'

setsid telegram-desktop -startintray >/dev/null 2>&1 &
