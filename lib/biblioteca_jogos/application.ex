defmodule BibliotecaJogos.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BibliotecaJogosWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:biblioteca_jogos, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BibliotecaJogos.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BibliotecaJogos.Finch},
      # Start a worker by calling: BibliotecaJogos.Worker.start_link(arg)
      # {BibliotecaJogos.Worker, arg},
      # Start to serve requests, typically the last entry
      BibliotecaJogosWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BibliotecaJogos.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BibliotecaJogosWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
