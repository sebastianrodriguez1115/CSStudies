def solution(crypt, solution) do
  mapped_solution = solution_map(solution)
  replaced_crypt = replace_crypt(crypt, mapped_solution)
  IO.puts(inspect(replaced_crypt))
  IO.puts(trailing_zeroes?(replaced_crypt))
  if trailing_zeroes?(replaced_crypt) do
    false
  else
    correct_equation?(replaced_crypt)
  end
end

defp correct_equation?(replaced_crypt) do
  value1 = case Integer.parse(Enum.at(replaced_crypt, 0)) do
    :error -> -1
    {value, _} -> value
  end
  value2 = case Integer.parse(Enum.at(replaced_crypt, 1)) do
    :error -> -1
    {value, _} -> value
  end

  left_side = value1 + value2

  Integer.to_string(left_side) == Enum.at(replaced_crypt, 2)
end

defp trailing_zeroes?([]) do false end

defp trailing_zeroes?([head | tail]) do
  zero_check = String.at(head, 0) == "0"
  if zero_check && String.length(head) > 1 do
    true
  else
    trailing_zeroes?(tail)
  end
end

defp solution_map([]) do %{} end

defp solution_map([head | tail]) do
  mapped_solution = solution_map(tail)

  Map.put(mapped_solution, Enum.at(head,0), Enum.at(head,1))
end

defp replace_crypt([], _mapped_solution) do [] end

defp replace_crypt([head | tail], mapped_solution) do
  replaced_crypt = replace_crypt(tail, mapped_solution)
  replaced_numbers = replace_letters(String.codepoints(head), mapped_solution)

  [Enum.join(replaced_numbers, "") | replaced_crypt]
end

defp replace_letters([], _mapped_solution) do [] end

defp replace_letters([head | tail], mapped_solution) do
  replaced_letters = replace_letters(tail, mapped_solution)
  [Map.get(mapped_solution, head, '#') | replaced_letters]
end