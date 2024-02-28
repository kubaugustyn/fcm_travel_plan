defmodule FcmTravelPlan.TripPlaner do
  alias FcmTravelPlan.Trip
  alias FcmTravelPlan.TripFinder
  alias FcmTravelPlan.SegmentModels.Train
  alias FcmTravelPlan.SegmentModels.Hotel
  alias FcmTravelPlan.SegmentModels.Flight

  def call(%{trip_type: trip_type, base: base, segments: _} = attrs)
      when trip_type in [Flight, Train] do
    attrs
    |> trips_from_available_segments()
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
      search_for_a_trip_or_hotel(%{
        trip_type: trip_type,
        segments: segments,
        base: base,
        arrival: nil
      })
      |> Enum.reverse()

    if result != [] do
      [
        %{trip: Enum.reverse(result)}
        | trips_from_available_segments(Map.put(attrs, :segments, remaining_segments))
      ]
    else
      []
    end
  end

  defp search_for_a_trip_or_hotel(%{
         trip_type: trip_type,
         segments: segments,
         base: base,
         arrival: arrival
       }) do
    current_step =
      TripFinder.find_trip_or_hotel(%{
        trip_type: trip_type,
        segments: segments,
        base: base,
        arrival: arrival
      })

    if current_step == nil do
      [%{remaining_segments: segments}]
    else
      [
        current_step
        | search_for_a_trip_or_hotel(%{
            trip_type: trip_type,
            segments: List.delete(segments, current_step),
            base: get_current_destination(current_step),
            arrival: get_current_arrival(current_step)
          })
      ]
    end
  end

  defp get_current_destination(%Hotel{localization: localization}), do: localization

  defp get_current_destination(%trip{destination: destination}) when trip in [Flight, Train],
    do: destination

  defp get_current_arrival(%Hotel{checkout_date: checkout_date}), do: checkout_date
  defp get_current_arrival(%trip{arrival: arrival}) when trip in [Flight, Train], do: arrival
end
