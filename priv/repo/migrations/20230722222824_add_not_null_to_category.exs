defmodule Twitter.Repo.Migrations.AddNotNullToCategory do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      modify :name ,:text, null: false
    end
  end
end
