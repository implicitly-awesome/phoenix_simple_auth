defmodule SimpleAuth.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :name, :string
      add :password_hash, :string
      add :is_admin, :boolean, default: false, null: false

      timestamps
    end

    create unique_index(:users, [:email])
  end
end
