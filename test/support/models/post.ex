defmodule OpencensusEcto.TestModels.Post do
  use Ecto.Schema

  schema "posts" do
    field(:body, :string)
    belongs_to(:user, OpencensusEcto.TestModels.User)
  end
end
