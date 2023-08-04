defmodule TwitterWeb.CommentLive do
  use TwitterWeb, :live_view


  def render(assigns) do
    ~H"""
    Hello World
    """
  end

  on_mount {TwitterWeb.UserAuth, :mount_current_user}


end
