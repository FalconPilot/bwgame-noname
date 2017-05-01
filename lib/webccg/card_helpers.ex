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
  def get_cards(cards), do: get_cards(cards, [])

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

  # Remove card from map
  def remove_card(list, id) do
    remove_card(list, id, [])
  end

  def remove_card([%{"id" => id, "amount" => amount}|t], cardid, acc) do
    if id == cardid do
      remove_card(t, cardid, acc)
    else
      h = %{"id" => id, "amount" => amount}
      remove_card(t, cardid, [h|acc])
    end
  end

  def remove_card([], _cardid, acc) do
    Enum.reverse(acc)
  end

  # Add card to map
  def add_card(list, id) do
    add_card(list, id, [], false)
  end

  def add_card([%{"id" => id, "amount" => amount}|t], cardid, acc, changed) do
    {amount, changed} =
      if id == cardid do
        {amount + 1, true}
      else
        {amount, changed}
      end
    h = %{"id" => id, "amount" => amount}
    add_card(t, cardid, [h|acc], changed)
  end

  def add_card([], cardid, acc, changed) do
    if !changed do
      Enum.reverse([%{"id" => cardid, "amount" => 1}|acc])
    else
      Enum.reverse(acc)
    end
  end

end
