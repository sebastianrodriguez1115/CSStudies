def solution(grid) do
  grid_check = check_grid(grid)
  transposed_grid = Enum.zip(grid)
  transposed_grid_check = check_grid(transposed_grid)

  sub_grid_check = verify_subgrid_row(Enum.at(grid,0),Enum.at(grid,1),Enum.at(grid,2)) &&
                   verify_subgrid_row(Enum.at(grid,3),Enum.at(grid,4),Enum.at(grid,5)) &&
                   verify_subgrid_row(Enum.at(grid,6),Enum.at(grid,7),Enum.at(grid,8))

  grid_check && transposed_grid_check && sub_grid_check
end

defp verify_subgrid_row(grid_row1, grid_row2, grid_row3) do
  {grid1, grid2, grid3} = subgrids(grid_row1, grid_row2, grid_row3)

  filtered_grid1 = Enum.filter(grid1, fn x -> x != "." end)
  filtered_grid2 = Enum.filter(grid2, fn x -> x != "." end)
  filtered_grid3 = Enum.filter(grid3, fn x -> x != "." end)

  grid1_flag = filtered_grid1 == Enum.uniq(filtered_grid1)
  grid2_flag = filtered_grid2 == Enum.uniq(filtered_grid2)
  grid3_flag = filtered_grid3 == Enum.uniq(filtered_grid3)

  grid1_flag && grid2_flag && grid3_flag
end

defp subgrids(row1, row2, row3) do
  sub_grids_row1 = Enum.chunk_every(row1,3)
  sub_grids_row2 = Enum.chunk_every(row2,3)
  sub_grids_row3 = Enum.chunk_every(row3,3)
  {
    Enum.concat([Enum.at(sub_grids_row1,0),Enum.at(sub_grids_row2,0),Enum.at(sub_grids_row3,0)]),
    Enum.concat([Enum.at(sub_grids_row1,1),Enum.at(sub_grids_row2,1),Enum.at(sub_grids_row3,1)]),
    Enum.concat([Enum.at(sub_grids_row1,2),Enum.at(sub_grids_row2,2),Enum.at(sub_grids_row3,2)])
  }
end

defp check_grid([]) do true end

defp check_grid([head | tail]) do
  {flag, numbers} = check_row(head)

  if flag && numbers == Enum.uniq(numbers) do
    check_grid(tail)
  else
    false
  end
end

defp check_row(row) when is_tuple(row) do
  check_row(Tuple.to_list(row))
end

defp check_row([]) do {true, []} end

defp check_row([head | tail]) do
  if String.equivalent?(head, ".") do
    check_row(tail)
  else
    case Integer.parse(head) do
      {integer, _remainder} ->
        case Enum.member?(1..9, integer) do
          true ->
            {flag, numbers} = check_row(tail)
            {flag, [integer | numbers]}
          false -> {false, []}
        end
      :error -> {false, []}
    end
  end
end