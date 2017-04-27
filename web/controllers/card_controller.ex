defmodule Webccg.CardController do
  use Webccg.Web, :controller

  # Create new card
  def new(conn, %{"card" => card_params}) do
    if is_admin?(conn) do
      IO.inspect card_params["name"]
      # Define changeset
      changeset =
        case Repo.get_by(Card, name: card_params["name"]) do
          nil ->
            Card.changeset(%Card{}, card_params)
          card ->
            # Format params and update changeset
            params = Enum.map(card_params, fn({k, v}) ->
              value =
                case Integer.parse(v) do
                  {int, _point} ->
                    int
                  _ ->
                    v
                end
              {String.to_atom(k), value}
            end)
            Ecto.Changeset.change(card, params)
        end
      # Insert or update card
      case Repo.insert_or_update(changeset) do
        {:ok, new_card} ->
          conn
            |> put_flash(:info, "Carte \"#{new_card.name}\" créée avec succès !")
            |> redirect(to: "/cards")

        {:error, _} ->
          conn
            |> put_flash(:error, "Carte invalide !")
            |> redirect(to: "/cards")
      end
    else
      Webccg.PageController.redirect_admin(conn, "/cards")
    end
  end

  # Delete card
  def delete(conn, %{"cid" => card_id}) do
    if is_admin?(conn) do
      case Repo.get(Card, card_id) do
        nil ->
          conn
            |> put_flash(:error, "La carte n'existe pas")
            |> redirect(to: "/cards")

        card ->
          case Repo.delete card do
            {:ok, _} ->
              conn
                |> put_flash(:info, "Carte supprimée avec succès")
                |> redirect(to: "/cards")

            {:error, _} ->
              conn
                |> put_flash(:error, "La carte n'a pas pu être supprimée")
                |> redirect(to: "/cards")
          end
      end
    else
      Webccg.PageController.redirect_admin(conn, "/cards")
    end
  end

  # Get random card
  def obtain(conn, %{"userid" => userid}) do
    if obtain_valid?(conn, userid) do
      url = "/users/#{userid}"
      # Check if user exist
      case Repo.get(User, userid) do
        nil ->
          conn
            |> put_flash(:error, "Utilisateur invalide")
            |> redirect(to: url)
        user ->
          now = Date.utc_today
          # Check if user can obtain card
          case Date.compare(now, Date.from_iso8601!(user.last_obtained)) do
            # Can obtain card
            :gt ->
              rarity = CardHelpers.get_rarity
              query = from(c in Card, [where: c.rarity == ^rarity])
              case Repo.all(query) do
                [] ->
                  conn
                    |> put_flash(:error, "Aucune carte #{rarity}★ !")
                    |> redirect(to: url)
                cards ->
                  give_to(conn, user, Enum.random(cards), url)
              end
            # Cannot obtain card
            _ ->
              conn
                |> put_flash(:error, "Carte déjà obtenue aujourd'hui !")
                |> redirect(to: url)
          end
      end
    else
      conn
        |> put_flash(:error, "Requête invalide !")
        |> redirect(to: "/")
    end
  end

  # Define if request is valid
  defp obtain_valid?(conn, id) do
    case get_session(conn, :current_user) do
      nil ->
        false
      user ->
        case Integer.parse(id) do
          {int, _point} ->
            int == user.id or user.privilege >= 2
          _ ->
            false
        end
    end
  end

  # Public give card route
  def give_card(conn, %{"cardid" => cardid, "username" => username}) do
    case Repo.get_by(Card, id: cardid) do
      nil ->
        conn
          |> put_flash(:error, "Carte n°#{cardid} inexistante !")
          |> redirect(to: "/cards")
      card ->
        case Repo.get_by(User, username: username) do
          nil ->
            conn
              |> put_flash(:error, "Utilisateur #{username} inexistant !")
              |> redirect(to: "/cards")
          user ->
            give_to(conn, user, card, "/cards")
        end
    end
  end

  # Reorder card IDs
  def reorder_ids(conn, _params) do
    if is_admin?(conn) do
      cards = Enum.sort_by(Repo.all(Card), fn(x) ->
        x.inserted_at
      end)
      Enum.each(Enum.with_index(cards), fn({x, i}) ->
        card = Ecto.Changeset.change(x, display_id: i + 1)
        Repo.update!(card)
      end)
      conn
        |> put_flash(:info, "ID des cartes réordonnés")
        |> redirect(to: "/cards")
    else
      Webccg.PageController.redirect_admin(conn, "/cards")
    end
  end

  # Give card to user
  defp give_to(conn, user, card, url) do
    # Update changeset
    user = Ecto.Changeset.change(user, %{
      last_obtained: Date.to_string(Date.utc_today),
      cards: add_card(user.cards, card.id)
    })
    # Update in Repo and redirect
    case Repo.update(user) do
      {:ok, new} ->
        conn
          |> put_session(:current_user, new)
          |> put_flash(:card, card)
          |> redirect(to: url)
      {:error, _} ->
        conn
          |> put_flash(:error, "Erreur de base de données !")
          |> redirect(to: url)
    end
  end

  # Add card to map
  defp add_card(list, id) do
    add_card(list, id, [], false)
  end

  defp add_card([%{"id" => id, "amount" => amount}|t], cardid, acc, changed) do
    {amount, changed} =
      if id == cardid do
        {amount + 1, true}
      else
        {amount, changed}
      end
    h = %{"id" => id, "amount" => amount}
    add_card(t, cardid, [h|acc], changed)
  end

  defp add_card([], cardid, acc, changed) do
    if !changed do
      Enum.reverse([%{"id" => cardid, "amount" => 1}|acc])
    else
      Enum.reverse(acc)
    end
  end

end
