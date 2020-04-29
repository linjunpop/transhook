defmodule Transhook.Webhook.Hook do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "hooks" do
    field :endpoint, :string, autogenerate: {Transhook.Webhook.EndpointGenerator, :generate, []}

    field :trans_template, :string

    embeds_one :dispatcher, Transhook.Webhook.Dispatcher
    embeds_one :responder, Transhook.Webhook.Responder

    timestamps()
  end

  @doc false
  def changeset(hook, attrs) do
    hook
    |> cast(attrs, [:trans_template])
    |> validate_required([:trans_template])
    |> cast_embed(:dispatcher)
    |> cast_embed(:responder)
  end
end
