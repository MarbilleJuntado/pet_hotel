defmodule PetHotelWeb.PetControllerTest do
  use PetHotelWeb.ConnCase

  alias PetHotel.PetOwners
  alias PetHotel.Pets
  alias PetHotel.Pets.Pet

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:pet_owner) do
    {:ok, pet_owner} =
      PetOwners.create_pet_owner(%{
        name: "some name",
        email: "x@y.z"
      })

    pet_owner
  end

  def fixture(:pet) do
    pet_owner = fixture(:pet_owner)

    attrs = Map.put(@create_attrs, :pet_owner_id, pet_owner.id)
    {:ok, pet} = Pets.create_pet(attrs)
    pet
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all pet", %{conn: conn} do
      pet_owner = fixture(:pet_owner)

      attrs = Map.put(@create_attrs, :pet_owner_id, pet_owner.id)
      {:ok, pet} = Pets.create_pet(attrs)

      conn = get(conn, Routes.pet_path(conn, :index))
      assert %{"pets" => pets} = json_response(conn, 200)
      assert Enum.find(pets, & &1["id"] == pet.id)
    end
  end

  describe "create pet" do
    test "renders pet when data is valid", %{conn: conn} do
      pet_owner = fixture(:pet_owner)

      attrs = Map.put(@create_attrs, :pet_owner_id, pet_owner.id)
      conn = post(conn, Routes.pet_path(conn, :create), pet: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.pet_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.pet_path(conn, :create), pet: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update pet" do
    setup [:create_pet]

    test "renders pet when data is valid", %{conn: conn, pet: %Pet{id: id} = pet} do
      conn = put(conn, Routes.pet_path(conn, :update, pet), pet: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.pet_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, pet: pet} do
      conn = put(conn, Routes.pet_path(conn, :update, pet), pet: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete pet" do
    setup [:create_pet]

    test "deletes chosen pet", %{conn: conn, pet: pet} do
      conn = delete(conn, Routes.pet_path(conn, :delete, pet))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.pet_path(conn, :show, pet))
      end
    end
  end

  defp create_pet(_) do
    pet = fixture(:pet)
    %{pet: pet}
  end
end
