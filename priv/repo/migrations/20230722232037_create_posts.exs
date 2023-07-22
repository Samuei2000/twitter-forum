defmodule Twitter.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :text, null: false
      add :content, :text, null: false
      add :views, :integer, default: 0
      add :likes, :integer, default: 0
      add :user_id, references(:users, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)

      timestamps()
    end

    create index(:posts, [:user_id])
    create index(:posts, [:category_id])
  end
end
