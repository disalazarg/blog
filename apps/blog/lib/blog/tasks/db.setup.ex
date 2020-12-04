defmodule Mix.Tasks.Db.Setup do
  @moduledoc """
  Setups the Cassandra persistence layer
  """

  use Mix.Task
  require Logger

  alias Blog.Repo

  @keyspace_stmt "create keyspace if not exists blog
    with replication = {'class': 'NetworkTopologyStrategy', 'replication_factor': 3}
    and durable_writes = true"

  @table_stmt "create table if not exists blog.posts (
    category text,
    date date,
    id text,
    title text,
    lead text,
    content text,
    primary key (category, date, id)
  )"

  @impl Mix.Task
  def run(_args) do
    with {:ok, _args} <- Application.ensure_all_started(:blog),
         {:ok, _void} <- Repo.exec(@keyspace_stmt),
         {:ok, _void} <- Repo.exec(@table_stmt) do
      Logger.info("Database initialized")
    else
      error ->
        Logger.error(inspect(error))
    end
  end
end
