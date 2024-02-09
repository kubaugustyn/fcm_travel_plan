defmodule InputValidator do
  def run(input) do
    [
      validate_base(input)
    ]
  end

  defp validate_base(input) do
    String.match?(input, ~r/^BASED: [A-Z]{3}$/)
  end
end
