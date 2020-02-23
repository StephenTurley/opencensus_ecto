defmodule OpencensusEcto.TestRepo do
  use Ecto.Repo,
    otp_app: :opencensus_ecto,
    adapter: Ecto.Adapters.Postgres,
    telemetry_prefix: [:opencensus_ecto, :test_repo]
end
