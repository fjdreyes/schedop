defmodule SchedopWeb.PathJSON do
  alias Schedop.Paths.Path

  @doc """
  Renders a list of paths.
  """
  def index(%{paths: paths}) do
    %{data: for(path <- paths, do: data(path))}
  end

  @doc """
  Renders a single path.
  """
  def show(%{path: path}) do
    %{data: data(path)}
  end

  def geojson(%{path: path}) do
    path.geojson
  end

  defp data(%Path{} = path) do
    %{
      id: path.id,
      from_longitude: path.from_longitude,
      from_latitude: path.from_latitude,
      to_longitude: path.to_longitude,
      to_latitude: path.to_latitude,
      geojson: path.geojson
    }
  end
end
