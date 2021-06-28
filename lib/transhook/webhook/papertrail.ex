defmodule Transhook.Webhook.Papertrail do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "papertrails" do
    field :request_data, :map
    field :hook_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(papertrail, attrs) do
    papertrail
    |> cast(attrs, [:request_data, :hook_id])
    |> validate_required([:request_data, :hook_id])
    |> unique_constraint(:hook_id)
  end
end
