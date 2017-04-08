defmodule Webccg.User do
  use Webccg.Web, :model

  schema "users" do
    field :avatar, :string
    field :username, :string
    field :mail, :string
    field :privilege, :integer
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @required_fields ~w(username mail password password_confirmation)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    cast(struct, params, @required_fields)
      |> validate_required([:username, :mail, :password, :password_confirmation])
      |> unique_constraint(:username, message: "Nom d'utilisateur déjà utilisé")
      |> unique_constraint(:mail, message: "Mail déjà utilisé")
      |> validate_format(:mail, ~r/@/)
      |> validate_length(:password, min: 8)
      |> validate_confirmation(:password)
      |> put_change(:avatar, "")
      |> put_change(:privilege, 1)
  end
end
