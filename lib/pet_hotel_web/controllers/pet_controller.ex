defmodule PetHotelWeb.PetController do
  use PetHotelWeb, :controller

  alias PetHotel.Pets
  alias PetHotel.Pets.Pet

  action_fallback PetHotelWeb.FallbackController

  def index(conn, params) do
    page = Pets.list_pet(params)
    render(conn, "index.json", pet_page: page)
  end

  def create(conn, %{"pet" => pet_params}) do
    with {:ok, %Pet{} = pet} <- Pets.create_pet(pet_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.pet_path(conn, :show, pet))
      |> render("show.json", pet: pet)
    end
  end

  def show(conn, %{"id" => id}) do
    pet = Pets.get_pet!(id)
    render(conn, "show.json", pet: pet)
  end

  def update(conn, %{"id" => id, "pet" => pet_params}) do
    pet = Pets.get_pet!(id)

    with {:ok, %Pet{} = pet} <- Pets.update_pet(pet, pet_params) do
      render(conn, "show.json", pet: pet)
    end
  end

  def delete(conn, %{"id" => id}) do
    pet = Pets.get_pet!(id)

    with {:ok, %Pet{}} <- Pets.delete_pet(pet) do
      send_resp(conn, :no_content, "")
    end
  end
end
