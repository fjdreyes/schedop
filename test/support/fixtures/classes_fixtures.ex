defmodule Schedop.ClassesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Schedop.Classes` context.
  """

  @doc """
  Generate a class.
  """
  def class_fixture(attrs \\ %{}) do
    {:ok, class} =
      attrs
      |> Enum.into(%{
        code: 42,
        demand: 42,
        department: "some department",
        description: "some description",
        instructor: "some instructor",
        name: "some name",
        remarks: "some remarks",
        restrictions: "some restrictions",
        schedule: "some schedule",
        section: "some section",
        slots_available: 42,
        slots_total: 42,
        units: 42
      })
      |> Schedop.Classes.create_class()

    class
  end
end
