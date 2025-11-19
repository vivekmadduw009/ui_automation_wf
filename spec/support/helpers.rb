# spec/support/helpers.rb
require 'yaml'
require 'erb'

module Helpers
  def app_host
    ENV['APP_HOST'] || YAML.load(
      ERB.new(File.read(File.join(File.dirname(__FILE__), '..', '..', 'config', 'test_data.yml'))).result
    )['app_host']
  rescue StandardError
    Capybara.app_host
  end

  def config_credentials
    YAML.load(
      ERB.new(File.read(File.join(File.dirname(__FILE__), '..', '..', 'config', 'test_data.yml'))).result
    )['credentials']
  end
end

RSpec.configure do |config|
  config.include Helpers
end