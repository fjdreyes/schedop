defmodule SchedopWeb.ClassController do
  use SchedopWeb, :controller

  alias Schedop.Classes
  alias Schedop.Classes.Class

  def index(conn, _params) do
    classes = Classes.list_classes()
    render(conn, :index, classes: classes)
  end

  def new(conn, _params) do
    changeset = Classes.change_class(%Class{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"class" => class_params}) do
    case Classes.create_class(class_params) do
      {:ok, class} ->
        conn
        |> put_flash(:info, "Class created successfully.")
        |> redirect(to: ~p"/classes/#{class}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    class = Classes.get_class!(id)
    render(conn, :show, class: class)
  end

  def edit(conn, %{"id" => id}) do
    class = Classes.get_class!(id)
    changeset = Classes.change_class(class)
    render(conn, :edit, class: class, changeset: changeset)
  end

  def update(conn, %{"id" => id, "class" => class_params}) do
    class = Classes.get_class!(id)

    case Classes.update_class(class, class_params) do
      {:ok, class} ->
        conn
        |> put_flash(:info, "Class updated successfully.")
        |> redirect(to: ~p"/classes/#{class}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, class: class, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    class = Classes.get_class!(id)
    {:ok, _class} = Classes.delete_class(class)

    conn
    |> put_flash(:info, "Class deleted successfully.")
    |> redirect(to: ~p"/classes")
  end
end
