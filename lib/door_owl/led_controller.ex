defmodule DoorOwl.LedController do
  use GenServer
  require Logger
  alias ElixirALE.GPIO

  @led_pin_red Application.get_env(:door_owl, :led_pin_red)
  @led_pin_green Application.get_env(:door_owl, :led_pin_green)
  @led_pin_white Application.get_env(:door_owl, :led_pin_white)

  @blink_ms 1000

  def start_link(state \\ []) do
    Logger.debug("starting link in led_controller")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # Callbacks

  def init(args) do
    Logger.debug("Starting pin #{@led_pin_red} as output")
    {:ok, led_pid} = GPIO.start_link(@led_pin_red, :output)
    Logger.debug("Started GPIO server for led #{@led_pin_red} - pid is #{inspect led_pid}")

    schedule_blink()

    {:ok, [led_pid | args]}
  end

  def handle_info(:blink, state = [led_pid | _tail]) do
    Logger.debug("In handle_info with pin id: #{inspect led_pid}")
    blink_led(led_pid, @blink_ms)
    Logger.debug("Done blinking once, scheduling new blink")
    schedule_blink()

    {:noreply, state}
  end

  def blink_led(led_pid, blink_ms) do
    Logger.debug("Blinking once")
    Logger.debug("Blinking pin #{@led_pin_red} for #{blink_ms}ms once")

    GPIO.write(led_pid, 1)
    Logger.debug("LED on")
    Process.sleep(blink_ms)
    GPIO.write(led_pid, 0)
    Logger.debug("LED off")

    {:noreply, [led_pid]}
  end

  # Helpers

  defp schedule_blink() do
    Process.send_after(self(), :blink, 1000)
  end
end
