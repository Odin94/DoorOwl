defmodule DoorOwl.Blinker do
  use GenServer
  require Logger
  alias ElixirALE.GPIO

  @led_pin Application.get_env(:door_owl, :perma_led_pin)
  @blink_ms 1000

  def start_link(state \\ []) do
    Logger.debug("starting link in blinker")
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(args) do
    Logger.debug("Starting pin #{@led_pin} as output")

    # spawn(__MODULE__, :blink_led_forever, [@led_pin, @blink_ms])
    schedule_blink()

    {:ok, args}
  end

  def handle_info(:blink, state \\ []) do
    blink_led(@led_pin, @blink_ms)
    Logger.debug("Done blinking once, scheduling new blink")
    schedule_blink()

    {:noreply, state}
  end

  def schedule_blink() do
    Process.send_after(self(), :blink, 1000)
  end

  def blink_led(pin, blink_ms) do
    Logger.debug("Blinking once")
    Logger.debug("Blinking pin #{pin} for #{blink_ms}ms once")

    GPIO.write(pin, 1)
    Logger.debug("LED on")
    :timer.sleep(blink_ms)
    GPIO.write(pin, 0)
    Logger.debug("LED off")

    {:noreply, []}
  end

  def blink_led_forever(pin, blink_ms) do
    Logger.debug("Blinking")
    Logger.debug("Blinking pin #{pin} for #{blink_ms}ms")

    GPIO.write(pin, 1)
    :timer.sleep(blink_ms)
    GPIO.write(pin, 0)
    :timer.sleep(blink_ms)

    blink_led_forever(pin, blink_ms)
  end
end
