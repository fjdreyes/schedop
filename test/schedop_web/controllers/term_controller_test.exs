defmodule SchedopWeb.TermControllerTest do
  use SchedopWeb.ConnCase

  import Schedop.TermsFixtures

  @create_attrs %{name: "some name", uid: 42}
  @update_attrs %{name: "some updated name", uid: 43}
  @invalid_attrs %{name: nil, uid: nil}

  describe "index" do
    test "lists all terms", %{conn: conn} do
      conn = get(conn, ~p"/terms")
      assert html_response(conn, 200) =~ "Listing Terms"
    end
  end

  describe "new term" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/terms/new")
      assert html_response(conn, 200) =~ "New Term"
    end
  end

  describe "create term" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/terms", term: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/terms/#{id}"

      conn = get(conn, ~p"/terms/#{id}")
      assert html_response(conn, 200) =~ "Term #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/terms", term: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Term"
    end
  end

  describe "edit term" do
    setup [:create_term]

    test "renders form for editing chosen term", %{conn: conn, term: term} do
      conn = get(conn, ~p"/terms/#{term}/edit")
      assert html_response(conn, 200) =~ "Edit Term"
    end
  end

  describe "update term" do
    setup [:create_term]

    test "redirects when data is valid", %{conn: conn, term: term} do
      conn = put(conn, ~p"/terms/#{term}", term: @update_attrs)
      assert redirected_to(conn) == ~p"/terms/#{term}"

      conn = get(conn, ~p"/terms/#{term}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, term: term} do
      conn = put(conn, ~p"/terms/#{term}", term: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Term"
    end
  end

  describe "delete term" do
    setup [:create_term]

    test "deletes chosen term", %{conn: conn, term: term} do
      conn = delete(conn, ~p"/terms/#{term}")
      assert redirected_to(conn) == ~p"/terms"

      assert_error_sent 404, fn ->
        get(conn, ~p"/terms/#{term}")
      end
    end
  end

  defp create_term(_) do
    term = term_fixture()
    %{term: term}
  end
end
