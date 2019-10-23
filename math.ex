defmodule Math do
  @moduledoc """
  This is an example for module documentation

  # Example
  iex> Math.fac(4)
  24

  """

  @doc """
  This function return the factorial of a number.
  """

  def fac(0), do: 1
  def fac(x), do: x * fac(x - 1)
end
