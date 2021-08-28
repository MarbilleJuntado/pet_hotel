defmodule PetHotel.Repo.Migrations.CreatePet do
  use Ecto.Migration

  def change do
    create table(:pet) do
      add :name, :string
      add :pet_owner_id, references(:pet_owner, on_delete: :delete_all)

      timestamps()
    end

    create index(:pet, [:pet_owner_id])
  end
end
