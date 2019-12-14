defmodule DoorOwlTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  require Logger
  doctest DoorOwl

  setup do
    blinker = start_supervised!(DoorOwl.Blinker)
    tag_detector = start_supervised!(DoorOwl.TagDetector)

    %{
      blinker: blinker,
      tag_detector: tag_detector
    }
  end

  test "starting link in blinker" do
    assert capture_log(fn ->

    end) =~ "starting link in blinker"
  end

  test "calling blink forever", %{blinker: blinker} do
    assert capture_log(fn ->
      :timer.sleep(2000)
    end) =~ "Blinking"
  end
end
