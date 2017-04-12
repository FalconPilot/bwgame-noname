defmodule Webccg.Card do
  use Webccg.Web, :model

  schema "cards" do
    field :name, :string
    field :image, :string
    field :description, :string

    timestamps()
  end

  @allowed_fields ~w(name description image)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    cast(struct, params, @allowed_fields)
      |> validate_required(@allowed_fields)
      |> validate_length(:name, min: 3)
      |> validate_length(:description, min: 3)
  end
end
