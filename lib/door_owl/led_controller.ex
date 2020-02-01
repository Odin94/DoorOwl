defmodule DoorOwl.LedController do
  use GenServer
  require Logger
  alias ElixirALE.GPIO

  @led_pin_red Application.get_env(:door_owl, :led_pin_red)
  @led_pin_green Application.get_env(:door_owl, :led_pin_green)
  @led_pin_white Application.get_env(:door_owl, :led_pin_white)

  @blink_ms 1000

  @name __MODULE__

  # API

  def start_link(state \\ []) do
    Logger.debug("starting link in led_controller")
    GenServer.start_link(__MODULE__, state, name: @name)
  end

  def set_active_colors(colors) do
    Logger.debug("Setting colors to: #{inspect(colors)}")
    GenServer.cast(@name, {:set_active_colors, colors})
  end

  # Callbacks

  def init(_args) do
    led_colors_pids =
      [
        {"red", @led_pin_red},
        {"green", @led_pin_green},
        {"white", @led_pin_white}
      ]
      |> Enum.map(fn {color, pin} -> {color, get_gpio_pid(pin)} end)

    Logger.debug("#{inspect(led_colors_pids)}")

    Logger.debug("Started GPIO server for led #{@led_pin_red}")

    schedule_blink()

    {:ok, {led_colors_pids, []}}
  end

  def handle_cast({:set_active_colors, new_colors}, {led_colors_pids, _active_colors}) do
    {:noreply, {led_colors_pids, new_colors}}
  end

  def handle_info(:blink, state) do
    blink_led(state, @blink_ms)
    Logger.debug("Done blinking once, scheduling new blink")
    schedule_blink()

    {:noreply, state}
  end

  def blink_led({led_colors_pids, active_colors}, blink_ms) do
    Logger.debug("Blinking once")

    led_colors_pids
    |> pids_for_active(active_colors)
    |> for_each(&GPIO.write(&1, 1))
    |> continue_after(blink_ms)
    |> for_each(&GPIO.write(&1, 0))
  end

  # Helpers

  defp schedule_blink() do
    Process.send_after(self(), :blink, 500)
  end

  # TODO: consider separate GenServer keeping gpio led state so you can't start_link on the same pin twice
  defp get_gpio_pid(pin), do: GPIO.start_link(pin, :output) |> elem(1)

  defp pids_for_active(led_colors_pids, active_colors) do
    led_colors_pids
    |> Enum.filter(fn {color, _} -> Enum.member?(active_colors, color) end)
    |> Enum.map(&elem(&1, 1))
  end

  defp for_each(enum, fun) do
    Enum.map(enum, fun)
    enum
  end

  defp continue_after(state, sleep_ms) do
    Process.sleep(sleep_ms)
    state
  end
end
