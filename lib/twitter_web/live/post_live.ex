defmodule TwitterWeb.PostLive do
  use TwitterWeb, :live_view

  def render(assigns) do
    ~H"""
      <%= if @post != nil do %>
          <h1>title:<%= @post.title %></h1>
          <p>content:<%= @post.content %></p>
          <p>likes:<%= @post.likes %></p>

        <%= if assigns.current_user !=nil do%>
        <.form for={@form} phx-submit="save">
          <.input field={@form[:content]} type="textarea"placeholder="Your Comment" />
          <button type="submit" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded mt-3" phx-disable-with="Saving...">Comment</button>
        </.form>
          <%= if @flag do%>
            <.button phx-click="unlike">UnLike</.button>
          <% else %>
            <.button phx-click="like">Like</.button>
          <% end %>
        <% end %>
      <% else %>
        <div class="text-center py-10">
          <h2 class="text-gray-500 text-2xl">Nothing to see!</h2>
          <p class="text-gray-400">This category is empty.</p>
        </div>
      <% end %>
    """
  end

  on_mount {TwitterWeb.UserAuth, :mount_current_user}

  def mount(%{"category_name" => category_name,"post_id" => post_id}, _session, socket) do
    post=
      case Twitter.Forum.get_category_by_category_name!(category_name) do
        nil -> nil
        _ -> Twitter.Forum.get_post!(post_id)
      end
    likes= case socket.assigns.current_user do
      nil -> nil
      _ -> Twitter.Like.check_likes_for_user(socket.assigns.current_user)
    end
    flag= case likes do
      nil -> nil
      _ -> post in likes
    end
    IO.inspect(likes)
    form = %Twitter.Forum.Comment{} |> Ecto.Changeset.change() |> to_form
    # user=socket.assigns.current_user
    # IO.inspect(user)
    # IO.inspect(form)update(socket, :flag, fn _->  false end)
    {:ok, assign(socket,post: post,form: form,flag: flag,like_num: post.likes)}
  end

  def handle_event("unlike", _unsigned_params, socket) do
    Twitter.Forum.update_post(socket.assigns.post,%{likes: socket.assigns.post.likes-1})
    user_id=socket.assigns.current_user.id
    post_id=socket.assigns.post.id
    row=Twitter.Like.get_row!(user_id,post_id)
    Twitter.Like.delete_row(row)


    socket=update(socket, :post, fn _ ->  Twitter.Forum.get_post!(post_id) end)
    {:noreply, update(socket, :flag, fn _->  false end)}
  end

  def handle_event("like", _unsigned_params, socket) do
    Twitter.Forum.update_post(socket.assigns.post,%{likes: socket.assigns.post.likes+1})
    user_id=socket.assigns.current_user.id
    post_id=socket.assigns.post.id
    Twitter.Like.create_row(%{user_id: user_id,post_id: post_id})

    socket=update(socket, :post, fn _ ->  Twitter.Forum.get_post!(post_id) end)
    {:noreply, update(socket, :flag, fn _->  true end)}
  end
end
