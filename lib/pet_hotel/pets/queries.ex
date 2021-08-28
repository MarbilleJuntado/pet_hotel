defmodule PetHotel.Pets.Queries do
  import Ecto.Query

  alias PetHotel.Pets.Pet

  def query_all_pets(params \\ %{}, preload \\ []) do
    query = from(Pet, preload: ^preload)

    query_by(query, params)
  end

  defp query_by(query, %{"id" => id} = params) do
    query = from(q in query, where: q.id == ^id)

    query_by(query, Map.delete(params, "id"))
  end

  defp query_by(query, %{"ids" => ids} = params) do
    query = from(q in query, where: q.id in ^ids)

    query_by(query, Map.delete(params, "ids"))
  end

  defp query_by(query, %{"pet_owner_id" => id} = params) do
    query = from(q in query, where: q.pet_owner_id == ^id)

    query_by(query, Map.delete(params, "pet_owner_id"))
  end

  defp query_by(query, %{"name" => name} = params) do
    query = from(q in query, where: ilike(q.name, ^name))

    query_by(query, Map.delete(params, "name"))
  end

  defp query_by(query, _params), do: query
end
