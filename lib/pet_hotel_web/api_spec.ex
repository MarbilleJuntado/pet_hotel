defmodule PetHotelWeb.ApiSpec do
  alias OpenApiSpex.{OpenApi, Server, Info, Paths}
  alias PetHotelWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    IO.puts "Endpoint url: "
    IO.inspect(Endpoint.url())

    IO.puts "Endpoint struct url: "
    IO.inspect(Endpoint.struct_url())

    %OpenApi{
      servers: [
        Endpoint
        |> Server.from_endpoint()
        |> Map.put(:url, Endpoint.url())
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
