defmodule FcmTravelPlan.SegmentModels.Flight do
  use StructCop

  contract do
    field(:origin, :string)
    field(:destination, :string)
    field(:arrival, :utc_datetime)
    field(:departure, :utc_datetime)
  end

  def validate(changeset) do
    import Ecto.Changeset

    changeset
    |> validate_required([:origin, :destination, :arrival, :departure])
  end
end
