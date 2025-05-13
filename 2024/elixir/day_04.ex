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

  defp add_x_directions(x, word_len, x_len) do
    if check_negative_direction(x, word_len) do
      [{-1, 0}]
    else
      []
    end
    |> then(fn directions ->
      if check_positive_direction(x, word_len, x_len) do
        directions ++ [{1, 0}]
      else
        directions
      end
    end)
  end

  defp add_y_directions(x_directions, y, word_len, y_len) do
    if check_negative_direction(y, word_len) do
      x_directions ++ Enum.map(x_directions, &({elem(&1, 0), -1})) ++ [{0, -1}]
    else
      x_directions
    end
    |> then(fn directions ->
      if check_positive_direction(y, word_len, y_len) do
        directions ++ Enum.map(x_directions, &({elem(&1, 0), 1})) ++ [{0, 1}]
      else
        directions
      end
    end)
  end

  def solve_pt2() do
    input = read()
    x_len = length(input)
    y_len = length(hd(input))
    word_len = 2

    input
    |> Enum.reduce({0, 0}, fn row, {counter, x} ->
      if check_word_in_axis(x, word_len, x_len) do
        row
        |> Enum.reduce({counter, 0}, fn
          "A", {counter, y} ->
            if check_word_in_axis(y, word_len, y_len) && x_mas?(input, x, y) do
              {counter + 1, y + 1}
            else
              {counter, y + 1}
            end
          _, {counter, y} ->
            {counter, y + 1}
        end)
        |> then(&({elem(&1, 0), x + 1}))
      else
        {counter, x + 1}
      end
    end)
    |> elem(0)
    |> tap(fn result -> IO.inspect("Part 02 Result: #{result}") end)
  end

  defp x_mas?(input, x, y) do
    check_pair = fn pair ->
      Enum.reduce_while(pair, nil, fn {x, y}, previous ->
        v = Enum.at(Enum.at(input, x), y)
        if v not in ["M", "S"] || previous && previous == v do
          {:halt, false}
        else
          {:cont, v}
        end
      end)
      |> then(&(&1 != false))
    end

    check_pair.([{x-1, y-1}, {x+1, y+1}]) && check_pair.([{x-1, y+1}, {x+1, y-1}])
  end

  defp check_word_in_axis(index, word_len, axis_len) do
    check_positive_direction(index, word_len, axis_len) &&
      check_negative_direction(index, word_len)
  end

  defp check_positive_direction(index, word_len, axis_len) do
    index < axis_len - (word_len - 1)
  end
  defp check_negative_direction(index, word_len) do
    index >= (word_len - 1)
  end

  defp check_direction(input, {og_x, og_y}, {dir_x, dir_y}, [current_letter | rest]) do
    x = og_x + dir_x
    y = og_y + dir_y
    letter = Enum.at(Enum.at(input, x), y)

    if letter == current_letter do
      (Enum.empty?(rest) || check_direction(input, {x, y}, {dir_x, dir_y}, rest))
    end
  end
end

Day04.solve_pt1()
Day04.solve_pt2()
