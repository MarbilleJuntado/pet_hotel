defmodule PetHotel.PetOwners.Queries do
  import Ecto.Query

  alias PetHotel.PetOwners.PetOwner

  def query_all_pet_owners(params \\ %{}, preload \\ []) do
    query = from(PetOwner, preload: ^preload)

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

  defp query_by(query, %{"name" => name} = params) do
    query = from(q in query, where: ilike(q.name, ^name))

    query_by(query, Map.delete(params, "name"))
  end

  defp query_by(query, %{"email" => email} = params) do
    query = from(q in query, where: ilike(q.email, ^email))

    query_by(query, Map.delete(params, "email"))
  end

  defp query_by(query, _params), do: query
end
