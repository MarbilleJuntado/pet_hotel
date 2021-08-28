defmodule PetHotel.PetOwners do
  @moduledoc """
  The PetOwners context.
  """

  import Ecto.Query, warn: false
  alias PetHotel.Repo

  alias PetHotel.PetOwners.PetOwner

  @doc """
  Returns the list of pet_owner.

  ## Examples

      iex> list_pet_owner()
      [%PetOwner{}, ...]

  """
  def list_pet_owner do
    Repo.all(PetOwner)
  end

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
end
