defmodule Twitter.Repo.Migrations.AddDefaultLikesToComment do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      modify :likes, :integer, null: false
    end
  end
end
