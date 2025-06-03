defmodule Schedop.Paths do
  @moduledoc """
  The Paths context.
  """

  import Ecto.Query, warn: false
  alias Schedop.Repo

  alias Schedop.Paths.Path

  @doc """
  Returns the list of paths.

  ## Examples

      iex> list_paths()
      [%Path{}, ...]

  """
  def list_paths do
    Repo.all(Path)
  end

  @doc """
  Gets a single path.

  Raises `Ecto.NoResultsError` if the Path does not exist.

  ## Examples

      iex> get_path!(123)
      %Path{}

      iex> get_path!(456)
      ** (Ecto.NoResultsError)

  """
  def get_path!(id), do: Repo.get!(Path, id)

  def get_path_by_longitude_latitude(from_longitude, from_latitude, to_longitude, to_latitude) do
    case Repo.get_by(Path,
           from_longitude: from_longitude,
           from_latitude: from_latitude,
           to_longitude: to_longitude,
           to_latitude: to_latitude
         ) do
      nil ->
        retrieve_path(from_longitude, from_latitude, to_longitude, to_latitude)

      path ->
        {:ok, path}
    end
  end

  @doc """
  Creates a path.

  ## Examples

      iex> create_path(%{field: value})
      {:ok, %Path{}}

      iex> create_path(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_path(attrs \\ %{}) do
    %Path{}
    |> Path.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a path.

  ## Examples

      iex> update_path(path, %{field: new_value})
      {:ok, %Path{}}

      iex> update_path(path, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_path(%Path{} = path, attrs) do
    path
    |> Path.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a path.

  ## Examples

      iex> delete_path(path)
      {:ok, %Path{}}

      iex> delete_path(path)
      {:error, %Ecto.Changeset{}}

  """
  def delete_path(%Path{} = path) do
    Repo.delete(path)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking path changes.

  ## Examples

      iex> change_path(path)
      %Ecto.Changeset{data: %Path{}}

  """
  def change_path(%Path{} = path, attrs \\ %{}) do
    Path.changeset(path, attrs)
  end

  defp retrieve_path(from_longitude, from_latitude, to_longitude, to_latitude) do
    openrouteservice_url = Application.get_env(:schedop, :openrouteservice_url)
    openrouteservice_api_key = Application.get_env(:schedop, :openrouteservice_api_key)

    body = %{
      coordinates: [[from_longitude, from_latitude], [to_longitude, to_latitude]],
      instructions: false,
      geometry_simplify: true
    }

    headers = [
      {"Accept", "*/*"},
      {"Authorization", openrouteservice_api_key},
      {"Content-Type", "application/json"}
    ]

    case Req.post(openrouteservice_url, json: body, headers: headers) do
      {:ok, resp} when resp.status == 200 ->
        create_path(%{
          from_longitude: from_longitude,
          from_latitude: from_latitude,
          to_longitude: to_longitude,
          to_latitude: to_latitude,
          geojson: resp.body
        })

      error ->
        {:error, error}
    end
  end
end
