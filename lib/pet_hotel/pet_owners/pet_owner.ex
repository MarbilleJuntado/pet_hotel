defmodule PetHotel.PetOwners.PetOwner do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pet_owner" do
    field :email, :string
    field :name, :string

    has_many :pets, PetHotel.Pets.Pet

    timestamps()
  end

  @doc false
  def changeset(pet_owner, attrs) do
    pet_owner
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
