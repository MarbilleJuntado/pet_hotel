defmodule PetHotelWeb.Schemas.PetOwners.PetOwnerParam do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Pet Owner Param",
    type: :object,
    properties: %{
      pet_owner: %Schema{
        type: :object,
        properties: %{
          name: %Schema{type: :string},
          email: %Schema{type: :string}
        }
      }
    }
  })
end
