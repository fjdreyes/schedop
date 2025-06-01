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

  defp first_available(subjects) do
    Enum.reduce(subjects, [], fn subject, acc ->
      classes = Classes.list_classes_by_name(subject)

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
end
