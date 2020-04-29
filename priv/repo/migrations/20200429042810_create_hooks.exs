defmodule Transhook.Repo.Migrations.CreateHooks do
  use Ecto.Migration

  def change do
    create table(:hooks, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :endpoint, :string, null: false
      add :name, :string, null: false
      add :dispatcher, :map
      add :responder, :map

      timestamps()
    end
  end
end
