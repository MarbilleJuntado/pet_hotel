defmodule PetHotel.Integration.Tests do
  use ExUnit.Case

  alias PetHotel.Support.APICall
  alias PetHotel.Support.Helpers
  alias PetHotel.Repo

  import Ecto.Query, only: [from: 2]

  setup_all do
    Helpers.launch_api()
  end

  test "GET /api/pet-owner returns HTTP 200" do
    response = APICall.get("/pet-owner")
    assert response.status == 200
  end

  test "POST /api/pet-owner returns HTTP 201" do
    email = generate_email()

    params = %{
      pet_owner: %{
        name: "mickey",
        email: email
      }
    }

    response = APICall.post("/pet-owner", params)
    assert response.status == 201

    assert %{"data" => data} = response.body
    assert data["name"] == "mickey"

    Repo.delete_all(from(po in "pet_owner", where: po.id == ^data["id"]))
  end

  test "GET /api/pet returns HTTP 200" do
    response = APICall.get("/pet")
    assert response.status == 200
  end

  test "POST /api/pet returns HTTP 201" do
    email = generate_email()

    params = %{
      pet_owner: %{
        name: "daisy",
        email: email
      }
    }

    response = APICall.post("/pet-owner", params)
    assert response.status == 201

    assert %{"data" => owner_data} = response.body
    assert owner_data["name"] == "daisy"

    params = %{
      pet: %{
        name: "goofy",
        pet_owner_id: owner_data["id"]
      }
    }

    response = APICall.post("/pet", params)
    assert response.status == 201

    assert %{"data" => pet_data} = response.body
    assert pet_data["name"] == "goofy"
    assert pet_data["pet_owner_id"] == owner_data["id"]

    Repo.delete_all(from(p in "pet", where: p.id == ^pet_data["id"]))
    Repo.delete_all(from(po in "pet_owner", where: po.id == ^owner_data["id"]))
  end

  test "GET /api/pet_owner/:id/pet returns HTTP 200" do
    owner_ids =
      for _ <- 1..2 do
        params = %{
          pet_owner: %{
            name: random_string(32),
            email: generate_email()
          }
        }

        response = APICall.post("/pet-owner", params)
        assert response.status == 201

        assert %{"data" => owner_data} = response.body
        owner_data["id"]
      end

    [owner_id_1, owner_id_2] = owner_ids

    pet_ids =
      for _ <- 1..4 do
        params = %{
          pet: %{
            name: random_string(32),
            pet_owner_id: owner_id_1
          }
        }

        response = APICall.post("/pet", params)
        assert response.status == 201

        assert %{"data" => pet_data} = response.body
        pet_data["id"]
      end

    params = %{
      pet: %{
        name: random_string(32),
        pet_owner_id: owner_id_2
      }
    }

    response = APICall.post("/pet", params)
    assert response.status == 201
    assert %{"data" => other_pet_data} = response.body

    response = APICall.get("/pet-owner/#{owner_id_1}/pet", %{page: 1, page_size: 3})
    assert response.status == 200
    assert %{"pets" => pets} = response.body
    assert is_list(pets) and length(pets) == 3
    assert fetched_ids = Enum.map(pets, & &1["id"])
    refute Enum.all?(pet_ids, &(&1 in fetched_ids))
    refute other_pet_data["id"] in fetched_ids

    Repo.delete_all(from(p in "pet", where: p.id in ^pet_ids or p.id == ^other_pet_data["id"]))
    Repo.delete_all(from(po in "pet_owner", where: po.id in ^owner_ids))
  end

  defp generate_email, do: "#{random_string(32)}@#{random_string(5)}.#{random_string(3)}"

  defp random_string(length) do
    alphabet = String.split("abcdefghijklmnopqrstuvwxyz", "")
    range = 1..length

    range
    |> Enum.reduce([], fn _, acc ->
      [Enum.random(alphabet) | acc]
    end)
    |> Enum.join()
  end
end
