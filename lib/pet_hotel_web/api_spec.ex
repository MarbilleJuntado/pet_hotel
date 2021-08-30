defmodule PetHotelWeb.ApiSpec do
  alias OpenApiSpex.{OpenApi, Server, Info, Paths}
  alias PetHotelWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        # Populate the Server info from a phoenix endpoint
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "PetHotel Service",
        version: Application.get_env(:pet_hotel, :version)
      },
      # populate the paths from a phoenix router
      paths: Paths.from_router(Router),
      security: []
    }
    # discover request/response schemas from path specs
    |> OpenApiSpex.resolve_schema_modules()
  end
end
