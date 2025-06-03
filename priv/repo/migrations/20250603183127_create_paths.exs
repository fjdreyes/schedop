defmodule Schedop.Repo.Migrations.CreatePaths do
  use Ecto.Migration

  def change do
    create table(:paths) do
      add :from_longitude, :string, null: false
      add :from_latitude, :string, null: false
      add :to_longitude, :string, null: false
      add :to_latitude, :string, null: false
      add :geojson, :map, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:paths, [:from_longitude, :from_latitude, :to_longitude, :to_latitude],
             name: "paths_from_to_longitude_latitude_index"
           )
  end
end
