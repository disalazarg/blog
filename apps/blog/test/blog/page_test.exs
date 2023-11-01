defmodule Blog.PageTest do
  use ExUnit.Case

  alias Blog.Page

  describe "posts" do
    test "list_posts/1 can query the DB" do
      assert {:ok, res} = Page.list_posts()
      assert is_list(res)
    end

    test "get_post/3 can query the DB" do
      assert {:ok, _res} = Page.get_post("test", "2020-01-01", "test-post")
    end

    test "get_post/3 deals correcly with missing data" do
      assert {:error, "not found"} = Page.get_post("test", "2010-01-01", "not-found")
    end
  end
end
