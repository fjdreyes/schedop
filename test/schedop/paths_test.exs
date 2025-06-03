defmodule Schedop.PathsTest do
  use Schedop.DataCase

  alias Schedop.Paths

  describe "paths" do
    alias Schedop.Paths.Path

    import Schedop.PathsFixtures

    @invalid_attrs %{from_longitude: nil, from_latitude: nil, to_longitude: nil, to_latitude: nil, geojson: nil}

    test "list_paths/0 returns all paths" do
      path = path_fixture()
      assert Paths.list_paths() == [path]
    end

    test "get_path!/1 returns the path with given id" do
      path = path_fixture()
      assert Paths.get_path!(path.id) == path
    end

    test "create_path/1 with valid data creates a path" do
      valid_attrs = %{from_longitude: "some from_longitude", from_latitude: "some from_latitude", to_longitude: "some to_longitude", to_latitude: "some to_latitude", geojson: %{}}

      assert {:ok, %Path{} = path} = Paths.create_path(valid_attrs)
      assert path.from_longitude == "some from_longitude"
      assert path.from_latitude == "some from_latitude"
      assert path.to_longitude == "some to_longitude"
      assert path.to_latitude == "some to_latitude"
      assert path.geojson == %{}
    end

    test "create_path/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Paths.create_path(@invalid_attrs)
    end

    test "update_path/2 with valid data updates the path" do
      path = path_fixture()
      update_attrs = %{from_longitude: "some updated from_longitude", from_latitude: "some updated from_latitude", to_longitude: "some updated to_longitude", to_latitude: "some updated to_latitude", geojson: %{}}

      assert {:ok, %Path{} = path} = Paths.update_path(path, update_attrs)
      assert path.from_longitude == "some updated from_longitude"
      assert path.from_latitude == "some updated from_latitude"
      assert path.to_longitude == "some updated to_longitude"
      assert path.to_latitude == "some updated to_latitude"
      assert path.geojson == %{}
    end

    test "update_path/2 with invalid data returns error changeset" do
      path = path_fixture()
      assert {:error, %Ecto.Changeset{}} = Paths.update_path(path, @invalid_attrs)
      assert path == Paths.get_path!(path.id)
    end

    test "delete_path/1 deletes the path" do
      path = path_fixture()
      assert {:ok, %Path{}} = Paths.delete_path(path)
      assert_raise Ecto.NoResultsError, fn -> Paths.get_path!(path.id) end
    end

    test "change_path/1 returns a path changeset" do
      path = path_fixture()
      assert %Ecto.Changeset{} = Paths.change_path(path)
    end
  end
end
