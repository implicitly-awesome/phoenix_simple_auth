defmodule SimpleAuth.User do
  use SimpleAuth.Web, :model

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :is_admin, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :password_hash, :is_admin])
    |> validate_required([:email, :name, :password_hash, :is_admin])
  end
end
