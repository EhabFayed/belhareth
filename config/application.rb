require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Full app: the public site is server-rendered HTML.
    config.api_only = false

    # Background jobs (mailer deliveries) run on the sidekiq container.
    config.active_job.queue_adapter = :sidekiq

    # Serve ActiveStorage files directly (200 + long cache) instead of the
    # default /blobs/redirect/... 302 to /disk/ — SEO audit requirement.
    config.active_storage.resolve_model_to_route = :rails_storage_proxy
  end
end
