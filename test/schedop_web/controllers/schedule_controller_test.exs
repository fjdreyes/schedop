defmodule SchedopWeb.ScheduleControllerTest do
  use SchedopWeb.ConnCase

  import Schedop.SchedulesFixtures

  @create_attrs %{name: "some name", subjects: ["option1", "option2"]}
  @update_attrs %{name: "some updated name", subjects: ["option1"]}
  @invalid_attrs %{name: nil, subjects: nil}

  describe "index" do
    test "lists all schedules", %{conn: conn} do
      conn = get(conn, ~p"/schedules")
      assert html_response(conn, 200) =~ "Listing Schedules"
    end
  end

  describe "new schedule" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/schedules/new")
      assert html_response(conn, 200) =~ "New Schedule"
    end
  end

  describe "create schedule" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/schedules", schedule: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/schedules/#{id}"

      conn = get(conn, ~p"/schedules/#{id}")
      assert html_response(conn, 200) =~ "Schedule #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/schedules", schedule: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Schedule"
    end
  end

  describe "edit schedule" do
    setup [:create_schedule]

    test "renders form for editing chosen schedule", %{conn: conn, schedule: schedule} do
      conn = get(conn, ~p"/schedules/#{schedule}/edit")
      assert html_response(conn, 200) =~ "Edit Schedule"
    end
  end

  describe "update schedule" do
    setup [:create_schedule]

    test "redirects when data is valid", %{conn: conn, schedule: schedule} do
      conn = put(conn, ~p"/schedules/#{schedule}", schedule: @update_attrs)
      assert redirected_to(conn) == ~p"/schedules/#{schedule}"

      conn = get(conn, ~p"/schedules/#{schedule}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, schedule: schedule} do
      conn = put(conn, ~p"/schedules/#{schedule}", schedule: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Schedule"
    end
  end

  describe "delete schedule" do
    setup [:create_schedule]

    test "deletes chosen schedule", %{conn: conn, schedule: schedule} do
      conn = delete(conn, ~p"/schedules/#{schedule}")
      assert redirected_to(conn) == ~p"/schedules"

      assert_error_sent 404, fn ->
        get(conn, ~p"/schedules/#{schedule}")
      end
    end
  end

  defp create_schedule(_) do
    schedule = schedule_fixture()
    %{schedule: schedule}
  end
end
