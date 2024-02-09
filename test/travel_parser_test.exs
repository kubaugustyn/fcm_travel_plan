defmodule TravelParserTest do
  use ExUnit.Case

  @input """
  BASED: SVQ

  RESERVATION
  SEGMENT: Flight SVQ 2023-03-02 06:40 -> BCN 09:10

  RESERVATION
  SEGMENT: Hotel BCN 2023-01-05 -> 2023-01-10

  RESERVATION
  SEGMENT: Flight SVQ 2023-01-05 20:40 -> BCN 22:10
  SEGMENT: Flight BCN 2023-01-10 10:30 -> SVQ 11:50

  RESERVATION
  SEGMENT: Train SVQ 2023-02-15 09:30 -> MAD 11:00
  SEGMENT: Train MAD 2023-02-17 17:00 -> SVQ 19:30

  RESERVATION
  SEGMENT: Hotel MAD 2023-02-15 -> 2023-02-17

  RESERVATION
  SEGMENT: Flight BCN 2023-03-02 15:00 -> NYC 22:45
  SEGMENT: Flight NYC 2023-03-06 08:00 -> BOS 09:25
  """

  test "correctly establishes base" do
    parsed_content = TravelParser.parse(@input)
    assert parsed_content.base == "SVQ"
  end

  test "correctly sorts out the reservations" do
    parsed_content = TravelParser.parse(@input)
    assert parsed_content.reservations ==  %{
      "reservation_1" => %{
        "segment_1" => "Flight SVQ 2023-03-02 06:40 -> BCN 09:10"
      },
      "reservation_2" => %{"segment_1" => "Hotel BCN 2023-01-05 -> 2023-01-10"},
      "reservation_3" => %{
        "segment_1" => "Flight SVQ 2023-01-05 20:40 -> BCN 22:10",
        "segment_2" => "Flight BCN 2023-01-10 10:30 -> SVQ 11:50"
      },
      "reservation_4" => %{
        "segment_1" => "Train SVQ 2023-02-15 09:30 -> MAD 11:00",
        "segment_2" => "Train MAD 2023-02-17 17:00 -> SVQ 19:30"
      },
      "reservation_5" => %{"segment_1" => "Hotel MAD 2023-02-15 -> 2023-02-17"},
      "reservation_6" => %{
        "segment_1" => "Flight BCN 2023-03-02 15:00 -> NYC 22:45",
        "segment_2" => "Flight NYC 2023-03-06 08:00 -> BOS 09:25"
      }
    }
  end
end
