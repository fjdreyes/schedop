defmodule SchedopWeb.PathControllerTest do
  use SchedopWeb.ConnCase

  import Schedop.PathsFixtures

  alias Schedop.Paths.Path

  @create_attrs %{
    from_longitude: "some from_longitude",
    from_latitude: "some from_latitude",
    to_longitude: "some to_longitude",
    to_latitude: "some to_latitude",
    geojson: %{}
  }
  @update_attrs %{
    from_longitude: "some updated from_longitude",
    from_latitude: "some updated from_latitude",
    to_longitude: "some updated to_longitude",
    to_latitude: "some updated to_latitude",
    geojson: %{}
  }
  @invalid_attrs %{from_longitude: nil, from_latitude: nil, to_longitude: nil, to_latitude: nil, geojson: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all paths", %{conn: conn} do
      conn = get(conn, ~p"/api/paths")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create path" do
    test "renders path when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/paths", path: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/paths/#{id}")

      assert %{
               "id" => ^id,
               "from_latitude" => "some from_latitude",
               "from_longitude" => "some from_longitude",
               "geojson" => %{},
               "to_latitude" => "some to_latitude",
               "to_longitude" => "some to_longitude"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/paths", path: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update path" do
    setup [:create_path]

    test "renders path when data is valid", %{conn: conn, path: %Path{id: id} = path} do
      conn = put(conn, ~p"/api/paths/#{path}", path: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/paths/#{id}")

      assert %{
               "id" => ^id,
               "from_latitude" => "some updated from_latitude",
               "from_longitude" => "some updated from_longitude",
               "geojson" => %{},
               "to_latitude" => "some updated to_latitude",
               "to_longitude" => "some updated to_longitude"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, path: path} do
      conn = put(conn, ~p"/api/paths/#{path}", path: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete path" do
    setup [:create_path]

    test "deletes chosen path", %{conn: conn, path: path} do
      conn = delete(conn, ~p"/api/paths/#{path}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/paths/#{path}")
      end
    end
  end

  defp create_path(_) do
    path = path_fixture()
    %{path: path}
  end
end
