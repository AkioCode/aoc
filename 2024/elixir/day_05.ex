defmodule Day05 do
  def read do
    [ordering_rules, updates] =
      File.read!("day_05_input.txt")
      |> String.split("\n\n")

    updates =
      updates
      |> String.split("\n")
      |> Enum.map(&String.split(&1, ","))

    {String.split(ordering_rules, "\n"), updates}
  end

  def solve_pt1() do
    {ordering_rules, updates} = read()
    ordering_rules = pages_after(ordering_rules)

    Enum.reduce(updates, 0,  fn [p1 | pages] = update, acc ->
      # If there is any page not in the right order, then reject
      result =
        Enum.reduce_while(pages, MapSet.new([p1]), fn page, previous_numbers ->
          rules = ordering_rules[page]
          if is_nil(rules) or MapSet.disjoint?(previous_numbers, rules) do
            {:cont, MapSet.put(previous_numbers, page)}
          else
            {:halt, :out_of_order}
          end
        end)

      if result === :out_of_order do
        acc
      else
        middle_i = Integer.floor_div(length(update), 2)
        String.to_integer(Enum.at(update, middle_i)) + acc
      end
    end)
    |> tap(fn result -> IO.inspect("Part 01 result: #{result}") end)
  end

  def solve_pt2() do
    {ordering_rules, updates} = read()
    before_p = pages_before(ordering_rules)
    Enum.reduce(updates, 0,  fn update, acc ->
      # If there is any page not in the right order, then reject
      sorted = check_and_sort_update(update, update, before_p)
      if update == sorted do
        acc
      else
        middle_i = Integer.floor_div(length(update), 2)
        String.to_integer(Enum.at(sorted, middle_i)) + acc
      end
    end)
    |> tap(fn result -> IO.inspect("Part 02 result: #{result}") end)
  end

  defp check_and_sort_update([], sorted, _before_p) do
    sorted
  end

  defp check_and_sort_update([page | next_numbers], sorted, before_p) do
    numbers_before_page = before_p[page] || []
    intersection = MapSet.intersection(MapSet.new(numbers_before_page), MapSet.new(next_numbers))
    if Enum.empty?(numbers_before_page) or Enum.empty?(intersection) do
      check_and_sort_update(next_numbers, sorted, before_p)
    else
      farther_i =
        sorted
        |> Enum.reverse()
        |> Enum.reduce_while(0, fn n, _acc ->
          if MapSet.member?(intersection, n) do
            {:halt, n}
          else
            {:cont, 0}
          end
        end)
        |> then(fn n -> Enum.find_index(sorted, fn n2 -> n == n2 end) end)

      page_i = Enum.find_index(sorted, fn n -> n == page end)
      sorted =
        sorted
        |> List.delete_at(page_i)
        |> List.insert_at(farther_i, page)

      sorted
      |> Enum.slice(page_i..-1//1)
      |> check_and_sort_update(sorted, before_p)
    end
  end

  defp pages_after(ordering_rules) do
    Enum.reduce(ordering_rules, %{}, fn <<d1::bytes-size(2)>> <> "|" <> <<d2::bytes-size(2)>>, acc ->
      Map.update(acc, d1, MapSet.new([d2]), &(MapSet.put(&1, d2)))
    end)
  end


  defp pages_before(ordering_rules) do
    Enum.reduce(ordering_rules, %{}, fn <<d1::bytes-size(2)>> <> "|" <> <<d2::bytes-size(2)>>, acc ->
      Map.update(acc, d2, [d1], &([d1 | &1]))
    end)
  end
end

Day05.solve_pt1()
Day05.solve_pt2()
