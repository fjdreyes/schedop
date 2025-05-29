defmodule SchedopWeb.ScheduleHTML do
  use SchedopWeb, :html

  embed_templates "schedule_html/*"

  @doc """
  Renders a schedule form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def schedule_form(assigns)

  @doc """
  Renders the schedule tabs.
  """
  attr :current_tab, :string, required: true
  attr :schedule, Schedop.Schedules.Schedule, required: true

  def schedule_tabs(assigns)

  defp classes_for_tab_link(link, current_tab) do
    [current_tab == link && "border-b-2 border-sky-700 text-sky-700", "pb-2"]
  end
end
