def solution(a) do
  rotate(a)
end

defp rotate([]) do
  []
end

defp rotate(array) do
  {subarray, modified_array} = List.pop_at(array, 0, [])
  splitted = split_array(subarray)
  rotated = rotate(modified_array)

  Enum.map(Enum.with_index(splitted), fn({[value], index}) ->
    case Enum.at(rotated, index) do
      nil -> [value]
      list_value -> Enum.concat(list_value, [value])
    end
  end)
end

defp split_array([value]) do
  [[value]]
end

defp split_array([head | tail]) do
  splited_array = split_array(tail)
  [ [head] | splited_array ]
end