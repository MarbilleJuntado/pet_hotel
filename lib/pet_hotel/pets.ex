defmodule PetHotel.Pets do
  @moduledoc """
  The Pets context.
  """

  import Ecto.Query, warn: false
  alias PetHotel.Repo

  alias PetHotel.Pets.Pet
  alias PetHotel.Pets.Queries, as: PQ

  @doc """
  Returns the list of pet.

  ## Examples

      iex> list_pet()
      [%Pet{}, ...]

  """
  def list_pet(params \\ %{}, preload \\ []) do
    params = format_params(params)

    params
    |> PQ.query_all_pets(preload)
    |> Repo.paginate(
      page: params["page"],
      page_size: params["page_size"]
    )
  end

  @doc """
  Gets a single pet.

  Raises `Ecto.NoResultsError` if the Pet does not exist.

  ## Examples

      iex> get_pet!(123)
      %Pet{}

      iex> get_pet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pet!(id), do: Repo.get!(Pet, id)

  @doc """
  Creates a pet.

  ## Examples

      iex> create_pet(%{field: value})
      {:ok, %Pet{}}

      iex> create_pet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pet(attrs \\ %{}) do
    %Pet{}
    |> Pet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pet.

  ## Examples

      iex> update_pet(pet, %{field: new_value})
      {:ok, %Pet{}}

      iex> update_pet(pet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pet(%Pet{} = pet, attrs) do
    pet
    |> Pet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pet.

  ## Examples

      iex> delete_pet(pet)
      {:ok, %Pet{}}

      iex> delete_pet(pet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pet(%Pet{} = pet) do
    Repo.delete(pet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pet changes.

  ## Examples

      iex> change_pet(pet)
      %Ecto.Changeset{data: %Pet{}}

  """
  def change_pet(%Pet{} = pet, attrs \\ %{}) do
    Pet.changeset(pet, attrs)
  end

  defp format_params(%{"page" => page, "page_size" => page_size} = params)
       when not is_nil(page) and not is_nil(page_size),
       do: params

  defp format_params(%{"page" => page} = params)
       when is_integer(page),
       do: Map.put(params, "page_size", 10)

  defp format_params(%{"page_size" => page_size} = params)
       when is_integer(page_size),
       do: Map.put(params, "page", 1)

  defp format_params(params),
    do:
      Map.merge(params, %{
        "page" => 1,
        "page_size" => 10
      })
end
