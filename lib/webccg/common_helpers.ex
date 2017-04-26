defmodule Webccg.CommonHelpers do

  # Is user logged in ?
  def logged_in?(conn) do
    !!get_user conn
  end

  # Is user admin ?
  def is_admin?(conn) do
    if logged_in?(conn) do
      get_user(conn).privilege >= 3
    else
      false
    end
  end

  # Get current username
  def get_username(conn) do
    if logged_in?(conn) do
      get_user(conn).username
    else
      nil
    end
  end

  # Get current userid
  def get_userid(conn) do
    if logged_in?(conn) do
      get_user(conn).id
    else
      nil
    end
  end

  # Get current user session
  def get_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end

  # Check if user has obtained card
  def obtained_card?(user) do
    case Date.compare(Date.utc_today, Date.from_iso8601!(user.last_obtained)) do
      :gt ->
        false
      _ ->
        true
    end
  end

  # Check if user can modify
  def can_modify?(conn, id) do
    if is_admin?(conn) or get_userid(conn) == id do
      get_user(conn)
    else
      nil
    end
  end

  # Return an adapted title
  def adapted_title(message, name) do
    if is_vowel?(String.first(name)) do
      "#{message} d'#{name}"
    else
      "#{message} de #{name}"
    end
  end

  # Check if character is vowel
  def is_vowel?(str) do
    char = String.capitalize(str)
    char == "A" or
    char == "E" or
    char == "I" or
    char == "O" or
    char == "U" or
    char == "Y"
  end

end
