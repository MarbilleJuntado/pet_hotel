defmodule PetHotelWeb.PetView do
  use PetHotelWeb, :view
  alias PetHotelWeb.PetView

  def render("index.json", %{pet: pet}) do
    %{data: render_many(pet, PetView, "pet.json")}
  end

  def render("show.json", %{pet: pet}) do
    %{data: render_one(pet, PetView, "pet.json")}
  end

  def render("pet.json", %{pet: pet}) do
    %{id: pet.id,
      name: pet.name}
  end
end
