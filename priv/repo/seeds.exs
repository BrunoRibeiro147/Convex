Core.Repo.insert!(%Core.Schemas.User{
  id: Ecto.UUID.generate(),
  name: "Bruno Ribeiro"
})
