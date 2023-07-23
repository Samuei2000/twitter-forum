defmodule Twitter.Repo.Migrations.AddNotNullToComment do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      modify :content ,:text, null: false
    end
  end
end
