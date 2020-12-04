defmodule BlogWeb.PostView do
  use BlogWeb, :view

  alias Blog.Page.Post

  def post_url(conn, post = %Post{category: category, date: date}) do
    Routes.post_path(conn, :show, category, Date.to_string(date), post)
  end

  def markdown(code) do
    Earmark.as_html!(code)
  end
end
