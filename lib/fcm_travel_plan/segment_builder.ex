defmodule FcmTravelPlan.SegmentBuilder do
  alias FcmTravelPlan.SegmentModels.Flight
  alias FcmTravelPlan.SegmentModels.Hotel
  alias FcmTravelPlan.SegmentModels.Train

  def build(segment_list) when is_list(segment_list) do
    Enum.map(segment_list, &build/1)
    |> Enum.sort_by(&segment_mapper/1, DateTime)
  end

  def build(segment_string) do
    [type | tail] = segment_string |> String.split(" ")

    attrs =
      tail
      |> Enum.with_index(fn element, index -> {index, element} end)
      |> Map.new()

    case type do
      "Flight" -> build_flight_segment(attrs)
      "Train" -> build_train_segment(attrs)
      "Hotel" -> build_hotel_segment(attrs)
    end
  end

  defp build_flight_segment(attrs) do
    %{
      origin: attrs[0],
      destination: attrs[4],
      departure: "#{attrs[1]} #{attrs[2]}",
      arrival: "#{attrs[1]} #{attrs[5]}"
    }
    |> Flight.new!()
  end

  defp build_train_segment(attrs) do
    %{
      origin: attrs[0],
      destination: attrs[4],
      departure: "#{attrs[1]} #{attrs[2]}",
      arrival: "#{attrs[1]} #{attrs[5]}"
    }
    |> Train.new!()
  end

  defp build_hotel_segment(attrs) do
    %{
      localization: attrs[0],
      checkin_date: "#{attrs[1]} 00:00:00",
      checkout_date: "#{attrs[3]} 00:00:00"
    }
    |> Hotel.new!()
  end

  defp segment_mapper(%Hotel{checkin_date: checkin_date}), do: checkin_date
  defp segment_mapper(%Train{departure: departure}), do: departure
  defp segment_mapper(%Flight{departure: departure}), do: departure
end
