defmodule Transhook.Webhook.HookFilter do
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_operators ["is"]

  embedded_schema do
    field :query, :string
    field :operator, :string, default: "is"
    field :value, :string
  end

  @doc false
  def changeset(hook, attrs) do
    hook
    |> cast(attrs, [:query, :operator, :value])
    |> validate_required([:query, :operator, :value])
    |> validate_inclusion(:operator, @allowed_operators)
  end
end
