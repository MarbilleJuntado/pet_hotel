defmodule PetHotelWeb.PetController do
  use PetHotelWeb, :controller

  alias PetHotel.Pets
  alias PetHotel.Pets.Pet

  alias PetHotelWeb.Schemas.Pets, as: Schemas

  action_fallback PetHotelWeb.FallbackController

  @spec open_api_operation(atom) :: Operation.t()
  def open_api_operation(action) do
    operation = String.to_existing_atom("#{action}_operation")
    apply(__MODULE__, operation, [])
  end

  @spec index_operation() :: Operation.t()
  def index_operation do
    %Operation{
      tags: ["Pet"],
      summary: "List pets",
      description: "",
      operationId: "PetController.index",
      parameters: [
        Operation.parameter(:name, :query, :string, "Name"),
        Operation.parameter(
          :pet_owner_id,
          :query,
          %Schema{type: :integer},
          "Pet Owner ID"
        ),
        Operation.parameter(
          :page,
          :query,
          %Schema{type: :integer},
          "Page"
        ),
        Operation.parameter(
          :page_size,
          :query,
          %Schema{type: :integer},
          "Page Size"
        )
      ],
      responses:
        Errors.default_error_responses()
        |> Map.merge(%{
          200 =>
            Operation.response(
              "Pet Page",
              "application/json",
              Schemas.PetPage
            )
        })
    }
  end

  def index(conn, params) do
    page = Pets.list_pet(params)
    render(conn, "index.json", pet_page: page)
  end

  @spec create_operation() :: Operation.t()
  def create_operation do
    %Operation{
      tags: ["Pet"],
      summary: "Create a pet",
      description: "",
      operationId: "PetController.create",
      parameters: [],
      requestBody:
        Operation.request_body(
          "Pet attributes",
          "application/json",
          Schemas.PetParam
        ),
      responses:
        Errors.default_error_responses()
        |> Map.merge(%{
          201 =>
            Operation.response(
              "Pet",
              "application/json",
              Schemas.Pet
            ),
          422 => Errors.unprocessable_entity()
        })
    }
  end

  def create(conn, %{"pet" => pet_params}) do
    with {:ok, %Pet{} = pet} <- Pets.create_pet(pet_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.pet_path(conn, :show, pet))
      |> render("show.json", pet: pet)
    end
  end

  @spec show_operation() :: Operation.t()
  def show_operation do
    %Operation{
      tags: ["Pet"],
      summary: ["View a pet by ID"],
      description: "",
      operationId: "PetController.show",
      parameters: [
        Operation.parameter(
          :id,
          :path,
          %Schema{type: :integer},
          "Pet ID",
          required: true
        )
      ],
      responses:
        Errors.default_error_responses()
        |> Map.merge(%{
          200 => Operation.response("Pet", "application/json", Schemas.Pet),
          404 => Errors.not_found()
        })
    }
  end

  def show(conn, %{"id" => id}) do
    case Pets.get_pet(id) do
      %Pet{} = pet ->
        render(conn, "show.json", pet: pet)

      _ ->
        {:error, :not_found}
    end
  end

  @spec update_operation() :: Operation.t()
  def update_operation do
    %Operation{
      tags: ["Pet"],
      summary: "Update an existing pet",
      description: "",
      operationId: "PetController.update",
      parameters: [
        Operation.parameter(
          :id,
          :path,
          %Schema{type: :integer},
          "Pet ID",
          required: true
        )
      ],
      requestBody:
        Operation.request_body(
          "Pet attributes",
          "application/json",
          Schemas.PetParam
        ),
      responses:
        Errors.default_error_responses()
        |> Map.merge(%{
          200 =>
            Operation.response(
              "Pet",
              "application/json",
              Schemas.Pet
            ),
          404 => Errors.not_found(),
          422 => Errors.unprocessable_entity()
        })
    }
  end

  def update(conn, %{"id" => id, "pet" => pet_params}) do
    with %Pet{} = pet <- Pets.get_pet(id),
         {:ok, %Pet{} = pet} <- Pets.update_pet(pet, pet_params) do
      render(conn, "show.json", pet: pet)
    end
  end

  @spec delete_operation() :: Operation.t()
  def delete_operation do
    %Operation{
      tags: ["Pet"],
      summary: "Delete an existing pet",
      description: "",
      operationId: "PetController.delete",
      parameters: [
        Operation.parameter(
          :id,
          :path,
          %Schema{type: :integer},
          "Pet ID",
          required: true
        )
      ],
      responses: Errors.default_error_responses()
    }
  end

  def delete(conn, %{"id" => id}) do
    with %Pet{} = pet <- Pets.get_pet(id),
         {:ok, %Pet{}} <- Pets.delete_pet(pet) do
      send_resp(conn, :no_content, "")
    end
  end
end
