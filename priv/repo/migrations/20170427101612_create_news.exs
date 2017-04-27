defmodule Webccg.Repo.Migrations.CreateNews do
  use Ecto.Migration

  def change do
    create table(:news) do
      add :title, :string
      add :contents, :string

      timestamps()
    end

  end
end
