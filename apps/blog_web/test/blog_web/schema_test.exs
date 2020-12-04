defmodule BlogWeb.SchemaTest do
  use BlogWeb.ConnCase

  describe "on posts model" do
    test "posts endpoint returns a list of posts", %{conn: conn} do
      q = "query posts { posts(category: \"test\") { category date id }}"

      conn = post conn, "/blog/api/graphql", ql_query(q, "posts")
      json = json_response(conn, 200)["data"]["posts"]

      assert is_list(json)
      refute Enum.empty?(json)
    end

    test "post endpoint can query a single post", %{conn: conn} do
      q = "query post($category: String!, $date: String!, $id: String!)
        { post(category: $category, date: $date, id: $id) { category date id }}"

      vars = %{category: "test", date: "2020-01-01", id: "test-post"}
      conn = post conn, "/blog/api/graphql", ql_query(q, "post", vars)
      json = json_response(conn, 200)["data"]["post"]

      assert is_map(json)
    end
  end

  defp ql_query(query, name, vars \\ %{}) do
    %{
      "operationName" => name,
      "query" => query,
      "variables" => vars
    }
  end
end
