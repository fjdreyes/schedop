defmodule Schedop.Classes do
  @moduledoc """
  The Classes context.
  """

  import Ecto.Query, warn: false
  alias Schedop.Repo

  alias Schedop.Classes.Class

  @doc """
  Returns the list of classes.

  ## Examples

      iex> list_classes()
      [%Class{}, ...]

  """
  def list_classes do
    Repo.all(Class)
  end

  def list_classes_by_name(name) do
    Class
    |> where([c], fragment("LOWER(?)", c.name) == ^name)
    |> Repo.all()
  end

  @doc """
  Gets a single class.

  Raises `Ecto.NoResultsError` if the Class does not exist.

  ## Examples

      iex> get_class!(123)
      %Class{}

      iex> get_class!(456)
      ** (Ecto.NoResultsError)

  """
  def get_class!(id), do: Repo.get!(Class, id) |> Repo.preload(:term)

  @doc """
  Creates a class.

  ## Examples

      iex> create_class(%{field: value})
      {:ok, %Class{}}

      iex> create_class(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_class(attrs \\ %{}) do
    %Class{}
    |> Class.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a class.

  ## Examples

      iex> update_class(class, %{field: new_value})
      {:ok, %Class{}}

      iex> update_class(class, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_class(%Class{} = class, attrs) do
    class
    |> Class.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a class.

  ## Examples

      iex> delete_class(class)
      {:ok, %Class{}}

      iex> delete_class(class)
      {:error, %Ecto.Changeset{}}

  """
  def delete_class(%Class{} = class) do
    Repo.delete(class)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking class changes.

  ## Examples

      iex> change_class(class)
      %Ecto.Changeset{data: %Class{}}

  """
  def change_class(%Class{} = class, attrs \\ %{}) do
    Class.changeset(class, attrs)
  end

  def populate_classes(subjects, term) do
    subjects
    |> Enum.map(&retrieve_classes(&1, term))
    |> List.flatten()
    |> Enum.map(&create_class/1)
  end

  defp retrieve_classes(subject, term) do
    subject_param =
      subject
      |> String.split()
      |> Enum.take(2)
      |> Enum.join(" ")
      |> URI.encode()

    classes_url = "https://crs.upd.edu.ph/schedule/#{term.uid}/#{subject_param}"

    Req.get!(classes_url).body
    |> Floki.parse_document!()
    |> Floki.find("#tbl_schedule > tbody > tr")
    |> parse_classes(term.id)
    |> filter_classes(subject)
  end

  defp parse_classes(rows, term_id) do
    case Floki.find(rows, "td:fl-contains('No classes to display')") do
      [] ->
        Enum.map(rows, &parse_class_row(&1, term_id))

      _ ->
        []
    end
  end

  defp parse_class_row(row, term_id) do
    code = row |> Floki.find("td:nth-child(1)") |> Floki.text()

    [class | a_description] =
      row
      |> Floki.find("td:nth-child(2)")
      |> Floki.text()
      |> String.split("\n")

    {a_name, a_section} = class |> String.split() |> Enum.split(-1)

    name = Enum.join(a_name, " ")
    section = List.first(a_section)
    description = List.first(a_description)

    units =
      row
      |> Floki.find("td:nth-child(3)")
      |> Floki.text()
      |> String.to_float()
      |> trunc()

    [schedule, instructor, remarks] =
      row
      |> Floki.find("td:nth-child(4)")
      |> Floki.text()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)

    department =
      row
      |> Floki.find("td:nth-child(5)")
      |> Floki.text()
      |> String.trim()

    restrictions_index = row |> Floki.children() |> length()

    {slots_available, slots_total, demand} =
      case restrictions_index do
        8 ->
          [slots_available, slots_total] =
            row
            |> Floki.find("td:nth-child(6)")
            |> Floki.text()
            |> String.split("/")
            |> Enum.map(&String.trim/1)
            |> Enum.map(fn x ->
              case Integer.parse(x) do
                {int, _} -> int
                :error -> nil
              end
            end)

          demand =
            row
            |> Floki.find("td:nth-child(7)")
            |> Floki.text()
            |> String.to_integer()

          {slots_available, slots_total, demand}

        _ ->
          {nil, nil, nil}
      end

    restrictions =
      row
      |> Floki.find("td:nth-child(#{restrictions_index})")
      |> Floki.text()

    %{
      code: code,
      name: name,
      section: section,
      description: description,
      units: units,
      schedule: schedule,
      instructor: instructor,
      remarks: remarks,
      department: department,
      slots_available: slots_available,
      slots_total: slots_total,
      demand: demand,
      restrictions: restrictions,
      term_id: term_id
    }
  end

  defp filter_classes(classes, subject) do
    Enum.filter(classes, fn class ->
      subject_length = subject |> String.split() |> length()

      class_name =
        class.name
        |> String.downcase()
        |> String.split()
        |> Enum.take(subject_length)
        |> Enum.join(" ")

      subject == class_name
    end)
  end
end
