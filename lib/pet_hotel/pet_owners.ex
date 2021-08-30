defmodule PetHotel.PetOwners do
  @moduledoc """
  The PetOwners context.
  """

  import Ecto.Query, warn: false
  alias PetHotel.Repo

  alias PetHotel.PetOwners.PetOwner
  alias PetHotel.PetOwners.Queries, as: POQ

  @doc """
  Returns the list of pet_owner.

  ## Examples

      iex> list_pet_owner()
      [%PetOwner{}, ...]

  """
  def list_pet_owner(params \\ %{}, preload \\ []) do
    params = format_params(params)

    params
    |> POQ.query_all_pet_owners(preload)
    |> Repo.paginate(
      page: params["page"],
      page_size: params["page_size"]
    )
  end

  @doc """
  Gets a single pet_owner.
  """
  def get_pet_owner(id), do: Repo.get(PetOwner, id)

  @doc """
  Gets a single pet_owner.

  Raises `Ecto.NoResultsError` if the Pet owner does not exist.

  ## Examples

      iex> get_pet_owner!(123)
      %PetOwner{}

      iex> get_pet_owner!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pet_owner!(id), do: Repo.get!(PetOwner, id)

  @doc """
  Creates a pet_owner.

  ## Examples

      iex> create_pet_owner(%{field: value})
      {:ok, %PetOwner{}}

      iex> create_pet_owner(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pet_owner(attrs \\ %{}) do
    %PetOwner{}
    |> PetOwner.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pet_owner.

  ## Examples

      iex> update_pet_owner(pet_owner, %{field: new_value})
      {:ok, %PetOwner{}}

      iex> update_pet_owner(pet_owner, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pet_owner(%PetOwner{} = pet_owner, attrs) do
    pet_owner
    |> PetOwner.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pet_owner.

  ## Examples

      iex> delete_pet_owner(pet_owner)
      {:ok, %PetOwner{}}

      iex> delete_pet_owner(pet_owner)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pet_owner(%PetOwner{} = pet_owner) do
    Repo.delete(pet_owner)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pet_owner changes.

  ## Examples

      iex> change_pet_owner(pet_owner)
      %Ecto.Changeset{data: %PetOwner{}}

  """
  def change_pet_owner(%PetOwner{} = pet_owner, attrs \\ %{}) do
    PetOwner.changeset(pet_owner, attrs)
  end

  defp format_params(%{"page" => page, "page_size" => page_size} = params)
       when not is_nil(page) and not is_nil(page_size),
       do: params

  defp format_params(%{"page" => page} = params)
       when not is_nil(page),
       do: Map.put(params, "page_size", 10)

  defp format_params(%{"page_size" => page_size} = params)
       when not is_nil(page_size),
       do: Map.put(params, "page", 1)

  defp format_params(params),
    do:
      Map.merge(params, %{
        "page" => 1,
        "page_size" => 10
      })
end
