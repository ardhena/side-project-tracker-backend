use Mix.Config

config :phoenix, :json_library, Jason

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :side_project_tracker, :storage_path, "."

if File.exists?("config/#{Mix.env()}.exs"), do: import_config("#{Mix.env()}.exs")
