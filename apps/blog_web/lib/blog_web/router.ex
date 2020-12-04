defmodule BlogWeb.Router do
  use BlogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/blog" do
    scope "/api" do
      pipe_through :api

      forward "/graphql", Absinthe.Plug.GraphiQL, schema: BlogWeb.Schema
    end

    scope "/", BlogWeb do
      pipe_through :browser
      get "/", PageController, :index

      get "/:category", PostController, :index, as: :post
      get "/:category/:date/:id", PostController, :show, as: :post
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", BlogWeb do
  #   pipe_through :api
  # end
end
