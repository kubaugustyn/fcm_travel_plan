defmodule FcmTravelPlan.TripFormatter do
  alias FcmTravelPlan.Trip
  alias FcmTravelPlan.SegmentModels.Train
  alias FcmTravelPlan.SegmentModels.Hotel
  alias FcmTravelPlan.SegmentModels.Flight

  def to_string(%Trip{} = trip) do
    title = "TRIP to #{trip.destinations |> List.last()} \n"

    steps =
      trip.steps
      |> Enum.map(fn step ->
        convert_step_to_string(step)
      end)
      |> Enum.join("\n")

    title <> steps
  end

  defp convert_step_to_string(%trip{
         origin: origin,
         destination: destination,
         departure: departure,
         arrival: arrival
       })
       when trip in [Flight, Train] do
    departure = Calendar.strftime(departure, "%y-%m-%d %I:%M")
    arrival = Calendar.strftime(arrival, "%I:%M")
    trip_string = trip |> Atom.to_string() |> String.split(".") |> List.last()
    "#{trip_string} from #{origin} to #{destination} at #{departure} to #{arrival}"
  end

  defp convert_step_to_string(%Hotel{
         localization: localization,
         checkin_date: checkin_date,
         checkout_date: checkout_date
       }) do
    checkin_date = Calendar.strftime(checkin_date, "%y-%m-%d")
    checkout_date = Calendar.strftime(checkout_date, "%y-%m-%d")
    "Hotel at #{localization} on #{checkin_date} to #{checkout_date}"
  end
end
