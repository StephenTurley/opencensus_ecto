import Config

config :opencensus_ecto,
  ecto_repos: [OpencensusEcto.TestRepo]

config :opencensus_ecto, OpencensusEcto.TestRepo,
  hostname: "localhost",
  database: "opencensus_ecto_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :opencensus, sampler: {:oc_sampler_always, []}
