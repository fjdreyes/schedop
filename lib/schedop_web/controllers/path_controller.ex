defmodule SchedopWeb.PathController do
  use SchedopWeb, :controller

  alias Schedop.Paths
  alias Schedop.Paths.Path

  action_fallback SchedopWeb.FallbackController

  def index(conn, _params) do
    paths = Paths.list_paths()
    render(conn, :index, paths: paths)
  end

  def create(conn, %{"path" => path_params}) do
    with {:ok, %Path{} = path} <- Paths.create_path(path_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/paths/#{path}")
      |> render(:show, path: path)
    end
  end

  def show(conn, %{"id" => id}) do
    path = Paths.get_path!(id)
    render(conn, :show, path: path)
  end

  def update(conn, %{"id" => id, "path" => path_params}) do
    path = Paths.get_path!(id)

    with {:ok, %Path{} = path} <- Paths.update_path(path, path_params) do
      render(conn, :show, path: path)
    end
  end

  def delete(conn, %{"id" => id}) do
    path = Paths.get_path!(id)

    with {:ok, %Path{}} <- Paths.delete_path(path) do
      send_resp(conn, :no_content, "")
    end
  end

  def geojson(conn, %{
        "from_longitude" => from_longitude,
        "from_latitude" => from_latitude,
        "to_longitude" => to_longitude,
        "to_latitude" => to_latitude
      }) do
    with {:ok, %Path{} = path} <-
           Paths.get_path_by_longitude_latitude(
             from_longitude,
             from_latitude,
             to_longitude,
             to_latitude
           ) do
      render(conn, :geojson, path: path)
    end
  end
end
