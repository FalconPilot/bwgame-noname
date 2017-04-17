defmodule Webccg.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :mail, :string
      add :avatar, :string
      add :privilege, :integer
      add :encrypted_password, :string
      add :cards, {:array, :map}
      add :last_obtained, :string

      timestamps()
    end
    create index(:users, [:mail], unique: true)
    create index(:users, [:username], unique: true)
  end
end
