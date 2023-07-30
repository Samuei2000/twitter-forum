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
        <.table id="users" rows={@posts}>
          <:col :let={post} label="title"><%= post.title %></:col>
          <:col :let={post} label="username"><%= post.user.username %></:col>
          <:col :let={post} label="created at"><%= post_inserted_at(post) %></:col>
          <%!-- <:col :let={post} label="updated at"><%= post.updated_at.year %>-<%= post.updated_at.month%>-<%= post.updated_at.day%> <%= post.updated_at.hour%>:<%= post.updated_at.minute%>:<%= post.updated_at.second%></:col> --%>
          <:col :let={post} label="likes"><%= post.likes %></:col>
          <:col :let={post} label="views"><%= post.views %></:col>
          <:action :let={post}>
            <.link navigate={~p"/#{@category_name}/posts/#{post.id}"} class="text-sky-500 hover:underline">
              <%!-- <.button phx-click="view" phx-value-post="#{post.id}">View</.button> --%>
              View
            </.link>
          </:action>
        </.table>
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
    {:ok, assign(socket,posts: posts, form: form,category_id: category_id,category_name: category_name)}
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

  def handle_event("view", %{"post" => post_id}, socket) do
    IO.inspect(post_id)


    {:noreply, socket}
  end

  def post_inserted_at(%Twitter.Forum.Post{inserted_at: timestamp}) do

    Calendar.strftime(timestamp, "%m/%d/%Y %I:%M%p")

  end
end
