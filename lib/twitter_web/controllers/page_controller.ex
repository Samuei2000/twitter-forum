defmodule TwitterWeb.PageController do
  use TwitterWeb, :controller
  import Ecto.Query
  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    cates=from(Twitter.Forum.Category) |> Twitter.Repo.all()
    render(conn, :home,cates: cates)
  end

  def index(conn, _params) do
    render(conn, :fof)
  end
end
