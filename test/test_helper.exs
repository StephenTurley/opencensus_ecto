Application.ensure_all_started(:opencensus)
Application.ensure_all_started(:telemetry)
OpencensusEcto.TestRepo.start_link()

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(OpencensusEcto.TestRepo, :manual)
