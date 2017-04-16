defmodule Webccg.User do
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]
  use Webccg.Web, :model

  schema "users" do
    field :avatar, :string
    field :username, :string
    field :mail, :string
    field :privilege, :integer
    field :encrypted_password, :string
    field :cards, {:array, :map}

    # Virtual fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @allowed_fields ~w(username mail password password_confirmation)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    cast(struct, params, @allowed_fields)
      |> validate_required([:username, :mail, :password, :password_confirmation], message: "Tous les champs ne sont pas remplis")
      |> unique_constraint(:username, message: "Nom d'utilisateur déjà utilisé")
      |> unique_constraint(:mail, message: "Mail déjà utilisé")
      |> validate_format(:mail, ~r/@/, message: "Adresse mail invalide")
      |> validate_length(:password, min: 8, message: "Mot de passe trop court (8 caractères minimum)")
      |> validate_confirmation(:password, message: "Le mot de passe et la confirmation doivent être identiques")
      |> put_change(:avatar, "")
      |> put_change(:privilege, 1)
      |> put_change(:cards, [])
      |> hash_password
  end

  # Hash password
  defp hash_password(changeset) do
    if password = get_field(changeset, :password) do
      changeset
        |> put_change(:encrypted_password, hashpwsalt(password))
    else
      changeset
        |> add_error(:encrypted_password, "No password provided")
    end
  end
end
