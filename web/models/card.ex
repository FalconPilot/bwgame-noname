defmodule Webccg.Card do
  use Webccg.Web, :model

  schema "cards" do
    field :name, :string
    field :rarity, :integer
    field :image, :string
    field :description, :string
    field :display_id, :integer
    field :group, :string

    timestamps()
  end

  @allowed_fields ~w(name description image rarity display_id group)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    cast(struct, params, @allowed_fields)
      |> validate_required([:name, :description, :image, :rarity])
      |> validate_length(:name, min: 3)
      |> validate_length(:description, min: 3)
      |> validate_length(:group, min: 3)
  end
end
