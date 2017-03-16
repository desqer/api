defmodule Desqer.Router do
  use Desqer.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Desqer.Plug.Locale, "pt_BR"
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated, handler: Desqer.GuardianHandler
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureResource, handler: Desqer.GuardianHandler
  end

  scope "/", Desqer do
    pipe_through :api

    get "/users/:phone", UserController, :preview
    post "/users", UserController, :create

    post "/sessions", SessionController, :create
  end

  scope "/", Desqer do
    pipe_through [:api, :api_auth]

    get "/users", UserController, :show
    put "/users", UserController, :update
    delete "/users", UserController, :delete

    delete "/sessions", SessionController, :delete

    post "/professionals", ProfessionalController, :create

    get "/services", ServiceController, :index
    post "/services", ServiceController, :create
    put "/services/:id", ServiceController, :update
    delete "/services/:id", ServiceController, :delete

    get "/appointments", AppointmentController, :index
    post "/appointments", AppointmentController, :create
    put "/appointments/:id", AppointmentController, :update
  end
end
