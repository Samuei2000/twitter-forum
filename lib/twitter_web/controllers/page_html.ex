defmodule TwitterWeb.PageHTML do
  use TwitterWeb, :html

  embed_templates "page_html/*"

  attr :href, :string, required: true
  attr :text, :string, required: true
  attr :method, :string, default: "get"
  def navbar_link(assigns) do
    ~H"""
    <.link
      class="mb-2 sm:mb-0 sm:mr-5 text-green-700 hover:text-green-500"
      href={@href}
      method={@method}
    >
      <%= @text %>
    </.link>
    """
  end
end
