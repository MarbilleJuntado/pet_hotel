defmodule PetHotelWeb.PetOwnerControllerTest do
  use PetHotelWeb.ConnCase

  alias PetHotel.PetOwners
  alias PetHotel.Pets
  alias PetHotel.PetOwners.PetOwner

  @create_attrs %{
    email: "a@b.c",
    name: "some name"
  }
  @update_attrs %{
    email: "b@c.d",
    name: "some updated name"
  }
  @invalid_attrs %{email: nil, name: nil}

  def fixture(:pet_owner) do
    {:ok, pet_owner} = PetOwners.create_pet_owner(@create_attrs)
    pet_owner
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all pet_owner", %{conn: conn} do
      {:ok, pet_owner} = PetOwners.create_pet_owner(@create_attrs)

      conn = get(conn, Routes.pet_owner_path(conn, :index))
      assert %{"pet_owners" => owners} = json_response(conn, 200)
      assert is_list(owners)
      assert Enum.find(owners, &(&1["id"] == pet_owner.id))
    end
  end

  describe "pets" do
    setup [:create_pet_owner]

    test "list all pets belonging to pet owner", %{
      conn: conn,
      pet_owner: pet_owner
    } do
      {:ok, other_owner} =
        PetOwners.create_pet_owner(%{
          "name" => "other name",
          "email" => "x@y.z"
        })

      {:ok, owner_pet_1} =
        Pets.create_pet(%{
          "name" => "pet 1",
          "pet_owner_id" => pet_owner.id
        })

      {:ok, owner_pet_2} =
        Pets.create_pet(%{
          "name" => "pet 2",
          "pet_owner_id" => pet_owner.id
        })

      {:ok, other_pet} =
        Pets.create_pet(%{
          "name" => "other pet",
          "pet_owner_id" => other_owner.id
        })

      conn = get(conn, Routes.pet_owner_path(conn, :pets, pet_owner))
      assert %{"pets" => pets} = json_response(conn, 200)
      assert is_list(pets)
      assert pet_ids = Enum.map(pets, & &1["id"])

      assert owner_pet_1.id in pet_ids
      assert owner_pet_2.id in pet_ids
      refute other_pet.id in pet_ids
    end
  end

  describe "create pet_owner" do
    test "renders pet_owner when data is valid", %{conn: conn} do
      conn = post(conn, Routes.pet_owner_path(conn, :create), pet_owner: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.pet_owner_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "a@b.c",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.pet_owner_path(conn, :create), pet_owner: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update pet_owner" do
    setup [:create_pet_owner]

    test "renders pet_owner when data is valid", %{
      conn: conn,
      pet_owner: %PetOwner{id: id} = pet_owner
    } do
      conn = put(conn, Routes.pet_owner_path(conn, :update, pet_owner), pet_owner: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.pet_owner_path(conn, :show, id))

      assert %{
               "id" => id,
               "email" => "b@c.d",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, pet_owner: pet_owner} do
      conn = put(conn, Routes.pet_owner_path(conn, :update, pet_owner), pet_owner: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete pet_owner" do
    setup [:create_pet_owner]

    test "deletes chosen pet_owner", %{conn: conn, pet_owner: pet_owner} do
      conn = delete(conn, Routes.pet_owner_path(conn, :delete, pet_owner))
      assert response(conn, 204)

      conn = get(conn, Routes.pet_owner_path(conn, :show, pet_owner))
      assert response(conn, 404)
    end
  end

  defp create_pet_owner(_) do
    pet_owner = fixture(:pet_owner)
    %{pet_owner: pet_owner}
  end
end
