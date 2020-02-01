defmodule DoorOwl.LedController do
  use GenServer
  require Logger
  alias ElixirALE.GPIO

  @led_pin_red Application.get_env(:door_owl, :led_pin_red)
  @led_pin_green Application.get_env(:door_owl, :led_pin_green)
  @led_pin_white Application.get_env(:door_owl, :led_pin_white)

  @blink_ms 1000

  # API

  def start_link(state \\ []) do
    Logger.debug("starting link in led_controller")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # Callbacks

  def init(args) do
    led_colors_pids =
      [
        {"red", @led_pin_red},
        {"green", @led_pin_green},
        {"white", @led_pin_white}
      ]
      |> Enum.map(fn {color, pin} -> {color, get_gpio_pid(pin)} end)
    Logger.debug("#{inspect led_colors_pids}")

    Logger.debug("Started GPIO server for led #{@led_pin_red}")

    schedule_blink()

    {:ok, {led_colors_pids, []}}
  end

  def handle_info(:blink, state) do
    blink_led(state, @blink_ms)
    Logger.debug("Done blinking once, scheduling new blink")
    schedule_blink()

    {:noreply, state}
  end

  def blink_led(state = {led_colors_pids, _active_colors}, blink_ms) do
    Logger.debug("Blinking once")
    Logger.debug("Blinking pin #{@led_pin_red} for #{blink_ms}ms once")

    for {_, pid} <- led_colors_pids, do: GPIO.write(pid, 1)

    Logger.debug("LEDs on")
    Process.sleep(blink_ms)
    for {_, pid} <- led_colors_pids, do: GPIO.write(pid, 0)

    Logger.debug("LEDs off")

    {:noreply, state}
  end

  # Helpers

  defp schedule_blink() do
    Process.send_after(self(), :blink, 1000)
  end

  # TODO: consider separate GenServer keeping gpio led state so you can't start_link on the same pin twice
  defp get_gpio_pid(pin), do: GPIO.start_link(pin, :output) |> elem(1)
end
