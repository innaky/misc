defmodule Exactlymatch do
  @moduledoc """
  Check if a string is equal to another
  """

  @doc """
Simple predicate x is exactly equal to y?. Return true or false.
"""
  @spec exactlyEquals?(String.t(), String.t()) :: boolean()
  def exactlyEquals?(x, y) when is_binary(x) and is_binary(y) do
    sort_string(x) == sort_string(y)
  end
  
@doc """
Transform str to a list and orders it.
"""
  defp sort_string(str) do
    str
    |> String.downcase()
    |> String.graphemes()
    |> Enum.sort()
  end
end
