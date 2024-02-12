defmodule FcmTravelPlan.SegmentBuilderTest do
  use ExUnit.Case

  alias FcmTravelPlan.SegmentBuilder

  alias FcmTravelPlan.SegmentModels.Flight
  alias FcmTravelPlan.SegmentModels.Hotel
  alias FcmTravelPlan.SegmentModels.Train

  test "correctly builds a Flight segment" do
    assert SegmentBuilder.build("Flight SVQ 2023-03-02 06:40 -> BCN 09:10") ==
             %Flight{
               arrival: ~U[2023-03-02 09:10:00Z],
               departure: ~U[2023-03-02 06:40:00Z],
               destination: "BCN",
               origin: "SVQ"
             }
  end

  test "correctly builds a Train segment" do
    assert SegmentBuilder.build("Train MAD 2023-02-17 17:00 -> SVQ 19:30") ==
             %Train{
               arrival: ~U[2023-02-17 19:30:00Z],
               departure: ~U[2023-02-17 17:00:00Z],
               destination: "SVQ",
               origin: "MAD"
             }
  end

  test "correctly builds a Hotel segment" do
    assert SegmentBuilder.build("Hotel MAD 2023-02-15 -> 2023-02-17") ==
             %Hotel{
               checkin_date: ~U[2023-02-15 00:00:00Z],
               checkout_date: ~U[2023-02-17 00:00:00Z],
               localization: "MAD"
             }
  end

  test "correctly builds a list of segments and sort it by departure/checkin date" do
    attrs = [
      "Flight SVQ 2023-03-02 06:40 -> BCN 09:10",
      "Train MAD 2023-02-17 17:00 -> SVQ 19:30",
      "Hotel MAD 2023-02-15 -> 2023-02-17"
    ]

    assert SegmentBuilder.build(attrs) == [
             %Hotel{
               checkin_date: ~U[2023-02-15 00:00:00Z],
               checkout_date: ~U[2023-02-17 00:00:00Z],
               localization: "MAD"
             },
             %Train{
               arrival: ~U[2023-02-17 19:30:00Z],
               departure: ~U[2023-02-17 17:00:00Z],
               destination: "SVQ",
               origin: "MAD"
             },
             %Flight{
               arrival: ~U[2023-03-02 09:10:00Z],
               departure: ~U[2023-03-02 06:40:00Z],
               destination: "BCN",
               origin: "SVQ"
             }
           ]
  end
end
