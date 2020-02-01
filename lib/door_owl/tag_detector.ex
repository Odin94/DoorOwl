defmodule DoorOwl.TagDetector do
  use GenServer
  require Logger

  @name __MODULE__
  @proximity_threshold Application.get_env(:door_owl, :proximity_threshold)
  @tag_addr_red Application.get_env(:door_owl, :tag_addr_red)
  @tag_addr_green Application.get_env(:door_owl, :tag_addr_green)

  # API

  def start_link(_state \\ []) do
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

    colors_tag_addrs = [
      {"red", @tag_addr_red},
      {"green", @tag_addr_green}
    ]

    active_colors =
      colors_tag_addrs
      |> filter_active_addr(addr_rss |> Enum.map(&elem(&1, 0)))
      |> to_color_rss(addr_rss)
      |> filter_signal_strength()

    DoorOwl.LedController.set_active_colors(active_colors)

    schedule_scan()

    {:noreply, state}
  end

  # Helpers

  defp debug_log(thing, text) do
    Logger.debug("#{text} #{inspect(thing)}")
    thing
  end

  defp filter_active_addr(colors_tag_addrs, active_addrs) do
    colors_tag_addrs
    |> Enum.filter(fn {_color, addr} -> Enum.member?(active_addrs, addr) end)
  end

  defp to_color_rss(colors_tag_addrs, addr_rss) do
    colors_tag_addrs
    |> Enum.map(fn {color, addr} -> {color, get_rss_for(addr, addr_rss)} end)
  end

  defp get_rss_for(addr, addr_rss) do
    Logger.debug("addr: #{addr}, addr_rss: #{inspect(addr_rss)}")

    addr_rss
    |> Enum.find(fn {tuple_addr, _rss} -> addr == tuple_addr end)
    |> elem(1)
  end

  defp filter_signal_strength(active_colors_rss) do
    active_colors_rss
    |> Enum.filter(fn {_color, rss} -> rss >= @proximity_threshold end)
    |> Enum.map(&elem(&1, 0))
  end

  defp schedule_scan() do
    Process.send_after(self(), :scan, 200)
  end

  defp device_maps_to_addr_and_rss(device_maps),
    do: Enum.map(device_maps, fn {addr, device} -> {addr, device.rss} end)
end
