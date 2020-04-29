defmodule Transhook.Webhook.Responder do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :payload, :string, default: "OK"
    field :content_type, :string, default: "plain/text"
    field :status_code, :integer, default: 200
  end

  @doc false
  def changeset(hook, attrs) do
    hook
    |> cast(attrs, [:payload, :content_type, :status_code])
    |> validate_required([:payload, :content_type, :status_code])
  end
end
