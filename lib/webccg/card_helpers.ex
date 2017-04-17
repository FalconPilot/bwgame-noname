defmodule Webccg.CardHelpers do
  alias Webccg.Repo
  alias Webccg.Card

  # Get random rarity
  def get_rarity() do
    rarity = Enum.random(0..100)
    cond do
      rarity <= 1 ->
        5
      rarity <= 5 ->
        4
      rarity <= 12 ->
        3
      rarity <= 35 ->
        2
      true ->
        1
    end
  end

  # Get cards
  def get_cards(cards) do
    get_cards(cards, [])
  end

  def get_cards([%{"id" => id, "amount" => amount}|t], acc) do
    case Repo.get_by(Card, id: id) do
      nil ->
        get_cards(t, acc)
      card ->
        get_cards(t, [%{card: card, amount: amount}|acc])
    end
  end

  def get_cards([], acc) do
    Enum.reverse(acc)
  end

end
