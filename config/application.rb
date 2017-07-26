require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Twgb
  class Application < Rails::Application
    config.time_zone = 'Eastern Time (US & Canada)'

    # TwGB[Host]
    config.twgb_host_hostname = ENV['TWGB_HOST_HOSTNAME']
    config.twgb_host_username = ENV['TWGB_HOST_USERNAME']
    config.twgb_host_pathname = ENV['TWGB_HOST_PATHNAME']
    config.twgb_host_ssh_key = ENV['TWGB_HOST_SSH_KEY']

    # lib folder
    config.autoload_paths += %W(#{config.root}/lib)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
