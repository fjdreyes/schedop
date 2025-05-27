defmodule Schedop.Repo.Migrations.CreateSchedules do
  use Ecto.Migration

  def change do
    create table(:schedules) do
      add :name, :string, null: false
      add :subjects, {:array, :string}, null: false
      add :term_id, references(:terms, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:schedules, [:term_id])
  end
end
