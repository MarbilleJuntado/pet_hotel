defmodule PetHotelWeb.PetOwnerController do
  use PetHotelWeb, :controller

  alias PetHotel.PetOwners
  alias PetHotel.Pets
  alias PetHotel.PetOwners.PetOwner

  action_fallback PetHotelWeb.FallbackController

  def index(conn, params) do
    page = PetOwners.list_pet_owner(params)
    render(conn, "index.json", pet_owner_page: page)
  end

  def pets(conn, %{"id" => id} = params) do
    pet_owner = PetOwners.get_pet_owner!(id)
    page =
      params
      |> Map.delete("id")
      |> Map.put("pet_owner_id", pet_owner.id)
      |> Pets.list_pet()

    render(conn, "pets.json", pet_page: page)
  end

  def create(conn, %{"pet_owner" => pet_owner_params}) do
    with {:ok, %PetOwner{} = pet_owner} <- PetOwners.create_pet_owner(pet_owner_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.pet_owner_path(conn, :show, pet_owner))
      |> render("show.json", pet_owner: pet_owner)
    end
  end

  def show(conn, %{"id" => id}) do
    pet_owner = PetOwners.get_pet_owner!(id)
    render(conn, "show.json", pet_owner: pet_owner)
  end

  def update(conn, %{"id" => id, "pet_owner" => pet_owner_params}) do
    pet_owner = PetOwners.get_pet_owner!(id)

    with {:ok, %PetOwner{} = pet_owner} <- PetOwners.update_pet_owner(pet_owner, pet_owner_params) do
      render(conn, "show.json", pet_owner: pet_owner)
    end
  end

  def delete(conn, %{"id" => id}) do
    pet_owner = PetOwners.get_pet_owner!(id)

    with {:ok, %PetOwner{}} <- PetOwners.delete_pet_owner(pet_owner) do
      send_resp(conn, :no_content, "")
    end
  end
end
