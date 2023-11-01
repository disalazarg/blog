defmodule Blog.Page.Post do
  @moduledoc "Models a Post's data as it comes from Xandra"
  defstruct category: nil, date: nil, id: nil, title: nil, lead: nil, content: nil
end
