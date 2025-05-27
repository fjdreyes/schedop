defmodule Schedop.SchedulesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Schedop.Schedules` context.
  """

  @doc """
  Generate a schedule.
  """
  def schedule_fixture(attrs \\ %{}) do
    {:ok, schedule} =
      attrs
      |> Enum.into(%{
        name: "some name",
        subjects: ["option1", "option2"]
      })
      |> Schedop.Schedules.create_schedule()

    schedule
  end
end
