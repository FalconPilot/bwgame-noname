defmodule Webccg.Repo.Migrations.CreateCard do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :name, :string
      add :image, :string

      timestamps()
    end

  end
end
