defmodule SchedopWeb.ScheduleController do
  use SchedopWeb, :controller

  alias Schedop.Schedules
  alias Schedop.Schedules.Schedule

  def index(conn, _params) do
    schedules = Schedules.list_schedules()
    render(conn, :index, schedules: schedules)
  end

  def new(conn, _params) do
    changeset = Schedules.change_schedule(%Schedule{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"schedule" => schedule_params}) do
    schedule_params
    |> populate_schedule_defaults()
    |> parse_schedule_params()
    |> Schedules.create_schedule()
    |> case do
      {:ok, schedule} ->
        conn
        |> put_flash(:info, "Schedule created successfully.")
        |> redirect(to: ~p"/schedules/#{schedule}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    schedule = Schedules.get_schedule!(id)
    render(conn, :show, schedule: schedule)
  end

  def edit(conn, %{"id" => id}) do
    schedule = Schedules.get_schedule!(id)
    changeset = Schedules.change_schedule(schedule)
    render(conn, :edit, schedule: schedule, changeset: changeset)
  end

  def update(conn, %{"id" => id, "schedule" => schedule_params}) do
    schedule = Schedules.get_schedule!(id)
    schedule_params = parse_schedule_params(schedule_params)

    case Schedules.update_schedule(schedule, schedule_params) do
      {:ok, schedule} ->
        conn
        |> put_flash(:info, "Schedule updated successfully.")
        |> redirect(to: ~p"/schedules/#{schedule}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, schedule: schedule, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    schedule = Schedules.get_schedule!(id)
    {:ok, _schedule} = Schedules.delete_schedule(schedule)

    conn
    |> put_flash(:info, "Schedule deleted successfully.")
    |> redirect(to: ~p"/schedules")
  end

  defp populate_schedule_defaults(schedule_params) do
    Map.merge(schedule_defaults(), schedule_params, fn _k, v1, v2 ->
      case v2 do
        nil -> v1
        "" -> v1
        _ -> v2
      end
    end)
  end

  defp schedule_defaults do
    %{
      "name" => "New Schedule #{DateTime.utc_now() |> DateTime.to_iso8601()}"
    }
  end

  defp parse_schedule_params(schedule_params) do
    subjects = schedule_params["subjects"] || ""

    parsed_subjects =
      String.split(subjects, [",", "\n"], trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.downcase/1)

    Map.put(schedule_params, "subjects", parsed_subjects)
  end
end
