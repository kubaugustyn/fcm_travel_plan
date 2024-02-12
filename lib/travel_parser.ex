defmodule FcmTravelPlan.TravelParser do
  def parse(input) do
    [base_string | tail_input] =
      input
      |> String.split("\n\n")

    %{base: parse_base(base_string), travel_segments: parse_reservations(tail_input)}
  end

  defp parse_base(base_string), do: String.slice(base_string, -3, 3)

  defp parse_reservations(tail_input) do
    tail_input
    |> Enum.map(fn reservation ->
      parse_reservation(reservation)
    end)
    |> List.flatten()
  end

  defp parse_reservation(reservation) do
    [_ | segments] =
      reservation
      |> String.split("\n")

    segments
    |> Enum.map(fn segment ->
      parse_segment(segment)
    end)
    |> Enum.filter(& &1)
  end

  defp parse_segment(""), do: nil

  defp parse_segment(segment) do
    "SEGMENT: " <> segment_string = segment

    segment_string
  end
end
