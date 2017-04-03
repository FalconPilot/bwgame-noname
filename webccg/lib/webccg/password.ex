defmodule Webccg.Password do
  alias Webccg.Repo
  import Ecto.Changeset, only: [put_change: 3]
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  def generate_password(changeset) do
    put_change(changeset, :encrypted_password, hashpwsalt(changeset.params["password"]))
  end

  def generate_and_store(changeset) do
    changeset
      |> generate_password
      |> Repo.insert
  end
end
