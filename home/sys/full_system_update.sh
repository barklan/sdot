#!/usr/bin/env bash

set -euo pipefail

sudo echo

echo -e "Updating fisher"
fish -c "fisher update"

notify-send -h int:transient:1 -t 15000 "Update Neovim plugins manually" ':Lazy sync'

echo -e "Updating system packages"
yay

echo -e "Updating global npm packages"
npm update -g &

echo -e "Updating pipx packages"
http_proxy='' https_proxy='' pipx upgrade-all &

echo -e "Updating rustup toolchain"
rustup update &

echo "Waiting for jobs to complete"
wait

cargo install-update -a

gore update
go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

echo "------"
echo "All done. Restart system now!"

notify-send -u critical "Update finished, reboot!"
