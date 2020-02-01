defmodule DoorOwl.TagDetector do
  use GenServer
  require Logger

  @name __MODULE__
  @proximity_treshold 182
  @tag_addr_red Application.get_env(:door_owl, :tag_addr_red)
  @tag_addr_green Application.get_env(:door_owl, :tag_addr_green)


  # API

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  # Callbacks

  def init(:ok), do: init(%{})

  def init(state) do
    schedule_scan()

    {:ok, state}
  end

  # %Harald.HCI.Event.LEMeta.AdvertisingReport.Device{
  # address: 254479696499413,
  # address_type: 1,
  # data: [{1, <<6>>}, {6, <<232, 191, 108, 207, 23, 139, 50, 184, 76, 72, 106, 229, 0, 255, 186, 171>>}, {22, <<10, 24, 35, 4, 133, 124, 3>>}],
  # event_type: 0,
  # rss: 180}

  def handle_info(:scan, state) do
    scan_result = Harald.LE.scan(:bt)
    # Logger.debug("Original: #{inspect(scan_result)}")
    addr_rss = scan_result |> device_maps_to_addr_and_rss()
    Logger.debug("Scan result: #{inspect(addr_rss)}")
    addr_rss_red = Enum.find(addr_rss, fn {addr, _rss} -> addr == @tag_addr_red end)
    Logger.debug("addr_rss_red: #{inspect(addr_rss_red)}")

    # TODO: set all leds depending on rss. Don't forget addresses that don't show up in the scan
    set_led(addr_rss_red)

    schedule_scan()

    {:noreply, state}
  end

  # Helpers

  defp set_led({tag_addr, rss}) when rss >= @proximity_treshold do
    Logger.debug("---- turning on the lights ----")
  end

  defp set_led({tag_addr, rss}) do
    Logger.debug("RSS too low: #{rss} < #{@proximity_treshold}")
  end

  defp set_led(_) do
    Logger.debug("Signal not found")
  end

  defp schedule_scan() do
    Process.send_after(self(), :scan, 200)
  end

  defp device_maps_to_addr_and_rss(device_maps),
    do: Enum.map(device_maps, fn {addr, device} -> {addr, device.rss} end)
end
