defmodule TwitterWeb.CategoryLive do
  use TwitterWeb, :live_view

  def render(assigns) do
    ~H"""
    <%= if assigns.current_user !=nil do%>
      <.form for={@form} phx-submit="save">
        <.input field={@form[:title]} type="textarea" class="w-full px-3 py-2 text-gray-700 border rounded-lg focus:outline-none" rows="4" placeholder="Your Title" />
        <.input field={@form[:content]} type="textarea" class="w-full px-3 py-2 text-gray-700 border rounded-lg focus:outline-none" rows="4" placeholder="What's happening?" />
        <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded mt-3" phx-disable-with="Saving...">Post</button>
      </.form>
    <% end %>
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

  on_mount {TwitterWeb.UserAuth, :mount_current_user}

  def mount(%{"category_name" => category_name}, _session, socket) do
    form = %Twitter.Forum.Post{} |> Ecto.Changeset.change() |> to_form
    posts = Twitter.Forum.get_category_by_category_name!(category_name)
      |> Twitter.Forum.list_posts_for_category()
    category_id= Twitter.Forum.get_category_by_category_name!(category_name).id
    # user=socket.assigns.current_user
    # IO.inspect(user)
    # IO.inspect(form)
    {:ok, assign(socket,posts: posts, form: form,category_id: category_id)}
  end

  def handle_event("save", %{"post"=> post_params}, socket) do
    current_user = socket.assigns.current_user
    # IO.inspect(post_params)
    category_id=socket.assigns.category_id
    case Twitter.Forum.create_post_for_user(current_user,post_params,category_id) do
      {:ok, post} ->
        {:noreply, update(socket, :posts, fn posts->  [post | posts] end)}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
