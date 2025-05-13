defmodule Day05 do
  def read do
    [ordering_rules, updates] =
      File.read!("day_05_input.txt")
      |> String.split("\n\n")

    ordering_rules =
      ordering_rules
      |> String.split("\n")
      |> Enum.reduce(%{}, fn <<d1::bytes-size(2)>> <> "|" <> <<d2::bytes-size(2)>>, acc ->
        Map.update(acc, d1, MapSet.new([d2]), &(MapSet.put(&1, d2)))
      end )

    updates =
      updates
      |> String.split("\n")
      |> Enum.map(&String.split(&1, ","))

    {ordering_rules, updates}
  end

  def solve_pt1() do
    {ordering_rules, updates} = read()
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
end

Day05.solve_pt1()
