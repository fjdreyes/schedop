defmodule Schedop.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes) do
      add :code, :integer, null: false
      add :name, :string, null: false
      add :section, :string, null: false
      add :description, :string
      add :units, :integer, null: false
      add :schedule, :string, null: false
      add :instructor, :string, null: false
      add :remarks, :string, null: false
      add :department, :string
      add :slots_total, :integer
      add :slots_available, :integer
      add :demand, :integer
      add :restrictions, :string
      add :term_id, references(:terms, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:classes, [:code])
    create index(:classes, [:term_id])
  end
end
