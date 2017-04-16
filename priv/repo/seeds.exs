# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Webccg.Repo.insert!(%Webccg.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Webccg.Repo
alias Webccg.User

admin_params = %User{
  username: "Admin",
  password: "defaultpassword",
  password_confirmation: "defaultpassword",
  mail: "foo@bar.io"
}

User.changeset(admin_params)
  |> Ecto.Changeset.put_change(:privilege, 3)
  |> Repo.insert!
