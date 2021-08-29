defmodule PetHotelWeb.Schemas.PetOwners.PetOwner do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Pet Owner",
    type: :object,
    properties: %{
      data: %Schema{
        type: :object,
        properties: %{
          id: %Schema{type: :integer},
          name: %Schema{type: :string},
          email: %Schema{type: :string}
        }
      }
    }
  })
end
