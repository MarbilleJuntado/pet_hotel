defmodule PetHotelWeb.PetOwnerController do
  use PetHotelWeb, :controller

  alias PetHotel.PetOwners
  alias PetHotel.Pets
  alias PetHotel.PetOwners.PetOwner

  alias PetHotelWeb.Schemas.Pets, as: PetSchemas
  alias PetHotelWeb.Schemas.PetOwners, as: Schemas

  action_fallback PetHotelWeb.FallbackController

  @spec open_api_operation(atom) :: Operation.t()
  def open_api_operation(action) do
    operation = String.to_existing_atom("#{action}_operation")
    apply(__MODULE__, operation, [])
  end

  @spec index_operation() :: Operation.t()
  def index_operation do
    %Operation{
      tags: ["Pet Owner"],
      summary: "List pet owners",
      description: "",
      operationId: "PetOwnerController.index",
      parameters: [
        Operation.parameter(:name, :query, :string, "Name"),
        Operation.parameter(:email, :query, :string, "Email"),
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
              "Pet Owner Page",
              "application/json",
              Schemas.PetOwnerPage
            )
        })
    }
  end

  def index(conn, params) do
    page = PetOwners.list_pet_owner(params)
    render(conn, "index.json", pet_owner_page: page)
  end

  @spec pets_operation() :: Operation.t()
  def pets_operation do
    %Operation{
      tags: ["Owner Pet"],
      summary: "List owner pets",
      description: "",
      operationId: "PetOwnerController.pets",
      parameters: [
        Operation.parameter(
          :id,
          :path,
          %Schema{type: :integer},
          "Pet Owner ID",
          required: true
        ),
        Operation.parameter(:name, :query, :string, "Name"),
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
              PetSchemas.PetPage
            ),
          404 => Errors.not_found()
        })
    }
  end

  def pets(conn, %{"id" => id} = params) do
    case PetOwners.get_pet_owner(id) do
      %PetOwner{} = pet_owner ->
        page =
          params
          |> Map.delete("id")
          |> Map.put("pet_owner_id", pet_owner.id)
          |> Pets.list_pet()

        render(conn, "pets.json", pet_page: page)

      _ ->
        {:error, :not_found}
    end
  end

  @spec create_operation() :: Operation.t()
  def create_operation do
    %Operation{
      tags: ["Pet Owner"],
      summary: "Create a pet owner",
      description: "",
      operationId: "PetOwnerController.create",
      parameters: [],
      requestBody:
        Operation.request_body(
          "Pet owner attributes",
          "application/json",
          Schemas.PetOwnerParam
        ),
      responses:
        Errors.default_error_responses()
        |> Map.merge(%{
          201 =>
            Operation.response(
              "Pet Owner",
              "application/json",
              Schemas.PetOwner
            ),
          422 => Errors.unprocessable_entity()
        })
    }
  end

  def create(conn, %{"pet_owner" => pet_owner_params}) do
    with {:ok, %PetOwner{} = pet_owner} <- PetOwners.create_pet_owner(pet_owner_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.pet_owner_path(conn, :show, pet_owner))
      |> render("show.json", pet_owner: pet_owner)
    end
  end

  @spec show_operation() :: Operation.t()
  def show_operation do
    %Operation{
      tags: ["Pet Owner"],
      summary: ["View a pet owner by ID"],
      description: "",
      operationId: "PetOwnerController.show",
      parameters: [
        Operation.parameter(
          :id,
          :path,
          %Schema{type: :integer},
          "Pet Owner ID",
          required: true
        )
      ],
      responses:
        Errors.default_error_responses()
        |> Map.merge(%{
          200 => Operation.response("Pet Owner", "application/json", Schemas.PetOwner),
          404 => Errors.not_found()
        })
    }
  end

  def show(conn, %{"id" => id}) do
    case PetOwners.get_pet_owner(id) do
      %PetOwner{} = pet_owner ->
        render(conn, "show.json", pet_owner: pet_owner)

      _ ->
        {:error, :not_found}
    end
  end

  @spec update_operation() :: Operation.t()
  def update_operation do
    %Operation{
      tags: ["Pet Owner"],
      summary: "Update an existing pet owner",
      description: "",
      operationId: "PetOwnerController.update",
      parameters: [
        Operation.parameter(
          :id,
          :path,
          %Schema{type: :integer},
          "Pet Owner ID",
          required: true
        )
      ],
      requestBody:
        Operation.request_body(
          "Pet owner attributes",
          "application/json",
          Schemas.PetOwnerParam
        ),
      responses:
        Errors.default_error_responses()
        |> Map.merge(%{
          200 =>
            Operation.response(
              "Pet Owner",
              "application/json",
              Schemas.PetOwner
            ),
          404 => Errors.not_found(),
          422 => Errors.unprocessable_entity()
        })
    }
  end

  def update(conn, %{"id" => id, "pet_owner" => pet_owner_params}) do
    with %PetOwner{} = pet_owner <- PetOwners.get_pet_owner(id),
         {:ok, %PetOwner{} = pet_owner} <- PetOwners.update_pet_owner(pet_owner, pet_owner_params) do
      render(conn, "show.json", pet_owner: pet_owner)
    end
  end

  @spec delete_operation() :: Operation.t()
  def delete_operation do
    %Operation{
      tags: ["Pet Owner"],
      summary: "Delete an existing pet owner",
      description: "",
      operationId: "PetOwnerController.delete",
      parameters: [
        Operation.parameter(
          :id,
          :path,
          %Schema{type: :integer},
          "Pet Owner ID",
          required: true
        )
      ],
      responses: Errors.default_error_responses()
    }
  end

  def delete(conn, %{"id" => id}) do
    with %PetOwner{} = pet_owner <- PetOwners.get_pet_owner(id),
         {:ok, %PetOwner{}} <- PetOwners.delete_pet_owner(pet_owner) do
      send_resp(conn, :no_content, "")
    end
  end
end
