defmodule Desqer.Router do
  use Desqer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Desqer do
    pipe_through :api

    resources "/users", UserController, only: [:show, :create, :update, :delete]
  end
end
