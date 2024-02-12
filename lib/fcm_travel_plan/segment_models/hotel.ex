defmodule FcmTravelPlan.SegmentModels.Hotel do
  use StructCop

  contract do
    field(:localization, :string)
    field(:checkin_date, :utc_datetime)
    field(:checkout_date, :utc_datetime)
  end

  def validate(changeset) do
    import Ecto.Changeset

    changeset
    |> validate_required([:localization, :checkin_date, :checkout_date])
  end
end
