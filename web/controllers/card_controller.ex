defmodule Webccg.CardController do
  use Webccg.Web, :controller

  # Create new card
  def new(conn, %{"card" => card_params}) do
    changeset = Card.changeset(%Card{}, card_params)

    case Repo.insert(changeset) do
      {:ok, new_card} ->
        conn
          |> put_flash(:info, "Carte créée avec succès !")
          |> redirect(to: "/cards")

      {:error, _} ->
        conn
          |> put_flash(:error, "Carte invalide !")
          |> redirect(to: "/cards")
    end
  end

  # Delete card
  def delete(conn, %{"cid" => card_id}) do
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
  end
end
