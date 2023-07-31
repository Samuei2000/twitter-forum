defmodule Twitter.Repo.Migrations.AddLikeTable do
  use Ecto.Migration

  def change do
    create table("like") do
      add :user_id, references("users", on_delete: :delete_all)
      add :post_id, references("posts", on_delete: :delete_all)

      timestamps()
    end
    create index(:like, [:user_id])
    create index(:like, [:post_id])
  end
end
