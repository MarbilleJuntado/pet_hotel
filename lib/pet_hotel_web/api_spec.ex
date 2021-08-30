defmodule PetHotelWeb.ApiSpec do
  alias OpenApiSpex.{OpenApi, Server, Info, Paths}
  alias PetHotelWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        # Populate the Server info from a phoenix endpoint
        Endpoint
        |> Server.from_endpoint()
        |> Map.put(:url, build_url())
      ],
      info: %Info{
        title: "Pet Hotel",
        version: Application.get_env(:pet_hotel, :version)
      },
      # populate the paths from a phoenix router
      paths: Paths.from_router(Router),
      security: []
    }
    # discover request/response schemas from path specs
    |> OpenApiSpex.resolve_schema_modules()
  end

  defp build_url do
    struct_url = Endpoint.struct_url()

    if struct_url.port == 4000 do
      Endpoint.url()
    else
      "https://#{struct_url.host}"
    end
  end
end
