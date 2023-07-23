defmodule TwitterWeb.CategoryLive do
  use TwitterWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Test</h1>
    <p><%= inspect @posts %></p>

    """
  end

  def mount(%{"category_name" => category_name}, _session, socket) do
    posts = Twitter.Forum.get_category_by_category_name!(category_name)
    |> Twitter.Forum.list_posts_for_category()
    {:ok, assign(socket,posts: posts)}
  end
end
