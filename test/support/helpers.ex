defmodule FcmTravelPlan.Test.Helpers do
  @segments_list [
    %FcmTravelPlan.SegmentModels.Hotel{
      checkin_date: ~U[2023-01-05 00:00:00Z],
      checkout_date: ~U[2023-01-10 00:00:00Z],
      localization: "BCN"
    },
    %FcmTravelPlan.SegmentModels.Flight{
      arrival: ~U[2023-01-05 22:10:00Z],
      departure: ~U[2023-01-05 20:40:00Z],
      destination: "BCN",
      origin: "SVQ"
    },
    %FcmTravelPlan.SegmentModels.Flight{
      arrival: ~U[2023-01-10 11:50:00Z],
      departure: ~U[2023-01-10 10:30:00Z],
      destination: "SVQ",
      origin: "BCN"
    },
    %FcmTravelPlan.SegmentModels.Hotel{
      checkin_date: ~U[2023-02-15 00:00:00Z],
      checkout_date: ~U[2023-02-17 00:00:00Z],
      localization: "MAD"
    },
    %FcmTravelPlan.SegmentModels.Train{
      arrival: ~U[2023-02-15 11:00:00Z],
      departure: ~U[2023-02-15 09:30:00Z],
      destination: "MAD",
      origin: "SVQ"
    },
    %FcmTravelPlan.SegmentModels.Train{
      arrival: ~U[2023-02-17 19:30:00Z],
      departure: ~U[2023-02-17 17:00:00Z],
      destination: "SVQ",
      origin: "MAD"
    },
    %FcmTravelPlan.SegmentModels.Flight{
      arrival: ~U[2023-03-02 09:10:00Z],
      departure: ~U[2023-03-02 06:40:00Z],
      destination: "BCN",
      origin: "SVQ"
    },
    %FcmTravelPlan.SegmentModels.Flight{
      arrival: ~U[2023-03-02 22:45:00Z],
      departure: ~U[2023-03-02 15:00:00Z],
      destination: "NYC",
      origin: "BCN"
    },
    %FcmTravelPlan.SegmentModels.Flight{
      arrival: ~U[2023-03-06 09:25:00Z],
      departure: ~U[2023-03-06 08:00:00Z],
      destination: "BOS",
      origin: "NYC"
    }
  ]

  def segments_list(), do: @segments_list
end
