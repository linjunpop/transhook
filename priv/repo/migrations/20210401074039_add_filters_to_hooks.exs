defmodule Transhook.Repo.Migrations.AddFiltersToHooks do
  use Ecto.Migration

  def change do
    alter table(:hooks) do
      add :hook_filters, {:array, :map}, default: []
    end
  end
end
