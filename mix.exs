defmodule OpencensusEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :opencensus_ecto,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    []
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases() do
    [test: ["ecto.drop -q", "ecto.create -q", "ecto.migrate --quiet", "test"]]
  end

  defp deps do
    [
      {:telemetry, "~> 0.4.0"},
      {:opencensus, "~> 0.9.0"},
      {:ecto_sql, ">= 3.0.0", only: [:test]},
      {:postgrex, ">= 0.15.0", only: [:test]}
    ]
  end
end
