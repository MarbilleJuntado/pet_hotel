defmodule PetHotelWeb.PetOwnerView do
  use PetHotelWeb, :view
  alias PetHotelWeb.PetOwnerView

  def render("index.json", %{pet_owner: pet_owner}) do
    %{data: render_many(pet_owner, PetOwnerView, "pet_owner.json")}
  end

  def render("show.json", %{pet_owner: pet_owner}) do
    %{data: render_one(pet_owner, PetOwnerView, "pet_owner.json")}
  end

  def render("pet_owner.json", %{pet_owner: pet_owner}) do
    %{id: pet_owner.id, email: pet_owner.email, name: pet_owner.name}
  end
end
