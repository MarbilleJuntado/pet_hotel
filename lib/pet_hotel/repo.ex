defmodule PetHotel.Repo do
  use Ecto.Repo,
    otp_app: :pet_hotel,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
