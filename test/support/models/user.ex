defmodule OpencensusEcto.TestModels.User do
  use Ecto.Schema

  schema "users" do
    field(:email, :string)

    has_many(:posts, OpencensusEcto.TestModels.Post)
  end
end
