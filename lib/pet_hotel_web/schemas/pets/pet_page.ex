defmodule PetHotelWeb.Schemas.Pets.PetPage do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Pet Page",
    type: :object,
    properties: %{
      pets: %Schema{
        type: :array,
        items: %Schema{
          type: :object,
          properties: %{
            id: %Schema{type: :integer},
            name: %Schema{type: :string},
            pet_owner_id: %Schema{type: :integer}
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
