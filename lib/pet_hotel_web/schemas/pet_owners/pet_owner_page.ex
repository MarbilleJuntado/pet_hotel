defmodule PetHotelWeb.Schemas.PetOwners.PetOwnerPage do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Pet Owner Page",
    type: :object,
    properties: %{
      pet_owners: %Schema{
        type: :array,
        items: %Schema{
          type: :object,
          properties: %{
            id: %Schema{type: :integer},
            name: %Schema{type: :string},
            email: %Schema{type: :string}
          }
        }
      },
      page_number: %Schema{type: :integer},
      page_size: %Schema{type: :integer},
      total_pages: %Schema{type: :integer},
      total_entries: %Schema{type: :integer}
    }
  })
end
