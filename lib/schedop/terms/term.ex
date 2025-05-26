defmodule Schedop.Terms.Term do
  use Ecto.Schema
  import Ecto.Changeset

  schema "terms" do
    field :name, :string
    field :uid, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(term, attrs) do
    term
    |> cast(attrs, [:uid, :name])
    |> validate_required([:uid, :name])
    |> unique_constraint(:uid)
  end
end
