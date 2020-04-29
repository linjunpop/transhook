defmodule Transhook.Webhook.Dispatcher do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :http_method, :string, default: "post"
    field :url, :string
  end

  @doc false
  def changeset(hook, attrs) do
    hook
    |> cast(attrs, [:http_method, :url])
    |> validate_required([:http_method, :url])
  end
end
