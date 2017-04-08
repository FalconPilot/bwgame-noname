defmodule Webccg.Password do
  import Ecto.Changeset, only: [put_change: 3]
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  def generate_password(changeset) do
    put_change(changeset, :encrypted_password, hashpwsalt(changeset.params["password"]))
  end
end
