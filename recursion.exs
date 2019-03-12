defmodule Recursion do
  def my_map(_func, []), do: []
  def my_map(func, [head|tail]), do: [func.(head) | my_map(func, tail)]
end
