defmodule TravelParser do
  def parse(input) do
    base =
      input
      |> String.split("\n", trim: true)
      |> parse_base()

    %{base: base}
  end

  defp parse_base([base_string | _]) do
    base_string |> String.slice(-3, 3)
  end
end
