defmodule TwitterWeb.CategoryLive do
  use TwitterWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mt-3">
      <%= if Enum.empty?(@posts) do %>
        <div class="text-center py-10">
        <h2 class="text-gray-500 text-2xl">Nothing to see!</h2>
        <p class="text-gray-400">This user hasn't posted any tweeks yet</p>
      </div>

      <% else %>
        <%= for post <- @posts do %>
          <p><%= post.title %></p>
          <p><%= post.content %></p>
          <%!-- <p><%= post.user_id %></p> --%>
          <p><%= post.user.username %></p>
          <br>
        <% end %>
      <% end %>
    </div>
    """
  end

  def mount(%{"category_name" => category_name}, _session, socket) do
    posts = Twitter.Forum.get_category_by_category_name!(category_name)
    |> Twitter.Forum.list_posts_for_category()
    {:ok, assign(socket,posts: posts)}
  end
end
