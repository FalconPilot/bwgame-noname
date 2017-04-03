defmodule Webccg.User do
  use Webccg.Web, :model

  schema "users" do
    field :username, :string
    field :mail, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:username, :mail, :password, :password_confirmation])
      |> validate_required([:username, :mail, :password, :password_confirmation])
      |> unique_constraint(:username, downcase: true)
      |> unique_constraint(:mail, downcase: true)
      |> validate_format(:mail, ~r/@/)
      |> validate_length(:password, min: 8)
      |> validate_confirmation(:password)
  end
end
