defprotocol Size do
  @doc "Calculate the size of a data structure. 
  And the length of the list."
  def size(data)
end
defimpl Size, for: BitString do
  def size(string), do: byte_size(string)
end

defimpl Size, for: Map do
  def size(map), do: map_size(map)
end

defimpl Size, for: Tuple do
  def size(tuple), do: tuple_size(tuple)
end

defimpl Size, for: List do
  def size(list), do: length(list)
end
