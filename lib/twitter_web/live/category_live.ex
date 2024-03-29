defmodule TwitterWeb.CategoryLive do
  use TwitterWeb, :live_view
  import Phoenix.HTML.Tag, only: [img_tag: 2]
  def render(assigns) do
    ~H"""
    <%= if assigns.current_user !=nil do%>
      <.form for={@form} phx-submit="save" phx-change="validate">
        <.input field={@form[:title]} type="textarea" class="w-full px-3 py-2 text-gray-700 border rounded-lg focus:outline-none" rows="4" placeholder="Your Title" />
        <.input field={@form[:content]} type="textarea" class="w-full px-3 py-2 text-gray-700 border rounded-lg focus:outline-none" rows="4" placeholder="What's happening?" />
        <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded mt-3" phx-disable-with="Saving...">Post</button>
      </.form>
    <% end %>


      <%= if @empty do %>
        <div class="text-center py-10">
          <h2 class="text-gray-500 text-2xl">Nothing to see!</h2>
          <p class="text-gray-400">This category is empty.</p>
        </div>

      <% else %>
        <div class="mt-3" id="posts" phx-update="stream">
          <%= for {post_id,post} <- @streams.posts do %>
            <div class="bg-white p-5 rounded-lg shadow mb-3" id={post_id}>
              <div class="flex justify-between items-center">
                <div class="flex items-center">
                  <div class="ml-3">
                  <%= img_tag ~p"/images/default_avatar.png", class: "h-20 w-20 rounded", alt: "Avatar" %>
                    <h2 class="font-bold text-lg">@<%= post.user.username %></h2>
                    <p class="text-gray-400 ml-2"><%= TwitterWeb.CategoryLive.post_inserted_at(post) %></p>
                    <h2 class="font-bold text-lg"><%= post.title %></h2>

                  </div>
                </div>
              </div>
              <p class="mt-3 text-gray-700">
                <%= post.content %>
              </p>
              <div>
                <.button phx-click="view" phx-value-post={post.id}>View</.button>
                <h2 class="font-bold text-lg">Views:<%= post.views %></h2>
                <h2 class="font-bold text-lg">Likes:<%= post.likes %></h2>
                <h2 class="font-bold text-lg">Comments:<%= length(post.comments) %></h2>
              </div>
            </div>
          <% end %>
        </div>
      <% end %>
    """
  end

  on_mount {TwitterWeb.UserAuth, :mount_current_user}

  def mount(%{"category_name" => category_name}, _session, socket) do
    if connected?(socket) do
      Twitter.Forum.subscribe()
    end

    case Twitter.Forum.get_category_by_category_name(category_name) do
      nil -> {:ok, push_navigate(socket, to: "/*path")}
      category -> posts= category |> Twitter.Forum.list_posts_for_category()
                  form = %Twitter.Forum.Post{} |> Ecto.Changeset.change() |> to_form
                  category_id= category.id
                  empty = Enum.empty?(posts)
                  socket=socket
                    |> stream(:posts, posts)
                    |> assign(:form, form)
                    |> assign(:category_id, category_id)
                    |> assign(:category_name, category_name)
                    |> assign(:empty, empty)
                  {:ok, socket}
    end
  end

  def handle_event("save", %{"post"=> post_params}, socket) do
    current_user = socket.assigns.current_user

    category_id=socket.assigns.category_id
    case Twitter.Forum.create_post_for_user(current_user,post_params,category_id) do
      {:ok, _post} ->
        socket=update(socket, :form, fn _ -> %Twitter.Forum.Post{} |> Ecto.Changeset.change() |> to_form end)
        socket=update(socket, :empty, fn _ -> false end)
        # socket=stream_insert(socket, :posts, post, at: 0)
        {:noreply, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("view", %{"post" => post_id}, socket) do
    post=Twitter.Forum.get_post!(post_id)
    Twitter.Forum.update_post(post,%{views: post.views+1})
    {:noreply, push_navigate(socket, to: ~p"/category/#{socket.assigns.category_name}/posts/#{post_id}")}
  end

  def handle_event("validate", %{"post" => volunteer_params}, socket) do
    changeset =
      %Twitter.Forum.Post{}
      |> Twitter.Forum.change_post(volunteer_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def post_inserted_at(%Twitter.Forum.Post{inserted_at: timestamp}) do

    Calendar.strftime(timestamp, "%m/%d/%Y %I:%M%p")

  end

  def handle_info({:post_created,post}, socket) do
    {:noreply, stream_insert(socket,:posts, post,at: 0)}
  end
end
