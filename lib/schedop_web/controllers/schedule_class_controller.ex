defmodule SchedopWeb.ScheduleClassController do
  use SchedopWeb, :controller

  alias Schedop.Schedules
  alias Schedop.Classes

  def index(conn, %{"schedule_id" => schedule_id}) do
    schedule = Schedules.get_schedule!(schedule_id)

    subjects =
      Enum.map(schedule.subjects, fn subject ->
        classes = Classes.list_classes_by_name(subject)
        {subject, classes}
      end)

    render(conn, :index, schedule: schedule, subjects: subjects)
  end

  def create(conn, %{"schedule_id" => schedule_id}) do
    schedule = Schedules.get_schedule!(schedule_id)

    Classes.populate_classes(schedule.subjects, schedule.term)

    conn
    |> put_flash(:info, "Classes retrieved successfully.")
    |> redirect(to: ~p"/schedules/#{schedule_id}/classes")
  end

  def show(conn, %{"schedule_id" => schedule_id, "id" => class_id}) do
    schedule = Schedules.get_schedule!(schedule_id)
    class = Classes.get_class!(class_id)

    render(conn, :show, schedule: schedule, class: class)
  end
end
