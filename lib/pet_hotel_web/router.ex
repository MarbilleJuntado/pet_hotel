defmodule PetHotelWeb.Router do
  use PetHotelWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :openapi do
    plug(OpenApiSpex.Plug.PutApiSpec, module: PetHotelWeb.ApiSpec)
  end

  scope "/api", PetHotelWeb do
    pipe_through :api

    resources "/pet-owner", PetOwnerController, except: [:new, :edit]

    get "/pet-owner/:id/pet",
        PetOwnerController,
        :pets

    resources "/pet", PetController, except: [:new, :edit]
  end

  scope "/" do
    get("/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi")
  end

  scope "/api" do
    pipe_through([:api, :openapi])

    get("/openapi", OpenApiSpex.Plug.RenderSpec, [])
  end
end
