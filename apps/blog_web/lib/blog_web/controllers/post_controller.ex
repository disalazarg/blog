defmodule BlogWeb.PostController do
  use BlogWeb, :controller

  alias Blog.Page

  def index(conn, params) do
    with category <- Map.get(params, "category", "test"),
         {:ok, posts} <- Page.list_posts(category) do
      render(conn, "index.html", posts: posts)
    end
  end

  def show(conn, %{"category" => category, "date" => date, "id" => id}) do
    with {:ok, post} <- Page.get_post(category, date, id) do
      render(conn, "show.html", post: post)
    end
  end
end
