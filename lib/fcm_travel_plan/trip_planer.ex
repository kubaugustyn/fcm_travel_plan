defmodule FcmTravelPlan.TripPlaner do
  alias FcmTravelPlan.Trip
  alias FcmTravelPlan.SegmentModels.Train
  alias FcmTravelPlan.SegmentModels.Hotel
  alias FcmTravelPlan.SegmentModels.Flight

  def call(%{trip_type: trip_type, base: base, segments: _} = attrs)
      when trip_type in [Flight, Train] do
    trips_from_available_segments(attrs)
    |> Enum.map(fn trip_data ->
      steps = trip_data.trip
      destinations = pick_destinations(steps, base)

      Trip.new!(%{steps: steps, destinations: destinations})
    end)
  end

  defp pick_destinations(steps, base) do
    steps
    |> Enum.filter(fn %trip_type{} ->
      trip_type != Hotel
    end)
    |> Enum.map(& &1.destination)
    |> Enum.uniq()
    |> List.delete(base)
  end

  defp trips_from_available_segments(
         %{trip_type: trip_type, base: base, segments: segments} = attrs
       ) do
    [%{remaining_segments: remaining_segments} | result] =
      search_for_a_trip_or_hotel(trip_type, segments, base) |> Enum.reverse()

    if result != [] do
      [
        %{trip: Enum.reverse(result)}
        | trips_from_available_segments(Map.put(attrs, :segments, remaining_segments))
      ]
    else
      []
    end
  end

  defp search_for_a_trip_or_hotel(trip_type, segments, base, arrival \\ nil) do
    current_step =
      find_trip(trip_type, segments, base, arrival)
      |> maybe_change_to_hotel(segments, base)

    if current_step == nil do
      [%{remaining_segments: segments}]
    else
      [
        current_step
        | search_for_a_trip_or_hotel(
            trip_type,
            List.delete(segments, current_step),
            get_current_destination(current_step),
            get_current_arrival(current_step)
          )
      ]
    end
  end

  defp find_trip(trip_type, segments, base, arrival) do
    Enum.find(segments, &match_trip_on_base(&1, base, arrival, trip_type))
  end

  defp maybe_change_to_hotel(nil, segments, base) do
    Enum.find(segments, &match_hotel_on_base(&1, base))
  end

  defp maybe_change_to_hotel(trip, _, _), do: trip

  defp match_hotel_on_base(%Hotel{localization: localization}, base), do: localization == base
  defp match_hotel_on_base(_any, _base), do: false

  defp match_trip_on_base(%current_trip_type{origin: origin}, base, nil, trip_type) do
    current_trip_type == trip_type and origin == base
  end

  defp match_trip_on_base(
         %current_trip_type{origin: origin, departure: departure},
         base,
         arrival,
         trip_type
       ) do
    diff = DateTime.diff(departure, arrival)
    current_trip_type == trip_type && origin == base && diff > 0 && diff <= 86400
  end

  defp match_trip_on_base(_any, _base, _arrival, _trip_type), do: false

  defp get_current_destination(%Hotel{localization: localization}), do: localization

  defp get_current_destination(%trip{destination: destination}) when trip in [Flight, Train],
    do: destination

  defp get_current_arrival(%Hotel{checkout_date: checkout_date}), do: checkout_date
  defp get_current_arrival(%trip{arrival: arrival}) when trip in [Flight, Train], do: arrival
end
