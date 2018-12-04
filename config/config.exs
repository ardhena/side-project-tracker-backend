use Mix.Config

config :maru, SideProjectTracker.API, http: [port: 8800]

config :side_project_tracker, :storage_path, "."

if File.exists?("config/#{Mix.env()}.exs"), do: import_config("#{Mix.env()}.exs")
