#!/bin/bash
set -e

echo "Installing asdf version manager (later used to install required versions of erlang, elixir.."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.1

# The following steps are for bash. If you’re using something else, do the
# equivalent for your shell.
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc # optional
source ~/.bashrc

echo "Done installing asdf. Please re-start your terminal and make sure 'asdf' is available"