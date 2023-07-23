defmodule TwitterWeb.CategoryLive do
  use TwitterWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Test</h1>
    <p><%= inspect @category %></p>

    """
  end

  def mount(%{"category_name" => category_name}, _session, socket) do
    category = Twitter.Forum.get_category_by_category_name!(category_name)
    {:ok, assign(socket,category: category)}
  end
end
