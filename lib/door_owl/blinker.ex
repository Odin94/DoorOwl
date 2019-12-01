defmodule DoorOwl.Blinker do
  use GenServer
  require Logger
  alias ElixirALE.GPIO

  @led_pin Application.get_env(:door_owl, :perma_led_pin)
  @blink_ms 1000

  def init(:ok) do
    Logger.debug("Starting pin #{@led_pin} as output")

    spawn(__MODULE__, :blink_led_forever, [@led_pin, @blink_ms])
  end

  defp blink_led_forever(pin, blink_ms) do
    Logger.debug("Blinking pin #{pin} for #{blink_ms}ms")
    GPIO.write(pin, 1)
    :timer.sleep(blink_ms)
    GPIO.write(pin, 0)
    :timer.sleep(blink_ms)

    blink_led_forever(pin, blink_ms)
  end

end
