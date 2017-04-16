defmodule Webccg.Repo.Migrations.CreateCard do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :name, :string
      add :description, :string
      add :image, :string
      add :rarity, :integer

      timestamps()
    end

  end
end