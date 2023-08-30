defmodule Twitter.Repo.Migrations.AddRelationshipsTable do
  use Ecto.Migration

  def change do
    create table(:relationships) do
      add :child_comment_id, references(:comments, on_delete: :delete_all)
      add :parent_comment_id, references(:comments, on_delete: :delete_all)

      timestamps()
    end

    create index(:relationships, [:child_comment_id])
    create index(:relationships, [:parent_comment_id])
    create index(:relationships, [:parent_comment_id,:child_comment_id])
    create index(:relationships, [:child_comment_id,:parent_comment_id])
  end
end
