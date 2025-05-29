defmodule Schedop.Classes.Class do
  use Ecto.Schema
  import Ecto.Changeset

  schema "classes" do
    field :code, :integer
    field :name, :string
    field :section, :string
    field :description, :string
    field :units, :integer
    field :schedule, :string
    field :instructor, :string
    field :remarks, :string
    field :department, :string
    field :slots_total, :integer
    field :slots_available, :integer
    field :demand, :integer
    field :restrictions, :string
    belongs_to :term, Schedop.Terms.Term

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [
      :code,
      :name,
      :section,
      :description,
      :units,
      :schedule,
      :instructor,
      :remarks,
      :department,
      :slots_total,
      :slots_available,
      :demand,
      :restrictions,
      :term_id
    ])
    |> validate_required([
      :code,
      :name,
      :section,
      :units,
      :schedule,
      :instructor,
      :remarks,
      :term_id
    ])
    |> unique_constraint(:code)
  end
end
