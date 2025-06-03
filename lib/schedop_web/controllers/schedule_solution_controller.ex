defmodule SchedopWeb.ScheduleSolutionController do
  use SchedopWeb, :controller

  alias Schedop.Schedules
  alias Schedop.Classes

  def show(conn, %{"schedule_id" => schedule_id, "id" => solution}) do
    schedule = Schedules.get_schedule!(schedule_id)

    render_solution(conn, solution, schedule)
  end

  defp render_solution(conn, "first_available", schedule) do
    classes = first_available(schedule.subjects)

    render(conn, "first_available.html", schedule: schedule, classes: classes)
  end

  defp render_solution(conn, "random_available", schedule) do
    classes = random_available(schedule.subjects)

    render(conn, "random_available.html", schedule: schedule, classes: classes)
  end

  defp render_solution(conn, "backtracking", schedule) do
    {status, classes} = backtracking(schedule.subjects)

    render(conn, "backtracking.html", schedule: schedule, classes: classes, status: status)
  end

  defp render_solution(conn, "map", schedule) do
    {status, classes} = backtracking(schedule.subjects)

    render(conn, "map.html",
      schedule: schedule,
      classes: classes,
      status: status,
      nodes:
        classes
        |> nodes_for_classes()
        |> Jason.encode!(),
      paths:
        classes
        |> paths_for_classes()
        |> Jason.encode!()
    )
  end

  defp first_available(subjects) do
    find_available(subjects)
  end

  defp random_available(subjects) do
    find_available(subjects, &Enum.shuffle/1)
  end

  defp backtracking(subjects) do
    subjects
    |> sort_by_class_count()
    |> find_by_backtracking()
  end

  defp find_available(subjects, strategy \\ & &1) do
    Enum.reduce(subjects, [], fn subject, acc ->
      classes = Classes.list_classes_by_name(subject) |> strategy.()

      case Enum.find(classes, fn class ->
             Enum.all?(acc, fn selected ->
               not class_conflict?(class, selected)
             end)
           end) do
        nil ->
          acc

        class ->
          [class | acc]
      end
    end)
    |> Enum.reverse()
  end

  defp sort_by_class_count(subjects) do
    subjects
    |> Enum.map(fn subject -> {subject, Classes.count_classes_by_name(subject)} end)
    |> Enum.sort_by(fn {_subject, count} -> count end)
    |> Enum.map(fn {subject, _count} -> subject end)
  end

  defp find_by_backtracking(subjects) do
    {status, classes} = backtrack(subjects, [], 0, [])
    {status, Enum.reverse(classes)}
  end

  defp backtrack(subjects, selected, index, _longest) when index == length(subjects),
    do: {:ok, selected}

  defp backtrack(subjects, selected, index, longest) do
    classes =
      subjects
      |> Enum.at(index)
      |> Classes.list_classes_by_name()
      |> Enum.shuffle()

    Enum.reduce(classes, {:partial, longest}, fn class, acc ->
      if Enum.any?(selected, &class_conflict?(class, &1)) do
        acc
      else
        case backtrack(
               subjects,
               [class | selected],
               index + 1,
               update_longest(acc, [class | selected])
             ) do
          {:ok, result} -> throw({:ok, result})
          {:partial, new_longest} -> {:partial, update_longest(acc, new_longest)}
        end
      end
    end)
  catch
    {:ok, result} -> {:ok, result}
  end

  defp update_longest({_, longest}, candidate) do
    if length(candidate) > length(longest) do
      candidate
    else
      longest
    end
  end

  defp class_conflict?(class1, class2) do
    Enum.any?(class1.time_blocks, fn block1 ->
      Enum.any?(class2.time_blocks, fn block2 ->
        time_conflict?(block1, block2)
      end)
    end)
  end

  defp time_conflict?(block1, block2) do
    day_conflict =
      MapSet.intersection(MapSet.new(block1["days"]), MapSet.new(block2["days"]))
      |> MapSet.size() > 0

    time_conflict =
      block2["start_time"] < block1["end_time"] and
        block1["start_time"] < block2["end_time"]

    day_conflict and time_conflict
  end

  defp nodes_for_classes(classes) do
    classes
    |> Enum.map(&class_with_location/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn location ->
      [location.class.name, location.longitude, location.latitude]
    end)
  end

  defp paths_for_classes(classes) do
    nodes = nodes_for_classes(classes) |> Enum.map(&Enum.slice(&1, 1..2)) |> Enum.with_index()

    Enum.reduce(nodes, [], fn {node1, index1}, acc1 ->
      Enum.reduce(nodes, [], fn {node2, index2}, acc2 ->
        if index1 != index2 do
          [[node1, node2] | acc2]
        else
          acc2
        end
      end)
      |> Enum.concat(acc1)
    end)
  end

  defp class_with_location(class) do
    case class.department do
      "DCS" -> %{class: class, longitude: 121.068612, latitude: 14.648567}
      "DECL" -> %{class: class, longitude: 121.066171, latitude: 14.652766}
      "MATH" -> %{class: class, longitude: 121.071421, latitude: 14.6486}
      "NIP" -> %{class: class, longitude: 121.07308, latitude: 14.649019}
      _ -> nil
    end
  end
end
