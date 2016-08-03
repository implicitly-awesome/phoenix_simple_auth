alias SimpleAuth.Repo
alias SimpleAuth.User

admin_params = %{name: "Admin User",
                 email: "admin@test.com",
                 password: "123123",
                 is_admin: true}

unless Repo.get_by(User, email: admin_params[:email]) do
  %User{}
  |> User.registration_changeset(admin_params)
  |> Repo.insert!
end
