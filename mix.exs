defmodule SideProjectTracker.MixProject do
  use Mix.Project

  def project do
    [
      app: :side_project_tracker,
      version: "1.0.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:distillery, "~> 2.0"},
      {:exsync, "~> 0.2", only: :dev},
      {:mock, "~> 0.3.0", only: :test}
    ]
  end
end
