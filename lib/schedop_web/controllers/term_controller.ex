defmodule SchedopWeb.TermController do
  use SchedopWeb, :controller

  alias Schedop.Terms
  alias Schedop.Terms.Term

  def index(conn, _params) do
    terms = Terms.list_terms()
    render(conn, :index, terms: terms)
  end

  def new(conn, _params) do
    changeset = Terms.change_term(%Term{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"term" => term_params}) do
    case Terms.create_term(term_params) do
      {:ok, term} ->
        conn
        |> put_flash(:info, "Term created successfully.")
        |> redirect(to: ~p"/terms/#{term}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    term = Terms.get_term!(id)
    render(conn, :show, term: term)
  end

  def edit(conn, %{"id" => id}) do
    term = Terms.get_term!(id)
    changeset = Terms.change_term(term)
    render(conn, :edit, term: term, changeset: changeset)
  end

  def update(conn, %{"id" => id, "term" => term_params}) do
    term = Terms.get_term!(id)

    case Terms.update_term(term, term_params) do
      {:ok, term} ->
        conn
        |> put_flash(:info, "Term updated successfully.")
        |> redirect(to: ~p"/terms/#{term}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, term: term, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    term = Terms.get_term!(id)
    {:ok, _term} = Terms.delete_term(term)

    conn
    |> put_flash(:info, "Term deleted successfully.")
    |> redirect(to: ~p"/terms")
  end
end
