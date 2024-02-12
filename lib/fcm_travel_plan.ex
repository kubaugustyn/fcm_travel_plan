defmodule FcmTravelPlan do
  alias FcmTravelPlan.SegmentBuilder

  def process_input do
    {:ok, input} = File.read("input.txt")

    %{base: base, travel_segments: travel_segments} = FcmTravelPlan.TravelParser.parse(input)

    SegmentBuilder.build(travel_segments)
  end
end
