defmodule Schedop.PathsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Schedop.Paths` context.
  """

  @doc """
  Generate a path.
  """
  def path_fixture(attrs \\ %{}) do
    {:ok, path} =
      attrs
      |> Enum.into(%{
        from_latitude: "some from_latitude",
        from_longitude: "some from_longitude",
        geojson: %{},
        to_latitude: "some to_latitude",
        to_longitude: "some to_longitude"
      })
      |> Schedop.Paths.create_path()

    path
  end
end
