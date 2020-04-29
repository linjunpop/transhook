defmodule Transhook.Webhook.Hook do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "hooks" do
    field :name, :string

    field :endpoint, :string, autogenerate: {Transhook.Webhook.EndpointGenerator, :generate, []}

    embeds_one :dispatcher, Transhook.Webhook.Dispatcher, on_replace: :update
    embeds_one :responder, Transhook.Webhook.Responder, on_replace: :update

    timestamps()
  end

  @doc false
  def changeset(hook, attrs) do
    hook
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> cast_embed(:dispatcher)
    |> cast_embed(:responder)
  end
end
