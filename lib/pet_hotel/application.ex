defmodule PetHotel.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PetHotel.Repo,
      # Start the Telemetry supervisor
      PetHotelWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PetHotel.PubSub},
      # Start the Endpoint (http/https)
      PetHotelWeb.Endpoint
      # Start a worker by calling: PetHotel.Worker.start_link(arg)
      # {PetHotel.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PetHotel.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PetHotelWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
