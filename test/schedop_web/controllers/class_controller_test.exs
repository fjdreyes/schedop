defmodule SchedopWeb.ClassControllerTest do
  use SchedopWeb.ConnCase

  import Schedop.ClassesFixtures

  @create_attrs %{code: 42, name: "some name", description: "some description", section: "some section", units: 42, schedule: "some schedule", instructor: "some instructor", remarks: "some remarks", department: "some department", slots_total: 42, slots_available: 42, demand: 42, restrictions: "some restrictions"}
  @update_attrs %{code: 43, name: "some updated name", description: "some updated description", section: "some updated section", units: 43, schedule: "some updated schedule", instructor: "some updated instructor", remarks: "some updated remarks", department: "some updated department", slots_total: 43, slots_available: 43, demand: 43, restrictions: "some updated restrictions"}
  @invalid_attrs %{code: nil, name: nil, description: nil, section: nil, units: nil, schedule: nil, instructor: nil, remarks: nil, department: nil, slots_total: nil, slots_available: nil, demand: nil, restrictions: nil}

  describe "index" do
    test "lists all classes", %{conn: conn} do
      conn = get(conn, ~p"/classes")
      assert html_response(conn, 200) =~ "Listing Classes"
    end
  end

  describe "new class" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/classes/new")
      assert html_response(conn, 200) =~ "New Class"
    end
  end

  describe "create class" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/classes", class: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/classes/#{id}"

      conn = get(conn, ~p"/classes/#{id}")
      assert html_response(conn, 200) =~ "Class #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/classes", class: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Class"
    end
  end

  describe "edit class" do
    setup [:create_class]

    test "renders form for editing chosen class", %{conn: conn, class: class} do
      conn = get(conn, ~p"/classes/#{class}/edit")
      assert html_response(conn, 200) =~ "Edit Class"
    end
  end

  describe "update class" do
    setup [:create_class]

    test "redirects when data is valid", %{conn: conn, class: class} do
      conn = put(conn, ~p"/classes/#{class}", class: @update_attrs)
      assert redirected_to(conn) == ~p"/classes/#{class}"

      conn = get(conn, ~p"/classes/#{class}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, class: class} do
      conn = put(conn, ~p"/classes/#{class}", class: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Class"
    end
  end

  describe "delete class" do
    setup [:create_class]

    test "deletes chosen class", %{conn: conn, class: class} do
      conn = delete(conn, ~p"/classes/#{class}")
      assert redirected_to(conn) == ~p"/classes"

      assert_error_sent 404, fn ->
        get(conn, ~p"/classes/#{class}")
      end
    end
  end

  defp create_class(_) do
    class = class_fixture()
    %{class: class}
  end
end
