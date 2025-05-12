defmodule Day02 do
  defp read() do
    File.read!("day_02_input.txt")
    |> String.split("\n")
    |> Enum.map(fn row ->
      row
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def solve_pt1() do
    read()
    |> Enum.count(fn [n1 | tail] ->
       Enum.reduce_while(tail, {n1, nil}, fn n2, {n1, order} ->
          diff = (n1-n2)
          abs_diff = abs(diff)
          in_boundary? = abs_diff >= 1 && abs_diff <= 3
          curr_order = diff < 0 && :asc || :desc
          order = is_nil(order) && curr_order || order
          sorted? = order == curr_order

          if in_boundary? and sorted? do
            {:cont, {n2, order}}
          else
            {:halt, false}
          end
       end)
    end)
    |> tap(fn result -> IO.inspect("Part 01 Result: #{result}") end)
  end

  def solve_pt2() do
  end
end

Day02.solve_pt1()
Day02.solve_pt2()
