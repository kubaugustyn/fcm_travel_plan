defmodule FcmTravelPlan do
  alias FcmTravelPlan.SegmentBuilder

  alias FcmTravelPlan.TripPlaner
  alias FcmTravelPlan.TripFormatter
  alias FcmTravelPlan.SegmentModels.Train
  alias FcmTravelPlan.SegmentModels.Flight

  def process_input(filename) do
    {:ok, input} = File.read(filename)

    %{base: base, travel_segments: travel_segments} = FcmTravelPlan.TravelParser.parse(input)

    travel_segments = SegmentBuilder.build(travel_segments)

    TripPlaner.call(%{trip_type: Train, base: base, segments: travel_segments})
    |> Enum.map(&TripFormatter.to_string/1)
    |> Enum.join("\n\n")
    |> Kernel.<>("\n")
    |> IO.puts()


    TripPlaner.call(%{trip_type: Flight, base: base, segments: travel_segments})
    |> Enum.map(&TripFormatter.to_string/1)
    |> Enum.join("\n\n")
    |> IO.puts()
  end
end
