defmodule Blog.Repo do
  @moduledoc """
  Context module for the ScyllaDB persistence layer
  """

  use GenServer

  def init(args) do
    {:ok, args}
  end

  def start_link(opts) do
    with {:ok, conn} <- Xandra.start_link(opts),
         {:ok, list} <- Xandra.prepare(conn, "SELECT * FROM blog.posts WHERE category = ?"),
         {:ok, get } <- Xandra.prepare(conn, "SELECT * FROM blog.posts WHERE category = ? AND date = ? AND id = ?") do

      GenServer.start_link(__MODULE__, %{conn: conn, list: list, get: get}, name: __MODULE__)
    end
  end

  def list(category), do: GenServer.call(__MODULE__, {:list, category})
  def get(category, date, id), do: GenServer.call(__MODULE__, {:get, category, date, id})

  def handle_call({:list, category}, _from, state = %{conn: conn, list: list}) do
    result = Xandra.execute(conn, list, [_category = category])

    {:reply, result, state}
  end

  def handle_call({:show, category, date, id}, _from, state = %{conn: conn, get: get}) do
    result = Xandra.execute(conn, get, [_category = category, _date = date, _id = id])

    {:reply, result, state}
  end
end
