defmodule PlanningPoker.MixProject do
  use Mix.Project

  def project do
    [
      app: :planning_poker,
      version: "0.1.1",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      releases: [
        planning_poker: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent],
          steps: [:assemble, :tar]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PlanningPoker.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.7"},
      {:phoenix_pubsub, "~> 2.0"},
      {:postgrex, "~> 0.17"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:phoenix_live_view, "~> 0.19.5"},
      {:phoenix_live_dashboard, "~> 0.8"},
      {:telemetry_poller, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    []
  end
end
