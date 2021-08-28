defmodule PetHotel.Pets.Pet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pet" do
    field :name, :string

    belongs_to :pet_owner, PetHotel.PetOwners.PetOwner

    timestamps()
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :pet_owner_id])
    |> validate_required([:name, :pet_owner_id])
  end
end
