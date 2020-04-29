defmodule Transhook.Webhook.Dispatcher do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :http_method, :string, default: "post"
    field :content_type, :string, default: "application/json"
    field :payload_template, :string
    field :url, :string
  end

  @doc false
  def changeset(hook, attrs) do
    hook
    |> cast(attrs, [:http_method, :content_type, :payload_template, :url])
    |> validate_required([:http_method, :content_type, :payload_template, :url])
  end
end
