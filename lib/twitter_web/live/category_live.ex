defmodule TwitterWeb.CategoryLive do
  use TwitterWeb, :live_view

  def render(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save">
      <.input field={@form[:content]} type="textarea" class="w-full px-3 py-2 text-gray-700 border rounded-lg focus:outline-none" rows="4" placeholder="What's happening?" />
      <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded mt-3" phx-disable-with="Saving...">Post</button>
    </.form>
    <div class="mt-3">
      <%= if Enum.empty?(@posts) do %>
        <div class="text-center py-10">
        <h2 class="text-gray-500 text-2xl">Nothing to see!</h2>
        <p class="text-gray-400">This category is empty.</p>
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
      <%!-- <%= inspect(@posts) %> --%>
    </div>
    """
  end

  def mount(%{"category_name" => category_name}, _session, socket) do
    form = %Twitter.Forum.Post{} |> Ecto.Changeset.change() |> to_form
    posts = Twitter.Forum.get_category_by_category_name!(category_name)
    |> Twitter.Forum.list_posts_for_category()
    {:ok, assign(socket,posts: posts, form: form)}
  end
end
