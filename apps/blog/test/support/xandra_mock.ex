defmodule XandraMock do
  @moduledoc "Mock for Xandra, a Cassandra/Scylla DB client"

  use GenServer

  @sample %{
    "category" => "category",
    "id" => "id",
    "date" => ~D[2020-01-01],
    "title" => "title",
    "lead" => "lead",
    "content" => "content"
  }

  def init(args), do: {:ok, args}
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def prepare(_conn, _query), do: {:ok, nil}
  def execute(_conn, _list, [_category]), do: {:ok, [@sample]}
  def execute(_conn, _list, [_category, _date, "not-found"]), do: {:ok, []}
  def execute(_conn, _list, [_category, _date, _id]), do: {:ok, [@sample]}
  def execute(_conn, _list, _args), do: {:ok, nil}
end
