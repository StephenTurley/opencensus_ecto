defmodule OpencensusEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :opencensus_ecto,
      description: description(),
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      source_url: "https://github.com/seancribbs/opencensus_ecto"
    ]
  end

  defp description do
    "Trace Ecto queries with Opencensus."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/seancribbs/opencensus_ecto"}
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
      {:ex_doc, "~> 0.21.0", only: [:dev], runtime: false},
      {:ecto_sql, ">= 3.0.0", only: [:test]},
      {:postgrex, ">= 0.15.0", only: [:test]}
    ]
  end
end
