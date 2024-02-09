defmodule FcmTravelPlanTest do
  use ExUnit.Case

  test "reads the input" do
    {:ok, input} = FcmTravelPlan.read_input()
    assert input
  end
end
