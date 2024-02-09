defmodule TravelParser do
  def parse(input) do
    [base_string | tail_input] =
      input
      |> String.split("\n\n")

    %{base: parse_base(base_string), reservations: parse_reservations(tail_input)}
  end

  defp parse_base(base_string), do: String.slice(base_string, -3, 3)

  defp parse_reservations(tail_input) do
    tail_input
    |> Enum.reduce(%{counter: 1}, fn reservation, acc ->
      Map.merge(acc, %{
        "reservation_#{acc.counter}" => parse_reservation(reservation),
        counter: acc.counter + 1
      })
    end)
    |> Map.delete(:counter)
  end

  defp parse_reservation(reservation) do
    [_ | segments] =
      reservation
      |> String.split("\n")

    segments
    |> Enum.reduce(%{counter: 1}, fn segment, acc ->
      if segment != "" do
        Map.merge(acc, %{
          "segment_#{acc.counter}" => parse_segment(segment),
          counter: acc.counter + 1
        })
      else
        acc
      end
    end)
    |> Map.delete(:counter)
  end

  defp parse_segment(segment) do
    "SEGMENT: " <> segment_string = segment

    segment_string
  end
end
