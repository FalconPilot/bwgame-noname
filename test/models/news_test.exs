defmodule Webccg.NewsTest do
  use Webccg.ModelCase

  alias Webccg.News

  @valid_attrs %{contents: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = News.changeset(%News{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = News.changeset(%News{}, @invalid_attrs)
    refute changeset.valid?
  end
end
