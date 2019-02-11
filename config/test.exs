use Mix.Config

config :side_project_tracker, SideProjectTrackerWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

config :side_project_tracker, :storage_path, "/tmp"
