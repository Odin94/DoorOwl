# DoorOwl

**TODO: Add description**

## Getting Started

All of this was tested with Ubuntu 16 and a Raspberry Pi 3B+

To get DoorOwl running:

  + Install asdf (version manager used for further installations) with `install_asdf.sh` and re-start your terminal to make sure `asdf` is available
  + Install elixir / nerves with `install_nerves_ubuntu.sh` (alternatively read the [official docs](https://hexdocs.pm/nerves/installation.html#content))
  + Set your target hardware with `export MIX_TARGET=my_target` or prefix every command with `MIX_TARGET=my_target` . For example `MIX_TARGET=rpi3` for Raspberry Pi 3  (read [official docs on targets](https://hexdocs.pm/nerves/targets.html#content) for more info)
  + Install dependencies with `mix deps.get` 
  + Create firmware with `mix firmware` 
  + Burn to an SD card with `mix firmware.burn` 
  + Open an ssh-iex session with `ssh doorowl@nerves.local` after connecting your computer to your device with an ethernet cable

After the first setup you can update the application over your ethernet connection with `mix firmware` followed by running `upload.sh` .

## LED Setup

Complete this setup before powering on your device, otherwise you may cause damage.

Green cable: Breadboard A-27, GPIO 6

Red cable: Breadboard A-24, GPIO 5

White cable: Breadboard A-21, GPIO 4

Put a resistor right above each cable and connect to the minus side.2k Ohm worked for me.

Put LEDs matching cable color on breadboard column C matching the positive side with the cables and negative side with the resistors.

Put a cable on the minus side of the breadboard, right below the resistor for the green led. Connect it to the ground pin on your device.

LED GPIO pins can be edited in `config/config.exs`.

## Bluetooth Tag Setup

## Learn more about nerves

  + Official docs: https://hexdocs.pm/nerves/getting-started.html
  + Official website: https://nerves-project.org/
  + Forum: https://elixirforum.com/c/nerves-forum
  + Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  + Source: https://github.com/nerves-project/nerves

