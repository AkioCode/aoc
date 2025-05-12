defmodule Day01 do
  defp read() do
    File.read!("day_01_input.txt")
    |> String.split("\n")
    |> Enum.reduce({[], []}, fn row, {l1, l2} ->
      [first_n, second_n] = String.split(row, "   ")
      first_n = String.to_integer(first_n)
      second_n = String.to_integer(second_n)
      {[first_n | l1], [second_n | l2]}
    end)
  end

  def solve_pt1() do
    {l1, l2} = read()
    l1 = Enum.sort(l1)
    l2 = Enum.sort(l2)
    result = Enum.zip_reduce([l1, l2], 0, fn [m, n], acc ->
      acc + abs(m-n)
    end)

    IO.inspect("Result: #{result}")
  end
end

Day01.solve_pt1()
