defmodule PetHotel.Repo.Migrations.CreatePetOwner do
  use Ecto.Migration

  def change do
    create table(:pet_owner) do
      add :name, :string, null: false
      add :email, :string, null: false

      timestamps()
    end

    create unique_index(:pet_owner, [:email])
  end
end
