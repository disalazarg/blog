defmodule Blog.Repo do
  @moduledoc """
  Context module for the ScyllaDB persistence layer
  """

  use GenServer
  alias Blog.Page.Post

  def init(args) do
    {:ok, args}
  end

  def start_link(opts) do
    with {:ok, conn} <- Xandra.start_link(opts),
         {:ok, list} <- Xandra.prepare(conn, "SELECT * FROM blog.posts WHERE category = ?"),
         {:ok, get} <- Xandra.prepare(conn, "SELECT * FROM blog.posts WHERE category = ? AND date = ? AND id = ?") do
      GenServer.start_link(__MODULE__, %{conn: conn, list: list, get: get}, name: __MODULE__)
    end
  end

  def list(category), do: GenServer.call(__MODULE__, {:list, category})
  def get(category, date, id), do: GenServer.call(__MODULE__, {:get, category, date, id})
  def exec(query, args \\ []), do: GenServer.call(__MODULE__, {:exec, query, args})

  def handle_call({:list, category}, _from, state = %{conn: conn, list: list}) do
    with {:ok, result} <- Xandra.execute(conn, list, [_category = category]) do
      posts =
        result
        |> Enum.to_list()
        |> Enum.map(&parse_post/1)

      {:reply, {:ok, posts}, state}
    end
  end

  def handle_call({:get, category, date, id}, _from, state = %{conn: conn, get: get}) do
    with {:ok, date} <- Date.from_iso8601(date),
         {:ok, result} <- Xandra.execute(conn, get, [category, date, id]) do
      post =
        result
        |> Enum.to_list()
        |> List.first()
        |> parse_post()

      reply = if post, do: {:ok, post}, else: {:error, "not found"}

      {:reply, reply, state}
    end
  end

  def handle_call({:exec, query, args}, _from, state = %{conn: conn}) do
    result = Xandra.execute(conn, query, args)

    {:reply, result, state}
  end

  @spec parse_post(map) :: Post.t()
  defp parse_post(nil), do: nil

  defp parse_post(map) do
    data =
      map
      |> Enum.map(fn {k, v} -> {String.to_existing_atom(k), v} end)
      |> Enum.into(%{})

    struct(Post, data)
  end
end
