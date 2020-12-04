defmodule BlogWeb.PageController do
  use BlogWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: Routes.post_path(conn, :index, "tech"))
  end
end
