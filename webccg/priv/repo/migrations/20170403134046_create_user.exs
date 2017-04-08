defmodule Webccg.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :avatar, :string
      add :username, :string
      add :privilege, :integer
      add :mail, :string
      add :encrypted_password, :string

      timestamps()
    end

    create index(:users, [:mail], unique: true)
    create index(:users, [:username], unique: true)

  end
end
