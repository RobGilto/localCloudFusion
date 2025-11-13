# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :elixir_bear,
  ecto_repos: [ElixirBear.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :elixir_bear, ElixirBearWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ElixirBearWeb.ErrorHTML, json: ElixirBearWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ElixirBear.PubSub,
  live_view: [signing_salt: "y8fi39rW"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :elixir_bear, ElixirBear.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.25.4",
  elixir_bear: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.7",
  elixir_bear: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure MIME types for file uploads
config :mime, :types, %{
  # Text and documentation files
  "text/plain" => ["txt"],
  # Elixir files
  "text/x-elixir" => ["ex", "exs"],
  "text/x-eex" => ["eex", "heex", "leex"],
  # Web files
  "application/javascript" => ["js", "jsx"],
  "text/typescript" => ["ts", "tsx"],
  "text/css" => ["css", "scss"],
  "text/html" => ["html"],
  # Data files
  "application/json" => ["json"],
  "application/xml" => ["xml"],
  "text/yaml" => ["yaml", "yml"],
  "application/toml" => ["toml"],
  # Programming languages
  "text/x-python" => ["py"],
  "text/x-ruby" => ["rb"],
  "text/x-java" => ["java"],
  "text/x-go" => ["go"],
  "text/x-rust" => ["rs"],
  "text/x-c" => ["c", "h"],
  "text/x-c++" => ["cpp", "hpp"],
  "text/x-sh" => ["sh", "bash"],
  # Audio files (for future Whisper integration)
  "audio/mpeg" => ["mp3", "mpga"],
  "audio/mp4" => ["m4a"],
  "audio/wav" => ["wav"]
}

# Specify preferred MIME types for extensions that could have multiple types
config :mime, :extensions, %{
  "mp4" => "video/mp4",
  "ts" => "text/typescript",
  "sh" => "text/x-sh"
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
