defmodule Transhook.Repo do
  use Ecto.Repo,
    otp_app: :transhook,
    adapter: Ecto.Adapters.Postgres
end
