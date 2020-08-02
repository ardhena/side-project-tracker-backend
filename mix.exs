defmodule SideProjectTracker.MixProject do
  use Mix.Project

  def project do
    [
      app: :side_project_tracker,
      version: "1.0.0",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {SideProjectTracker.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.5.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:plug_cowboy, "~> 2.1"},
      {:plug, "~> 1.10"},
      {:cowboy, "~> 2.7.0"},
      {:jason, "~> 1.0"},
      {:cors_plug, "~> 2.0"},
      {:distillery, "~> 2.1.0"},
      {:mock, "~> 0.3.0", only: :test},
      {:meck, "~> 0.8.13", only: :test},
      {:ex_machina, "~> 2.2", only: :test}
    ]
  end

  # This makes sure your factory and any other modules in test/support are compiled
  # when in the test environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
