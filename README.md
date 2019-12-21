# DoorOwl
Nerves application for tracking whether you're carrying your keys, wallet, phone etc. on you when leaving the door.

Put small bluetooth tags on any item you want to have on you when you leave your house and door owl will signal what items you are missing when you walk past it.

## Install Dependencies
On Ubuntu:

* Run `install_asdf.sh` to install [asdf](https://github.com/asdf-vm/asdf)
* Run `install_nerves_unbuntu.sh` to install required Erlang, Elixir & Nerves versions + their dependencies

Other Platforms:

* Read [Nerves installation docs](https://hexdocs.pm/nerves/0.3.0/installation.html)

(Windows is not supported by Nerves at time of writing)


## Install DoorOwl
* Set `MIX_TARGET` target platform environment variable, eg `MIX_TARGET=rpi3`  (see [Nerves docs](https://hexdocs.pm/nerves/targets.html#content
))
* Install dependencies with `mix deps.get`
* Create firmware with `mix firmware`
* Burn to an SD card with `mix firmware.burn`


## Learn more about Nerves

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: https://nerves-project.org/
  * Forum: https://elixirforum.com/c/nerves-forum
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
