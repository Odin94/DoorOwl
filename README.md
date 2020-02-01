# DoorOwl

**TODO: Add description**

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start your Nerves app:
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`
  * Open an ssh-iex session with `ssh doorowl@nerves.local`


## LED Setup
Complete this setup before powering on your device, otherwise you may cause damage.

Green cable: Breadboard A-27, GPIO 6

Red cable: Breadboard A-24, GPIO 5

White cable: Breadboard A-21, GPIO 4

Put a resistor right above each cable and connect to the minus side. 2k Ohm worked for me.

Put LEDs matching cable color on breadboard column C matching the positive side with the cables and negative side with the resistors.

Put a cable on the minus side of the breadboard, right below the resistor for the green led. Connect it to the ground pin on your device.



## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: https://nerves-project.org/
  * Forum: https://elixirforum.com/c/nerves-forum
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
