defmodule PetHotel.Support.APICall do
  @success_codes 200..399

  def get(url, params \\ %{}) do
    client = client()

    with {:ok, %{body: body, status: status}} when status in @success_codes <-
           Tesla.get(client, url, query: params) do
      %{body: body, status: status}
    else
      {:ok, %{body: body}} ->
        {:error, body}

      {:error, _message} = error ->
        error
    end
  end

  def post(url, params \\ %{}) do
    client = client()

    with {:ok, body} <- Jason.encode(params),
         {:ok, %{body: body, status: status}} when status in @success_codes <-
           Tesla.post(client, url, body) do
      %{body: body, status: status}
    else
      {:ok, %{body: body}} ->
        {:error, body}

      {:error, _message} = error ->
        error
    end
  end

  defp api_url do
    endpoint_config = Application.get_env(:pet_hotel, PetHotelWeb.Endpoint)
    host = Keyword.get(endpoint_config, :url) |> Keyword.get(:host)
    port = Keyword.get(endpoint_config, :http) |> Keyword.get(:port)

    "http://#{host}:#{port}/api"
  end

  defp client do
    url = api_url()

    middlewares = [
      {Tesla.Middleware.BaseUrl, url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"content-type", "application/json"}]},
      Tesla.Middleware.PathParams,
      Tesla.Middleware.Logger
    ]

    Tesla.client(middlewares)
  end
end
