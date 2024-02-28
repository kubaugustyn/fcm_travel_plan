defmodule FcmTravelPlan.Trip do
  use StructCop

  contract do
    field(:destinations, {:array, :string})
    field(:steps, {:array, :map})
  end

  def validate(changeset) do
    import Ecto.Changeset

    changeset
    |> validate_required([:destinations, :steps])
  end
end
