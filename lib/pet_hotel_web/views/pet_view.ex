defmodule PetHotelWeb.PetView do
  use PetHotelWeb, :view
  alias PetHotelWeb.PetView

  def render("index.json", %{pet_page: %{entries: pets} = page}) do
    %{
      pets:
        Enum.map(
          pets,
          &Map.take(&1, [
            :id,
            :name,
            :pet_owner_id
          ])
        ),
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    }
  end

  def render("show.json", %{pet: pet}) do
    %{data: render_one(pet, PetView, "pet.json")}
  end

  def render("pet.json", %{pet: pet}) do
    %{id: pet.id, name: pet.name, pet_owner_id: pet.pet_owner_id}
  end
end
