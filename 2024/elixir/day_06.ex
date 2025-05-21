defmodule Day06 do
  require Integer
  def read do
    lines =
      "day_06_input.txt"
      |> File.read!()
      |> String.split("\n")

    y_boundary = length(lines)-1
    x_boundary = String.length(hd(lines))-1

    lines
    |> Enum.with_index()
    |> Enum.reduce({%{}, nil}, fn {line, x}, {obstacles, guard} ->
      obstacles =
        Regex.scan(~r/#/, line, return: :index)
        |> Enum.flat_map(fn
          [{y, _}] -> [y]
          _ -> []
        end)
        |> then(&Map.put(obstacles, x, &1))

      guard_coords =
        if !guard && String.contains?(line, "^") do
          [[{y, _}]] = Regex.scan(~r/\^/, line, return: :index)
          {x,y}
        else
          guard
        end

      {obstacles, guard_coords}
    end)
    |> then(fn {obstacles, guard_coords} ->
      obs_y =
        Enum.reduce(obstacles, %{}, fn {k, v}, acc ->
          Enum.reduce(v, acc, fn n, m -> Map.update(m, n, [k], &([k | &1])) end)
        end)
      {obstacles, obs_y, guard_coords, {x_boundary, y_boundary}}
    end)
  end

  @directions [{-1, 0}, {0, 1}, {1, 0}, {0, -1}]

  def solve_pt1() do
    [initial_direction | _] = @directions
    direction_idx = 0
    {obstacles_x_sorted, obstacles_y_sorted, init_guard_coords, boundaries} = read()

    patrolled_positions = patrol(boundaries, {obstacles_x_sorted, obstacles_y_sorted}, MapSet.new([]), init_guard_coords, initial_direction, direction_idx)

    IO.inspect("Result part 01: #{Enum.count(patrolled_positions)}")
  end

  defp patrol(t_boundaries, t_obstacles, patrolled_positions, guard_coords, direction, direction_idx) do
    {delta_elem, fixed_elem} = Integer.is_even(direction_idx) && {0, 1} || {1, 0 }
    {delta_idx, fixed_idx} = {elem(guard_coords, delta_elem), elem(guard_coords, fixed_elem)}

    positive? = elem(direction, delta_elem) > 0
    [max_boundary, obstacles] = resolve_data([t_boundaries, t_obstacles], direction)
    boundary = positive? && max_boundary || 0
    can_hit? = fn n ->
      if positive?, do: (n > delta_idx && n <= boundary), else: (n >= 0 && n < delta_idx)
    end
    next_obstacle_idx = Enum.reduce(obstacles[fixed_idx], nil, fn idx, acc ->
      can_hit?.(idx) && ((is_nil(acc) || (abs(delta_idx - idx) < abs(delta_idx - acc))) && idx) || acc
    end)

    # dbg()
    if next_obstacle_idx do
      if abs(delta_idx - next_obstacle_idx) > 1 do
        # Add positions patrolled, rotate, and patrol
        last_delta_idx = positive? && next_obstacle_idx - 1 || next_obstacle_idx + 1
        patrolled_positions =
          delta_idx..last_delta_idx
          |> MapSet.new(&Tuple.insert_at({fixed_idx}, delta_elem, &1))
          |> MapSet.union(patrolled_positions)
        guard_coords = Tuple.insert_at({fixed_idx}, delta_elem, last_delta_idx)
        direction_idx = direction_idx < 3 && direction_idx + 1 || 0
        direction = Enum.at(@directions, direction_idx)
        patrol(t_boundaries, t_obstacles, patrolled_positions, guard_coords, direction, direction_idx)
      else
        # Rotate and patrol
        direction_idx = direction_idx < 3 && direction_idx + 1 || 0
        direction = Enum.at(@directions, direction_idx)
        patrol(t_boundaries, t_obstacles, patrolled_positions, guard_coords, direction, direction_idx)
      end
    else
      # Add the positions patrolled and exit
      delta_idx..boundary
      |> MapSet.new(&Tuple.insert_at({fixed_idx}, delta_elem, &1))
      |> MapSet.union(patrolled_positions)
    end
  end

  defp resolve_data(tuples_of_data, {dir_x, _dir_y}) do
    if dir_x == 0 do
      Enum.map(tuples_of_data, &elem(&1, 0))
    else
      Enum.map(tuples_of_data, &elem(&1, 1))
    end
  end
end

Day06.solve_pt1()
