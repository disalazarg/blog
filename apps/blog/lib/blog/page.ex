defmodule Blog.Page do
  @moduledoc """
  Context module for Page functions
  """

  alias Blog.Repo

  def list_posts(category \\ "tech") do
    Repo.list(category)
  end

  def get_post(category, date, id) do
    Repo.get(category, date, id)
  end
end
