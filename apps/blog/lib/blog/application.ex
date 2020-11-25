defmodule Blog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: Blog.PubSub},
      # Start a worker by calling: Blog.Worker.start_link(arg)
      # {Blog.Worker, arg}
      {Blog.Repo, Application.fetch_env!(:blog, Blog.Repo)}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Blog.Supervisor)
  end
end
