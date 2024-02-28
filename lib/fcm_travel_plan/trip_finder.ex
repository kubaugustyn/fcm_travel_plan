defmodule FcmTravelPlan.TripFinder do
  alias FcmTravelPlan.SegmentModels.Hotel

  def find_trip_or_hotel(%{trip_type: trip_type, segments: segments, base: base, arrival: arrival}) do
    Enum.find(
      segments,
      &match_trip_on_base(%{current_trip: &1, base: base, arrival: arrival, trip_type: trip_type})
    )
    |> maybe_change_to_hotel(segments, base)
  end

  defp maybe_change_to_hotel(nil, segments, base) do
    Enum.find(segments, &match_hotel_on_base(&1, base))
  end

  defp maybe_change_to_hotel(trip, _, _), do: trip

  defp match_hotel_on_base(%Hotel{localization: localization}, base), do: localization == base
  defp match_hotel_on_base(_any, _base), do: false

  defp match_trip_on_base(%{
         current_trip: %current_trip_type{origin: origin},
         base: base,
         arrival: nil,
         trip_type: trip_type
       }) do
    current_trip_type == trip_type and origin == base
  end

  defp match_trip_on_base(%{
         current_trip: %current_trip_type{origin: origin, departure: departure},
         base: base,
         arrival: arrival,
         trip_type: trip_type
       }) do
    diff = DateTime.diff(departure, arrival)
    current_trip_type == trip_type && origin == base && diff > 0 && diff <= 86400
  end

  defp match_trip_on_base(_attrs), do: false
end
