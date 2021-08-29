defmodule PetHotelWeb.Schemas.Pets.PetParam do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Pet Param",
    type: :object,
    properties: %{
      pet: %Schema{
        type: :object,
        properties: %{
          name: %Schema{type: :string},
          pet_owner_id: %Schema{type: :integer}
        }
      }
    }
  })
end
