defmodule Transhook.Repo.Migrations.CreatePapertrails do
  use Ecto.Migration

  def change do
    create table(:papertrails, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :request_data, :map
      add :hook_id, references(:hooks, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:papertrails, [:hook_id])
  end
end
