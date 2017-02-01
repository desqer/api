defmodule Desqer.Router do
  use Desqer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Desqer do
    pipe_through :api
  end
end
