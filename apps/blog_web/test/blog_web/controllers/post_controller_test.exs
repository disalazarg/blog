defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase

  describe "on /blog scope" do
    test "GET / redirects to a default category", %{conn: conn} do
      conn = get(conn, "/blog")

      assert redirected_to(conn, 302)
    end

    test "GET /:category works for a test category", %{conn: conn} do
      conn = get(conn, "/blog/test")

      assert html_response(conn, 200)
    end

    test "GET /:category works for a non-existent category", %{conn: conn} do
      conn = get(conn, "/blog/non-existent")

      assert html_response(conn, 200)
    end
  end
end
