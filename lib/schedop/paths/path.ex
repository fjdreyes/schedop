defmodule Schedop.Paths.Path do
  use Ecto.Schema
  import Ecto.Changeset

  schema "paths" do
    field :from_longitude, :string
    field :from_latitude, :string
    field :to_longitude, :string
    field :to_latitude, :string
    field :geojson, :map

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(path, attrs) do
    path
    |> cast(attrs, [:from_longitude, :from_latitude, :to_longitude, :to_latitude, :geojson])
    |> validate_required([:from_longitude, :from_latitude, :to_longitude, :to_latitude])
  end
end
