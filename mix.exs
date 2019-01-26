defmodule SideProjectTracker.MixProject do
  use Mix.Project

  def project do
    [
      app: :side_project_tracker,
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {SideProjectTracker.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:maru, "~> 0.13"},
      {:cowboy, "~> 2.3"},
      {:jason, "~> 1.0"},
      {:cors_plug, "~> 1.5"},
      {:distillery,
       git: "https://github.com/ardhena/distillery.git",
       branch: "fix-loading-pidfile-config-from-vm-args"},
      {:exsync, "~> 0.2", only: :dev},
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
