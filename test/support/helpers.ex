defmodule PetHotel.Support.Helpers do
  def launch_api do
    # set up config for serving
    endpoint_config =
      Application.get_env(:pet_hotel, PetHotelWeb.Endpoint)
      |> Keyword.put(:server, true)

    :ok = Application.put_env(:pet_hotel, PetHotelWeb.Endpoint, endpoint_config)

    # restart application with serving enabled
    :ok = Application.stop(:pet_hotel)
    :ok = Application.start(:pet_hotel)
  end
end
