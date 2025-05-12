defmodule Day04 do
  defp read() do
    File.read!("day_04_input.txt")
    |> String.split("\n")
    |> Enum.map(&String.graphemes(&1))
  end

  def solve_pt1() do
    input = read()
    x_len = length(input)
    y_len = length(hd(input))
    word = "XMAS"
    word_len = String.length(word)
    [first_letter | rest_chars] = String.graphemes(word)

    input
    |> Enum.reduce({0, 0}, fn row, {counter, x} ->
      x_directions = add_x_directions(x, word_len, x_len)

      row
      |> Enum.reduce({counter, 0}, fn
        ^first_letter, {counter, y} ->
          directions = add_y_directions(x_directions, y, word_len, y_len)
          matched_directions = Enum.count(directions, &(check_direction(input, {x, y}, &1, rest_chars)))
          {matched_directions + counter, y + 1}
        _, {counter, y} ->
          {counter, y + 1}
      end)
      |> then(&({elem(&1, 0), x + 1}))
    end)
    |> elem(0)
    |> tap(fn result -> IO.inspect("Part 01 Result: #{result}") end)
  end

  defp check_direction(input, {og_x, og_y}, {dir_x, dir_y}, [current_letter | rest]) do
    x = og_x + dir_x
    y = og_y + dir_y
    letter = Enum.at(Enum.at(input, x), y)

    if letter == current_letter do
      (Enum.empty?(rest) || check_direction(input, {x, y}, {dir_x, dir_y}, rest))
    end
  end

  defp add_x_directions(x, word_len, x_len) do
    if x >= (word_len - 1) do
      [{-1, 0}]
    else
      []
    end
    |> then(fn directions ->
      if x < x_len - (word_len - 1) do
        directions ++ [{1, 0}]
      else
        directions
      end
    end)
  end

  defp add_y_directions(x_directions, y, word_len, y_len) do
    if y >= (word_len - 1) do
      x_directions ++ Enum.map(x_directions, &({elem(&1, 0), -1})) ++ [{0, -1}]
    else
      x_directions
    end
    |> then(fn directions ->
      if y < y_len - (word_len - 1) do
        directions ++ Enum.map(x_directions, &({elem(&1, 0), 1})) ++ [{0, 1}]
      else
        directions
      end
    end)
  end
end

Day04.solve_pt1()
# Day03.solve_pt2()
