defmodule Recursion do
  def my_map(_func, []), do: []
  def my_map(func, [head|tail]), do: [func.(head) | my_map(func, tail)]
  
  def fact(0), do: 1
  def fact(x), do: x * fact(x - 1)
end
