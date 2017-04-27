defmodule Webccg.News do
  use Webccg.Web, :model

  schema "news" do
    field :title, :string
    field :contents, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    cast(struct, params, [:title, :contents])
      |> validate_required([:title, :contents])
  end
end
