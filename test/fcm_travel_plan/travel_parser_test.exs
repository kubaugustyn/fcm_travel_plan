defmodule FcmTravelPlan.TravelParserTest do
  alias FcmTravelPlan.TravelParser

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

  test "correctly sorts out the travel segments" do
    parsed_content = TravelParser.parse(@input)

    assert parsed_content.travel_segments == [
             "Flight SVQ 2023-03-02 06:40 -> BCN 09:10",
             "Hotel BCN 2023-01-05 -> 2023-01-10",
             "Flight SVQ 2023-01-05 20:40 -> BCN 22:10",
             "Flight BCN 2023-01-10 10:30 -> SVQ 11:50",
             "Train SVQ 2023-02-15 09:30 -> MAD 11:00",
             "Train MAD 2023-02-17 17:00 -> SVQ 19:30",
             "Hotel MAD 2023-02-15 -> 2023-02-17",
             "Flight BCN 2023-03-02 15:00 -> NYC 22:45",
             "Flight NYC 2023-03-06 08:00 -> BOS 09:25"
           ]
  end
end
