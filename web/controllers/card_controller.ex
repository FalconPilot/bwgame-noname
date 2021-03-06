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
      redirect_admin(conn, "/cards")
    end
  end

  # Delete card
  def delete(conn, %{"delete-card" => params}) do
    if is_admin?(conn) do
      cardid = params["id"]
      query = from(c in Card, [where: c.id == ^cardid])
      case Repo.delete_all(query) do
        {1, _} ->
          Enum.each(Repo.all(User), fn(user) ->
            user = Ecto.Changeset.change(user, %{
              cards: CardHelpers.remove_card(user.cards, cardid)
            })
            Repo.update!(user)
          end)
          # Redirect
          conn
            |> put_flash(:info, "Carte ##{cardid} supprimée avec succès !")
            |> redirect(to: "/cards")
        {0, _} ->
          conn
            |> put_flash(:error, "La carte n'existe pas !")
            |> redirect(to: "/cards")
      end
    else
      redirect_admin(conn, "/cards")
    end
  end

  # Get random card
  def obtain(conn, %{"obtain-card" => params}) do
    userid = params["id"]
    if obtain_valid?(conn, userid) do
      url =
        if params["redirect_url"] do
          params["redirect_url"]
        else
          "/users/#{userid}"
        end
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
  def give_card(conn, %{"give-card" => %{"id" => cardid, "username" => username}}) do
    case Repo.get_by(Card, id: cardid) do
      nil ->
        conn
          |> put_flash(:error, "Carte ##{cardid} inexistante !")
          |> redirect(to: "/cards")
      card ->
        case Repo.get_by(User, username: username) do
          nil ->
            conn
              |> put_flash(:error, "Utilisateur #{username} inexistant !")
              |> redirect(to: "/cards")
          user ->
            give_to(conn, user, card, "/cards", false)
        end
    end
  end

  # Reorder card IDs
  def reorder_ids(conn, _params) do
    if is_admin?(conn) do
      query = from(c in Card, [order_by: c.inserted_at])
      cards = Repo.all(query)
      # Reordering operation
      Enum.each(Enum.with_index(cards), fn({x, i}) ->
        card = Ecto.Changeset.change(x, display_id: i + 1)
        Repo.update!(card)
      end)
      # Redirect
      conn
        |> put_flash(:info, "ID des cartes réordonnés")
        |> redirect(to: "/cards")
    else
      redirect_admin(conn, "/cards")
    end
  end

  # Give card to user
  defp give_to(conn, user, card, url, notice \\ true) do
    # Update changeset
    user =
      if notice do
        Ecto.Changeset.change(user, %{
          last_obtained: Date.to_string(Date.utc_today),
          cards: CardHelpers.add_card(user.cards, card.id)
        })
      else
        Ecto.Changeset.change(user, %{
          cards: CardHelpers.add_card(user.cards, card.id)
        })
      end
    # Update in Repo and redirect
    case Repo.update(user) do
      {:ok, new} ->
        # Redirect
        if notice do
          conn
            |> put_session(:current_user, new)
            |> put_flash(:card, card)
            |> redirect(to: url)
        else
          conn
            |> put_session(:current_user, new)
            |> put_flash(:info, "Carte \"#{card.name}\" donnée à \"#{new.username}\"")
            |> redirect(to: url)
        end
      {:error, _} ->
        conn
          |> put_flash(:error, "Erreur de base de données !")
          |> redirect(to: url)
    end
  end

end
