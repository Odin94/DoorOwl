defmodule DoorOwl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DoorOwl.Supervisor]
    children =
      [
        # Children for all targets
        # Starts a worker by calling: DoorOwl.Worker.start_link(arg)
        # {DoorOwl.Worker, arg},
        {DoorOwl.Blinker, []},
        {DoorOwl.TagDetector, []}
      ] ++ children(target())

    DoorOwl.Blinky.start()
    # Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: DoorOwl.Worker.start_link(arg)
      # {DoorOwl.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Children for all targets except host
      # Starts a worker by calling: DoorOwl.Worker.start_link(arg)
      # {DoorOwl.Worker, arg},
      {Harald.Transport,
       namespace: :green_llama,
       adapter: {Harald.Transport.UART, device: "/dev/ttyAMA0", uart_opts: [speed: 115_200]}}
    ]
  end

  def target() do
    Application.get_env(:door_owl, :target)
  end
end
