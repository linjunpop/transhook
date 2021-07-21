defmodule Transhook.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Transhook.Repo,
      # Start the Telemetry supervisor
      TranshookWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Transhook.PubSub},
      # Start the Endpoint (http/https)
      TranshookWeb.Endpoint,
      # Start a worker by calling: Transhook.Worker.start_link(arg)
      # {Transhook.Worker, arg}

      {Finch, name: TranshookFinch}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Transhook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TranshookWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
