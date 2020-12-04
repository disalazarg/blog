defmodule BlogWeb.Schema do
  @moduledoc """
  GraphQL Schema for the Blog API
  """

  use Absinthe.Schema
  alias Blog.Page

  object :post do
    field(:category, non_null(:string))
    field(:date, non_null(:string))
    field(:id, non_null(:string))
    field(:title, :string)
    field(:lead, :string)
    field(:content, :string)
  end

  query do
    @desc "Get a list of posts within a category"
    field :posts, list_of(:post) do
      arg(:category, non_null(:string))

      resolve(fn %{category: category}, _ctx ->
        Page.list_posts(category)
      end)
    end

    @desc "Get a given post"
    field :post, :post do
      arg(:category, non_null(:string))
      arg(:date, non_null(:string))
      arg(:id, non_null(:string))

      resolve(fn %{category: category, date: date, id: id}, _ctx ->
        Page.get_post(category, date, id)
      end)
    end
  end
end
