defmodule PetHotelWeb.Schemas.Pets.Pet do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Pet",
    type: :object,
    properties: %{
      data: %Schema{
        type: :object,
        properties: %{
          id: %Schema{type: :integer},
          name: %Schema{type: :string},
          pet_owner_id: %Schema{type: :integer}
        }
      }
    }
  })
end
