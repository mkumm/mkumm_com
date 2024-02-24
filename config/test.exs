import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mkumm_com, MkummComWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "oEJwE7ElD+saHwLFN18gFqTLz87g8fU/+/ZC9nBMv/+YqSeCL3SmZDLd2cqHJ1KE",
  server: false

# In test we don't send emails.
config :mkumm_com, MkummCom.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
