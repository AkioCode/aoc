defmodule Day01 do
  defp read() do
    File.read!("day_01_input.txt")
    |> String.split("\n")
  end

  def solve_pt1() do
    {l1, l2} =
      read()
      |> Enum.reduce({[], []}, fn row, {l1, l2} ->
        [first_n, second_n] = String.split(row, "   ")
        first_n = String.to_integer(first_n)
        second_n = String.to_integer(second_n)
        {[first_n | l1], [second_n | l2]}
      end)
    l1 = Enum.sort(l1)
    l2 = Enum.sort(l2)
    result = Enum.zip_reduce([l1, l2], 0, fn [m, n], acc ->
      acc + abs(m-n)
    end)

    IO.inspect("Part 1 Result: #{result}")
  end

  def solve_pt2() do
    {m1, m2} =
      read()
      |> Enum.reduce({%{}, %{}}, fn row, {first_map, l2} ->
        [m, n] = String.split(row, "   ")
        m = String.to_integer(m)
        n = String.to_integer(n)
        {Map.update(first_map, m, 1, &(&1 + 1)) ,Map.update(l2, n, 1, &(&1 + 1))}
      end)

    result = Enum.reduce(m1, 0, fn {k, v}, acc ->
      acc + k * v * Map.get(m2, k , 0)
    end)

    IO.inspect("Part 2 Result: #{result}")
  end
end

Day01.solve_pt1()
Day01.solve_pt2()
