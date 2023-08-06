defmodule TwitterWeb.ProfileLive do

  use TwitterWeb, :live_view


  import Phoenix.HTML.Tag, only: [img_tag: 2]


  alias Twitter.Accounts


  def mount(%{"username" => username}, _session, socket) do

    user = Accounts.get_user_by_username!(username)

    {:ok, assign(socket, :user, user)}

  end

end