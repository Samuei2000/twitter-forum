defmodule TwitterWeb.ProfileLive do

  use TwitterWeb, :live_view


  import Phoenix.HTML.Tag, only: [img_tag: 2]


  alias Twitter.Accounts


  def mount(%{"username" => username}, _session, socket) do

    case Accounts.get_user_by_username(username) do
      nil -> {:ok, push_navigate(socket, to: "/*path")}
      user ->
        posts= Twitter.Forum.list_posts_for_user(user)
        {:ok, assign(socket, user: user,posts: posts)}
    end


  end

end
