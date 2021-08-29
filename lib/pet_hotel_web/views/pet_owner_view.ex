defmodule PetHotelWeb.PetOwnerView do
  use PetHotelWeb, :view
  alias PetHotelWeb.PetOwnerView

  def render("index.json", %{pet_owner_page: %{entries: pet_owners} = page}) do
    %{
      pet_owners: Enum.map(pet_owners, &Map.take(&1, [:id, :name, :email])),
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    }
  end

  def render("pets.json", %{pet_page: %{entries: pets} = page}) do
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

  def render("show.json", %{pet_owner: pet_owner}) do
    %{data: render_one(pet_owner, PetOwnerView, "pet_owner.json")}
  end

  def render("pet_owner.json", %{pet_owner: pet_owner}) do
    %{id: pet_owner.id, email: pet_owner.email, name: pet_owner.name}
  end
end
