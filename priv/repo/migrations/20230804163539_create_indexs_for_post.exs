defmodule Twitter.Repo.Migrations.CreateIndexForPost do
  use Ecto.Migration

  def change do
    create index(:posts, [:views])
    create index(:posts, [:likes])
  end
end
