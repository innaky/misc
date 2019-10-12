defmodule Recursion do
  def my_map(_func, []), do: []
  def my_map(func, [head|tail]), do: [func.(head) | my_map(func, tail)]
  
  def fact(0), do: 1
  def fact(x), do: x * fact(x - 1)
  
  def my_length([]), do: 0
  def my_length([_|cdr], do: 1 + my_length(cdr)
  
  # return a list of repeat element `n' times.
  def repeat(_, 0), do: []
  def repeat(elem, times), do: [elem | repeat(elem, times - 1)]
  
  # return a reverse of a list
  def reverse([]), do: []
  def reverse([head|tail]), do: tail ++ [head]
end
