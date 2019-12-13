#!/bin/bash
set -e

echo "Installing required tools"
sudo apt install build-essential automake autoconf git squashfs-tools ssh-askpass wget -y

echo "Installing fwup"
wget https://github.com/fhunleth/fwup/releases/download/v1.5.1/fwup_1.5.1_amd64.deb
sudo dpkg -i ./fwup_1.5.1_amd64.deb
sudo apt-get install -f
rm ./fwup_1.5.1_amd64.deb

echo "Installing tools required for custom nerves systems"
sudo apt install libssl-dev libncurses5-dev bc m4 unzip cmake python -y

echo "Installing erlang / elixir"
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.1

# The following steps are for bash. If you’re using something else, do the
# equivalent for your shell.
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc # optional
source ~/.bashrc

asdf plugin-add erlang
asdf plugin-add elixir

# Note #1:
# If on Debian or Ubuntu, you'll want to install wx before running the next
# line: sudo apt install libwxgtk3.0-dev
sudo apt install libwxgtk3.0-dev -y

# Note #2:
# It's possible to use different Erlang and Elixir versions with Nerves. The
# latest official Nerves systems are compatible with the versions below. In
# general, differences in patch releases are harmless. Nerves detects
# configurations that might not work at compile time.
asdf install erlang 22.0.7
asdf install elixir 1.9.1-otp-22
asdf global erlang 22.0.7
asdf global elixir 1.9.1-otp-22

echo "Updating hex & rebar"
mix local.hex --force
mix local.rebar --force

echo "Installing nerves_bootstrap"
mix archive.install hex nerves_bootstrap --force
