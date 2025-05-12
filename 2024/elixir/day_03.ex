defmodule Day03 do
  defp read() do
    File.read!("day_03_input.txt")
  end

  def solve_pt1() do
    str = read()
    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, str)
    |> Enum.map(fn operation ->
      [n1, n2] = List.delete_at(operation, 0)
      n1 = String.to_integer(n1)
      n2 = String.to_integer(n2)
      {n1, n2}
    end)
    |> Enum.reduce(0, fn {n1, n2}, acc ->
      n1 * n2 + acc
    end)
    |> tap(fn result -> IO.inspect("Part 01 Result: #{result}") end)
  end

  def solve_pt2() do
    str = read()
    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/, str)
    |> Enum.reduce({0, true}, fn
      ["do()"], {acc, _scan?} ->
        {acc, true}
      ["don't()"], {acc, true} ->
        {acc, false}
      _, {_acc, false} = acc ->
        acc
      operation, {acc, scan?} ->
        [n1, n2] = List.delete_at(operation, 0)
        n1 = String.to_integer(n1)
        n2 = String.to_integer(n2)
        {n1 * n2 + acc, scan?}
    end)
    |> tap(fn {result, _} -> IO.inspect("Part 02 Result: #{result}") end)
  end
end

Day03.solve_pt1()
Day03.solve_pt2()
