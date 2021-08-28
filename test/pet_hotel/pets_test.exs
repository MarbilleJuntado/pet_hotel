defmodule PetHotel.PetsTest do
  use PetHotel.DataCase

  alias PetHotel.PetOwners
  alias PetHotel.Pets

  describe "pet" do
    alias PetHotel.Pets.Pet

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    @valid_owner_attrs %{
      name: "some name",
      email: "x@y.z"
    }

    def pet_owner_fixture(attrs \\ %{}) do
      {:ok, pet_owner} =
        attrs
        |> Enum.into(@valid_owner_attrs)
        |> PetOwners.create_pet_owner()

      pet_owner
    end

    def pet_fixture(attrs \\ %{}) do
      {:ok, pet} =
        attrs
        |> Map.put(:pet_owner_id, pet_owner_fixture().id)
        |> Enum.into(@valid_attrs)
        |> Pets.create_pet()

      pet
    end

    test "list_pet/2 returns all pet" do
      pet = pet_fixture()

      assert Pets.list_pet() == %Scrivener.Page{
               entries: [pet],
               page_number: 1,
               page_size: 10,
               total_entries: 1,
               total_pages: 1
             }
    end

    test "get_pet!/1 returns the pet with given id" do
      pet = pet_fixture()
      assert Pets.get_pet!(pet.id) == pet
    end

    test "create_pet/1 with valid data creates a pet" do
      valid_attrs = Map.put(@valid_attrs, :pet_owner_id, pet_owner_fixture().id)
      assert {:ok, %Pet{} = pet} = Pets.create_pet(valid_attrs)
      assert pet.name == "some name"
    end

    test "create_pet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pets.create_pet(@invalid_attrs)
    end

    test "update_pet/2 with valid data updates the pet" do
      pet = pet_fixture()
      assert {:ok, %Pet{} = pet} = Pets.update_pet(pet, @update_attrs)
      assert pet.name == "some updated name"
    end

    test "update_pet/2 with invalid data returns error changeset" do
      pet = pet_fixture()
      assert {:error, %Ecto.Changeset{}} = Pets.update_pet(pet, @invalid_attrs)
      assert pet == Pets.get_pet!(pet.id)
    end

    test "delete_pet/1 deletes the pet" do
      pet = pet_fixture()
      assert {:ok, %Pet{}} = Pets.delete_pet(pet)
      assert_raise Ecto.NoResultsError, fn -> Pets.get_pet!(pet.id) end
    end

    test "change_pet/1 returns a pet changeset" do
      pet = pet_fixture()
      assert %Ecto.Changeset{} = Pets.change_pet(pet)
    end
  end
end
