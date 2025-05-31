defmodule Schedop.Repo.Migrations.AddTimeBlocksToClasses do
  use Ecto.Migration

  def change do
    alter table(:classes) do
      add :time_blocks, {:array, :map}, null: false, default: []
    end
  end
end
