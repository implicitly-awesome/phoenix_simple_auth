defmodule SimpleAuth.Post do
  use SimpleAuth.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string

    belongs_to :user, SimpleAuth.User

    timestamps
  end

  @required_fields ~w(title)a
  @optional_fields ~w(body)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
  end
end
