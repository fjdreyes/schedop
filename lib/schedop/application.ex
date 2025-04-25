defmodule Schedop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SchedopWeb.Telemetry,
      Schedop.Repo,
      {DNSCluster, query: Application.get_env(:schedop, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Schedop.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Schedop.Finch},
      # Start a worker by calling: Schedop.Worker.start_link(arg)
      # {Schedop.Worker, arg},
      # Start to serve requests, typically the last entry
      SchedopWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Schedop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SchedopWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
