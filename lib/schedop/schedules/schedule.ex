defmodule Schedop.Schedules.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "schedules" do
    field :name, :string
    field :subjects, {:array, :string}
    belongs_to :term, Schedop.Terms.Term

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(schedule, attrs) do
    schedule
    |> cast(attrs, [:name, :subjects, :term_id])
    |> validate_required([:name, :subjects, :term_id])
    |> validate_length(:subjects, min: 2)
  end
end
