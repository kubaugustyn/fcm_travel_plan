defmodule FcmTravelPlan.TripFormatterTest do
  use ExUnit.Case
  alias FcmTravelPlan.TripFormatter

  alias FcmTravelPlan.SegmentModels.Train
  alias FcmTravelPlan.SegmentModels.Flight
  alias FcmTravelPlan.TripPlaner

  test "returns proper string" do
    segments_list = FcmTravelPlan.Test.Helpers.segments_list()

    assert TripPlaner.call(%{trip_type: Train, base: "SVQ", segments: segments_list})
           |> Enum.map(&TripFormatter.to_string/1) == [
             "TRIP to MAD \nTrain from SVQ to MAD at 23-02-15 09:30 to 11:00\nHotel at MAD on 23-02-15 to 23-02-17\nTrain from MAD to SVQ at 23-02-17 05:00 to 07:30"
           ]

    assert TripPlaner.call(%{trip_type: Flight, base: "SVQ", segments: segments_list})
           |> Enum.map(&TripFormatter.to_string/1) == [
             "TRIP to BCN \nFlight from SVQ to BCN at 23-01-05 08:40 to 10:10\nHotel at BCN on 23-01-05 to 23-01-10\nFlight from BCN to SVQ at 23-01-10 10:30 to 11:50",
             "TRIP to NYC \nFlight from SVQ to BCN at 23-03-02 06:40 to 09:10\nFlight from BCN to NYC at 23-03-02 03:00 to 10:45"
           ]
  end
end
